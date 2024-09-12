#' @noRd
#' @description A class for methods wrapping GitHub's GraphQL API responses.
EngineGraphQLGitHub <- R6::R6Class("EngineGraphQLGitHub",
    inherit = EngineGraphQL,
    public = list(

    #' Create `EngineGraphQLGitHub` object.
    initialize = function(gql_api_url,
                          token,
                          scan_all = FALSE) {
      super$initialize(gql_api_url = gql_api_url,
                       token = token,
                       scan_all = scan_all)
      self$gql_query <- GQLQueryGitHub$new()
    },

    #' Get all orgs from GitHub.
    pull_orgs = function() {
      end_cursor <- NULL
      has_next_page <- TRUE
      full_orgs_list <- list()
      while (has_next_page) {
        response <- self$gql_response(
          gql_query = self$gql_query$orgs(
            end_cursor = end_cursor
          )
        )
        if (length(response$errors) > 0) {
          cli::cli_abort(
            response$errors[[1]]$message
          )
        }
        orgs_list <- purrr::map(response$data$search$edges, ~stringr::str_match(.$node$url, "[^\\/]*$"))
        full_orgs_list <- append(full_orgs_list, orgs_list)
        has_next_page <- response$data$search$pageInfo$hasNextPage
        end_cursor <- response$data$search$pageInfo$endCursor
      }
      all_orgs <- unlist(full_orgs_list)
      return(all_orgs)
    },

    # Pull all repositories from organization
    get_repos_from_org = function(org = NULL) {
      full_repos_list <- list()
      next_page <- TRUE
      repo_cursor <- ""
      while (next_page) {
        repos_response <- private$pull_repos_page(
          org = org,
          repo_cursor = repo_cursor
        )
        repositories <- repos_response$data$repositoryOwner$repositories
        repos_list <- repositories$nodes
        next_page <- repositories$pageInfo$hasNextPage
        if (is.null(next_page)) next_page <- FALSE
        if (is.null(repos_list)) repos_list <- list()
        if (next_page) {
          repo_cursor <- repositories$pageInfo$endCursor
        } else {
          repo_cursor <- ""
        }
        full_repos_list <- append(full_repos_list, repos_list)
      }
      return(full_repos_list)
    },

    # Iterator over pulling commits from all repositories.
    pull_commits_from_repos = function(org,
                                       repos_names,
                                       since,
                                       until,
                                       verbose) {
      repos_list_with_commits <- purrr::map(repos_names, function(repo) {
        private$pull_commits_from_one_repo(
          org = org,
          repo = repo,
          since = since,
          until = until
        )
      }, .progress = !private$scan_all && verbose)
      names(repos_list_with_commits) <- repos_names
      repos_list_with_commits <- repos_list_with_commits %>%
        purrr::discard(~ length(.) == 0)
      return(repos_list_with_commits)
    },

    # Pull all given files from all repositories of an organization.
    get_files_from_org = function(org,
                                  repos,
                                  file_paths,
                                  host_files_structure,
                                  only_text_files,
                                  verbose = FALSE) {
      repo_data <- private$get_repos_data(
        org = org,
        repos = repos
      )
      repositories <- repo_data[["repositories"]]
      def_branches <- repo_data[["def_branches"]]
      org_files_list <- purrr::map2(repositories, def_branches, function(repo, def_branch) {
        if (!is.null(host_files_structure)) {
          file_paths <- private$get_path_from_files_structure(
            host_files_structure = host_files_structure,
            only_text_files = only_text_files,
            org = org,
            repo = repo
          )
        } else if (is.null(host_files_structure) && only_text_files) {
          file_paths <- file_paths[!grepl(non_text_files_pattern, file_paths)]
        }
        repo_files_list <- purrr::map(file_paths, function(file_path) {
          private$get_file_response(
            org = org,
            repo = repo,
            def_branch = def_branch,
            file_path = file_path,
            files_query = self$gql_query$file_blob_from_repo()
          )
        }) %>%
          purrr::map(~ .$data$repository)
        names(repo_files_list) <- file_paths
        return(repo_files_list)
      }, .progress = verbose)
      names(org_files_list) <- repositories
      for (file_path in file_paths) {
        org_files_list <- purrr::discard(org_files_list, ~ length(.[[file_path]]$file) == 0)
      }
      return(org_files_list)
    },

    # Pull all files from all repositories of an organization.
    get_files_structure_from_org = function(org, repos, pattern = NULL, depth = Inf, verbose = FALSE) {
      repo_data <- private$get_repos_data(
        org = org,
        repos = repos
      )
      repositories <- repo_data[["repositories"]]
      def_branches <- repo_data[["def_branches"]]
      files_structure <- purrr::map2(repositories, def_branches, function(repo, def_branch) {
        private$get_files_structure_from_repo(
          org = org,
          repo = repo,
          def_branch = def_branch,
          pattern = pattern,
          depth = depth
        )
      }, .progress = verbose)
      names(files_structure) <- repositories
      files_structure <- purrr::discard(files_structure, ~ length(.) == 0)
      return(files_structure)
    },

    # Pull release logs from organization
    pull_release_logs_from_org = function(repos_names, org) {
      release_responses <- purrr::map(repos_names, function(repository) {
        releases_from_repo_query <- self$gql_query$releases_from_repo()
        response <- self$gql_response(
          gql_query = releases_from_repo_query,
          vars = list(
            "org" = org,
            "repo" = repository
          )
        )
        return(response)
      }) %>%
        purrr::discard(~ length(.$data$repository$releases$nodes) == 0)
      return(release_responses)
    }
  ),
    private = list(

      # Wrapper over building GraphQL query and response.
      pull_repos_page = function(org = NULL,
                                 repo_cursor = "") {
        repos_query <- self$gql_query$repos_by_org(
          repo_cursor = repo_cursor
        )
        response <- self$gql_response(
          gql_query = repos_query,
          vars = list("org" = org)
        )
        return(response)
      },

      # An iterator over pulling commit pages from one repository.
      pull_commits_from_one_repo = function(org,
                                            repo,
                                            since,
                                            until) {
        next_page <- TRUE
        full_commits_list <- list()
        commits_cursor <- ""
        while (next_page) {
          commits_response <- private$pull_commits_page_from_repo(
            org = org,
            repo = repo,
            since = since,
            until = until,
            commits_cursor = commits_cursor
          )
          commits_list <- commits_response$data$repository$defaultBranchRef$target$history$edges
          next_page <- commits_response$data$repository$defaultBranchRef$target$history$pageInfo$hasNextPage
          if (is.null(next_page)) next_page <- FALSE
          if (is.null(commits_list)) commits_list <- list()
          if (next_page) {
            commits_cursor <- commits_response$data$repository$defaultBranchRef$target$history$pageInfo$endCursor
          } else {
            commits_cursor <- ""
          }
          full_commits_list <- append(full_commits_list, commits_list)
        }
        return(full_commits_list)
      },

      # Wrapper over building GraphQL query and response.
      pull_commits_page_from_repo = function(org,
                                             repo,
                                             since,
                                             until,
                                             commits_cursor = "",
                                             author_id = "") {
        commits_by_org_query <- self$gql_query$commits_by_repo(
          org = org,
          repo = repo,
          since = date_to_gts(since),
          until = date_to_gts(until),
          commits_cursor = commits_cursor,
          author_id = author_id
        )
        response <- self$gql_response(
          gql_query = commits_by_org_query
        )
        return(response)
      },

      get_repos_data = function(org, repos = NULL) {
        repos_list <- self$get_repos_from_org(
          org = org
        )
        if (!is.null(repos)) {
          repos_list <- purrr::keep(repos_list, ~ .$repo_name %in% repos)
        }
        result <- list(
          "repositories" = purrr::map(repos_list, ~ .$repo_name),
          "def_branches" = purrr::map(repos_list, ~ .$default_branch$name)
        )
        return(result)
      },

      get_file_response = function(org, repo, def_branch, file_path, files_query) {
        expression <- paste0(def_branch, ":", file_path)
        files_response <- self$gql_response(
          gql_query = files_query,
          vars = list(
            "org" = org,
            "repo" = repo,
            "expression" = expression
          )
        )
        return(files_response)
      },

      get_files_structure_from_repo = function(org, repo, def_branch, pattern = NULL, depth = Inf) {
        files_tree_response <- private$get_file_response(
          org = org,
          repo = repo,
          def_branch = def_branch,
          file_path = "",
          files_query = self$gql_query$files_tree_from_repo()
        )
        files_and_dirs_list <- private$get_files_and_dirs(
          files_tree_response = files_tree_response
        )
        if (length(files_and_dirs_list$dirs) > 0) {
          folders_exist <- TRUE
        } else {
          folders_exist <- FALSE
        }
        all_files_and_dirs_list <- files_and_dirs_list
        dirs <- files_and_dirs_list$dirs
        tier <- 1
        while (folders_exist && tier < depth) {
          new_dirs_list <- c()
          for (dir in dirs) {
            files_tree_response <- private$get_file_response(
              org = org,
              repo = repo,
              def_branch = def_branch,
              file_path = dir,
              files_query = self$gql_query$files_tree_from_repo()
            )
            files_and_dirs_list <- private$get_files_and_dirs(
              files_tree_response = files_tree_response
            )
            all_files_and_dirs_list$files <- append(
              all_files_and_dirs_list$files,
              paste0(dir, "/", files_and_dirs_list$files)
            )
            if (length(files_and_dirs_list$dirs) > 0) {
              new_dirs_list <- c(new_dirs_list, paste0(dir, "/", files_and_dirs_list$dirs))
            }
          }
          if (length(new_dirs_list) > 0) {
            dirs <- new_dirs_list
            folders_exist <- TRUE
            tier <- tier + 1
          } else {
            folders_exist <- FALSE
          }
        }
        if (!is.null(pattern)) {
          files_structure <- private$filter_files_by_pattern(
            files_structure = all_files_and_dirs_list$files,
            pattern = pattern
          )
        } else {
          files_structure <- all_files_and_dirs_list$files
        }
        return(files_structure)
      },

      get_files_and_dirs = function(files_tree_response) {
        entries <- files_tree_response$data$repository$object$entries
        dirs <- purrr::keep(entries, ~ .$type == "tree") %>%
          purrr::map_vec(~ .$name)
        files <- purrr::discard(entries, ~ .$type == "tree") %>%
          purrr::map_vec(~ .$name)
        result <- list(
          "dirs" = dirs,
          "files" = files
        )
        return(result)
      }
    )
)
