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
    pull_repos_from_org = function(org = NULL) {
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
                                       date_from,
                                       date_until) {
      repos_list_with_commits <- purrr::map(repos_names, function(repo) {
        private$pull_commits_from_one_repo(
          org,
          repo,
          date_from,
          date_until
        )
      }, .progress = !private$scan_all)
      names(repos_list_with_commits) <- repos_names
      repos_list_with_commits <- repos_list_with_commits %>%
        purrr::discard(~ length(.) == 0)
      return(repos_list_with_commits)
    },

    # Pull all given files from all repositories of an organization.
    pull_files_from_org = function(org, repos, file_path) {
      repos_list <- self$pull_repos_from_org(
        org = org
      )
      if (!is.null(repos)) {
        repos_list <- purrr::keep(repos_list, ~ .$repo_name %in% repos)
      }
      repositories <- purrr::map(repos_list, ~ .$repo_name)
      def_branches <- purrr::map(repos_list, ~ .$default_branch$name)
      files_list <- purrr::map(file_path, function(file_path) {
        files_list <- purrr::map2(repositories, def_branches, function(repository, def_branch) {
          files_query <- self$gql_query$files_by_repo()
          files_response <- self$gql_response(
            gql_query = files_query,
            vars = list(
              "org" = org,
              "repo" = repository,
              "file_path" = paste0(def_branch, ":", file_path)
            )
          )
        }) %>%
          purrr::map(~ .$data$repository)
        names(files_list) <- repositories
        files_list <- purrr::discard(files_list, ~ length(.$object) == 0)
        return(files_list)
      })
      names(files_list) <- file_path
      return(files_list)
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
                                            date_from,
                                            date_until) {
        next_page <- TRUE
        full_commits_list <- list()
        commits_cursor <- ""
        while (next_page) {
          commits_response <- private$pull_commits_page_from_repo(
            org = org,
            repo = repo,
            date_from = date_from,
            date_until = date_until,
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
                                             date_from,
                                             date_until,
                                             commits_cursor = "",
                                             author_id = "") {
        commits_by_org_query <- self$gql_query$commits_by_repo(
          org = org,
          repo = repo,
          since = date_to_gts(date_from),
          until = date_to_gts(date_until),
          commits_cursor = commits_cursor,
          author_id = author_id
        )
        response <- self$gql_response(
          gql_query = commits_by_org_query
        )
        return(response)
      }
    )
)
