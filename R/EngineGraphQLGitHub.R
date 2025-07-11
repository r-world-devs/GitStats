#' @noRd
#' @description A class for methods wrapping GitHub's GraphQL API responses.
EngineGraphQLGitHub <- R6::R6Class(
  classname = "EngineGraphQLGitHub",
  inherit = EngineGraphQL,
  public = list(

    #' Create `EngineGraphQLGitHub` object.
    initialize = function(gql_api_url,
                          token,
                          scan_all = FALSE) {
      super$initialize(
        gql_api_url = gql_api_url,
        token = token,
        scan_all = scan_all
      )
      self$gql_query <- GQLQueryGitHub$new()
    },

    # Set owner type
    set_owner_type = function(owners) {
      user_or_org_query <- self$gql_query$user_or_org_query
      login_types <- purrr::map(owners, function(owner) {
        response <- self$gql_response(
          gql_query = user_or_org_query,
          vars = list(
            "login" = owner
          )
        )
        if (length(response$errors) < 2) {
          type <- purrr::discard(response$data, is.null) |>
            names()
          attr(owner, "type") <- type
        } else {
          attr(owner, "type") <- "not found"
        }
        return(owner)
      })
      return(login_types)
    },

    #' Get all orgs from GitHub.
    get_orgs = function(output = c("only_names", "full_table"), verbose) {
      if (verbose) {
        cli::cli_alert("[Host:GitHub][Engine:{cli::col_yellow('GraphQL')}] Pulling organizations...")
      }
      end_cursor <- ""
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
        if (output == "only_names") {
          orgs_list <- purrr::map(response$data$search$edges, ~ .$node$login)
        } else {
          orgs_list <- purrr::map(response$data$search$edges, ~ .$node)
        }
        full_orgs_list <- append(full_orgs_list, orgs_list)
        has_next_page <- response$data$search$pageInfo$hasNextPage
        end_cursor <- response$data$search$pageInfo$endCursor
      }
      all_orgs <- if (output == "only_names") {
        unlist(full_orgs_list)
      } else {
        full_orgs_list
      }
      return(all_orgs)
    },

    prepare_orgs_table = function(full_orgs_list) {
      orgs_table <- purrr::map(full_orgs_list, function(orgs_node) {
        orgs_node$description <- orgs_node$description %||% ""
        orgs_node$repos_count <- orgs_node$repositories$totalCount
        orgs_node$members_count <- orgs_node$membersWithRole$totalCount
        orgs_node$membersWithRole <- NULL
        orgs_node$repositories <- NULL
        data.frame(orgs_node)
      }) |>
        purrr::list_rbind() |>
        dplyr::rename(path = login,
                      avatar_url = avatarUrl) |>
        dplyr::relocate(description, .after = name) |>
        tibble::as_tibble()
      return(orgs_table)
    },

    # This method is for pulling orgs when host has set orgs
    get_org = function(org) {
      response <- self$gql_response(
        gql_query = self$gql_query$org(),
        vars = list("org" = org)
      )
      return(response$data$organization)
    },

    # Pull all repositories from organization
    get_repos = function(repos_ids, verbose) {
      repos_query <- self$gql_query$repos_by_ids()
      if (length(repos_ids) > 100) {
        iterations_number <- ceiling(length(repos_ids) / 100)
        x <- 1
        repos_nodes <- purrr::map(c(1:iterations_number), function(i) {
          if (i == iterations_number) {
            repos_ids_length <- length(repos_ids)
          } else {
            repos_ids_length <- i * 100
          }
          repos_response <- self$gql_response(
            gql_query = repos_query,
            vars = list(
              "ids" = repos_ids[x:repos_ids_length]
            )
          )
          x <<- x + 100
          return(repos_response$data$nodes)
        }) |>
          purrr::list_flatten()
      } else {
        repos_response <- self$gql_response(
          gql_query = repos_query,
          vars = list(
            "ids" = repos_ids
          )
        )
        repos_nodes <- repos_response$data$nodes
      }
      return(repos_nodes)
    },

    # Pull all repositories from organization
    get_repos_from_org = function(org = NULL,
                                  owner_type = c("organization", "user"),
                                  verbose = TRUE) {
      full_repos_list <- list()
      next_page <- TRUE
      repo_cursor <- ""
      while (next_page) {
        repos_response <- private$get_repos_page(
          login = org,
          type = owner_type,
          repo_cursor = repo_cursor
        )
        repositories <- if (owner_type == "organization") {
          repos_response$data$repositoryOwner$repositories
        } else {
          repos_response$data$user$repositories
        }
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

    # Parses repositories list into table.
    # org parameter is empty for GitHub but is needed for GitLab class.
    prepare_repos_table = function(repos_list, org) {
      if (length(repos_list) > 0) {
        repos_table <- purrr::map(repos_list, function(repo) {
          default_branch <- if (!is.null(repo$default_branch)) {
            repo$default_branch$name
          } else {
            ""
          }
          last_activity_at <- as.POSIXct(repo$last_activity_at)
          if (length(last_activity_at) == 0) {
            last_activity_at <- gts_to_posixt(repo$created_at)
          }
          data.frame(
            repo_id = repo$repo_id,
            repo_name = repo$repo_name,
            default_branch = default_branch,
            stars = repo$stars,
            forks = repo$forks,
            created_at = gts_to_posixt(repo$created_at),
            last_activity_at = last_activity_at,
            languages = purrr::map_chr(repo$languages$nodes, ~ .$name) |>
              paste0(collapse = ", "),
            issues_open = repo$issues_open$totalCount,
            issues_closed = repo$issues_closed$totalCount,
            organization = repo$organization$login,
            repo_url = repo$repo_url
          )
        }) |>
          purrr::list_rbind()
      } else {
        repos_table <- NULL
      }
      return(repos_table)
    },

    # Iterator over pulling commits from all repositories.
    get_commits_from_repos = function(org,
                                      repos_names,
                                      since,
                                      until,
                                      progress) {
      repos_list_with_commits <- purrr::map(repos_names, function(repo) {
        private$get_commits_from_one_repo(
          org   = org,
          repo  = repo,
          since = since,
          until = until
        )
      }, .progress = !private$scan_all && progress)
      names(repos_list_with_commits) <- repos_names
      repos_list_with_commits <- repos_list_with_commits %>%
        purrr::discard(~ length(.) == 0)
      return(repos_list_with_commits)
    },

    # Parses repositories' list with commits into table of commits.
    prepare_commits_table = function(repos_list_with_commits,
                                     org) {
      commits_table <- purrr::imap(repos_list_with_commits, function(repo, repo_name) {
        commits_row <- purrr::map(repo, function(commit) {
          if (!is.null(commit$node)) {
            commit_author <- commit$node$author
            data.frame(
              id = commit$node$id,
              committed_date = gts_to_posixt(commit$node$committed_date),
              author = commit_author$name,
              author_login = commit_author$user$login %||% NA_character_,
              author_name = commit_author$user$name %||% NA_character_,
              additions = commit$node$additions,
              deletions = commit$node$deletions,
              repo_url = commit$node$repository$url
            )
          } else {
            NULL
          }
        }) |>
          purrr::list_rbind()
        commits_row$repo_name <- repo_name
        commits_row
      }) |>
        purrr::discard(~ length(.) == 1) |>
        purrr::list_rbind()
      if (nrow(commits_table) > 0) {
        commits_table <- commits_table |>
          dplyr::mutate(
            organization = org,
            api_url = self$gql_api_url
          ) |>
          dplyr::relocate(
            repo_name,
            .before = id
          ) |>
          dplyr::relocate(
            any_of(c("author_login", "author_name")),
            .after = author
          ) |>
          dplyr::relocate(
            repo_url,
            .before = api_url
          )
      }
      commits_table <- private$fill_empty_authors(commits_table)
      return(commits_table)
    },

    # Pull all given files from all repositories of an organization.
    get_files_from_org = function(org,
                                  owner_type,
                                  repos,
                                  file_paths = NULL,
                                  host_files_structure = NULL,
                                  verbose = TRUE,
                                  progress = TRUE) {
      repo_data <- private$get_repos_data(
        org = org,
        owner_type = owner_type,
        repos = repos
      )
      repositories <- repo_data[["repositories"]]
      def_branches <- repo_data[["def_branches"]]
      org_files_list <- private$get_repositories_with_files(
        repositories = repositories,
        def_branches = def_branches,
        org = org,
        file_paths = file_paths,
        host_files_structure = host_files_structure,
        progress = progress
      )
      names(org_files_list) <- repositories
      for (file_path in file_paths) {
        org_files_list <- purrr::discard(org_files_list, ~ length(.[[file_path]]$file) == 0)
      }
      return(org_files_list)
    },

    # Prepare files table.
    prepare_files_table = function(files_response, org) {
      if (!is.null(files_response)) {
        files_table <- purrr::map(files_response, function(repository) {
          purrr::discard(repository, ~ length(.$file) == 0) |>
            purrr::imap(function(file_data, file_name) {
              data.frame(
                "repo_id" = file_data$repo_id,
                "repo_name" = file_data$repo_name,
                "organization" = org,
                "file_path" = file_name,
                "file_content" = file_data$file$text %||% NA,
                "file_size" = file_data$file$byteSize,
                "repo_url" = file_data$repo_url
              )
            }) |>
            purrr::list_rbind()
        }) |>
          purrr::list_rbind()
      } else {
        files_table <- NULL
      }
      return(files_table)
    },

    # Pull all files from all repositories of an organization.
    get_files_structure_from_org = function(org,
                                            owner_type,
                                            repos = NULL,
                                            pattern = NULL,
                                            depth = Inf,
                                            verbose = FALSE,
                                            progress = TRUE) {
      repo_data <- private$get_repos_data(
        org = org,
        owner_type = owner_type,
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
      }, .progress = progress)
      names(files_structure) <- repositories
      files_structure <- purrr::discard(files_structure, ~ length(.) == 0)
      return(files_structure)
    },

    # Prepare user table.
    prepare_user_table = function(user_response) {
      if (!is.null(user_response$data$user)) {
        user_data <- user_response$data$user
        user_data[["name"]] <- user_data$name %||% ""
        user_data[["starred_repos"]] <- user_data$starred_repos$totalCount
        user_data[["commits"]] <- user_data$contributions$totalCommitContributions
        user_data[["issues"]] <- user_data$contributions$totalIssueContributions
        user_data[["pull_requests"]] <- user_data$contributions$totalPullRequestContributions
        user_data[["reviews"]] <- user_data$contributions$totalPullRequestReviewContributions
        user_data[["contributions"]] <- NULL
        user_data[["email"]] <- user_data$email %||% ""
        user_data[["location"]] <- user_data$location %||% ""
        user_data[["web_url"]] <- user_data$web_url %||% ""
        user_table <- tibble::as_tibble(user_data) %>%
          dplyr::relocate(c(commits, issues, pull_requests, reviews),
            .after = starred_repos
          )
      } else {
        user_table <- NULL
      }
      return(user_table)
    },

    # Pull release logs from organization
    get_release_logs_from_org = function(repos_names, org) {
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
    },

    # Prepare releases table.
    prepare_releases_table = function(releases_response, org, since, until) {
      if (length(releases_response) > 0) {
        releases_table <-
          purrr::map(releases_response, function(release) {
            release_table <- purrr::map(release$data$repository$releases$nodes, function(node) {
              data.frame(
                release_name = node$name,
                release_tag = node$tagName,
                published_at = gts_to_posixt(node$publishedAt),
                release_url = node$url,
                release_log = node$description
              )
            }) %>%
              purrr::list_rbind() |>
              dplyr::mutate(
                repo_name = release$data$repository$name,
                repo_url = release$data$repository$url
              ) %>%
              dplyr::relocate(
                repo_name, repo_url,
                .before = release_name
              )
            return(release_table)
          }) %>%
          purrr::list_rbind() |>
          dplyr::filter(
            published_at <= as.POSIXct(until)
          )
        if (!is.null(since)) {
          releases_table <- releases_table %>%
            dplyr::filter(
              published_at >= as.POSIXct(since)
            )
        }
      } else {
        releases_table <- NULL
      }
      return(releases_table)
    }
  ),
  private = list(

    # Wrapper over building GraphQL query and response.
    get_repos_page = function(login = NULL,
                              type = c("organization"),
                              repo_cursor = "") {
      if (type == "organization") {
        repos_query <- self$gql_query$repos_by_org(
          repo_cursor = repo_cursor
        )
      } else if (type == "user") {
        repos_query <- self$gql_query$repos_by_user(
          repo_cursor = repo_cursor
        )
      }
      response <- self$gql_response(
        gql_query = repos_query,
        vars = list(
          "login" = login
        )
      )
      private$handle_gql_response_error(response)
      return(response)
    },

    handle_gql_response_error = function(response) {
      if (private$is_query_error(response)) {
        cli::cli_abort(c(
          "i" = "GraphQL response error",
          "x" = response$errors[[1]]$message
        ), call = NULL)
      }
    },

    # An iterator over pulling commit pages from one repository.
    get_commits_from_one_repo = function(org,
                                         repo,
                                         since,
                                         until) {
      next_page <- TRUE
      full_commits_list <- list()
      commits_cursor <- ""
      while (next_page) {
        commits_response <- tryCatch({
          private$get_commits_page_from_repo(
            org = org,
            repo = repo,
            since = since,
            until = until,
            commits_cursor = commits_cursor
          )
        }, error = function(e) {
          cli::cli_alert_danger(e$message)
          NULL
        })
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
    get_commits_page_from_repo = function(org,
                                          repo,
                                          since,
                                          until,
                                          commits_cursor = "") {
      commits_from_repo_query <- self$gql_query$commits_from_repo(
        commits_cursor = commits_cursor
      )
      response <- tryCatch(
        {
          self$gql_response(
            gql_query = commits_from_repo_query,
            vars = list(
              "org" = org,
              "repo" = repo,
              "since" = date_to_gts(since),
              "until" = date_to_gts(until)
            )
          )
        },
        error = function(e) {
          self$gql_response(
            gql_query = commits_from_repo_query,
            vars = list(
              "org" = org,
              "repo" = repo,
              "since" = date_to_gts(since),
              "until" = date_to_gts(until)
            )
          )
        }
      )
      return(response)
    },

    # An iterator over pulling issues pages from one repository.
    get_issues_from_one_repo = function(org,
                                        repo) {
      next_page <- TRUE
      full_issues_list <- list()
      issues_cursor <- ""
      while (next_page) {
        issues_response <- private$get_issues_page_from_repo(
          org = org,
          repo = repo,
          issues_cursor = issues_cursor
        )
        issues_list <- issues_response$data$repository$issues$edges
        next_page <- issues_response$data$repository$issues$pageInfo$hasNextPage
        if (is.null(next_page)) next_page <- FALSE
        if (is.null(issues_list)) issues_list <- list()
        if (next_page) {
          issues_cursor <- issues_response$data$repository$issues$pageInfo$endCursor
        } else {
          issues_cursor <- ""
        }
        full_issues_list <- append(full_issues_list, issues_list)
      }
      return(full_issues_list)
    },

    # Wrapper over building GraphQL query and response.
    get_issues_page_from_repo = function(org,
                                         repo,
                                         issues_cursor = "") {
      issues_from_repo_query <- self$gql_query$issues_from_repo(
        issues_cursor = issues_cursor
      )
      response <- tryCatch(
        {
          self$gql_response(
            gql_query = issues_from_repo_query,
            vars = list(
              "org" = org,
              "repo" = repo
            )
          )
        },
        error = function(e) {
          self$gql_response(
            gql_query = issues_from_repo_query,
            vars = list(
              "org" = org,
              "repo" = repo
            )
          )
        }
      )
      return(response)
    },

    get_repos_data = function(org, owner_type, repos = NULL) {
      repos_list <- self$get_repos_from_org(
        org = org,
        owner_type = owner_type
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

    get_repositories_with_files = function(repositories,
                                           def_branches,
                                           org,
                                           host_files_structure,
                                           file_paths,
                                           progress) {
      purrr::map2(repositories, def_branches, function(repo, def_branch) {
        if (!is.null(host_files_structure)) {
          file_paths <- private$get_path_from_files_structure(
            host_files_structure = host_files_structure,
            org = org,
            repo = repo
          )
        } else if (is.null(host_files_structure)) {
          file_paths <- file_paths[grepl(text_files_pattern, file_paths)]
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
      }, .progress = progress)
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
      if (!is.null(files_structure)) {
        attr(files_structure, "repo_id") <- files_tree_response$data$repository$id
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
    },

    fill_empty_authors = function(commits_table) {
      if (length(commits_table) > 0) {
        commits_table <- commits_table |>
          dplyr::rowwise() |>
          dplyr::mutate(
            author_name = ifelse(is.na(author_name) & is_name(author), author, author_name),
            author_login = ifelse(is.na(author_login) & is_login(author), author, author_login)
          )
      }
      return(commits_table)
    }
  )
)
