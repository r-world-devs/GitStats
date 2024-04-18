#' @noRd
#' @description A class for methods wrapping GitHub's GraphQL API responses.
EngineGraphQLGitHub <- R6::R6Class("EngineGraphQLGitHub",
    inherit = EngineGraphQL,
    public = list(

    #' @description Create `EngineGraphQLGitHub` object.
    #' @param gql_api_url GraphQL API url.
    #' @param token A token.
    #' @param scan_all A boolean.
    initialize = function(gql_api_url,
                          token,
                          scan_all = FALSE) {
      super$initialize(gql_api_url = gql_api_url,
                       token = token,
                       scan_all = scan_all)
      self$gql_query <- GQLQueryGitHub$new()
    },

    #' @description Get all orgs from GitHub.
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

    #' @description A method to retrieve all repositories for an organization in
    #'   a table format.
    #' @param org An organization.
    #' @param repos Optional, a vector of repositories.
    #' @param with_code A character, code to search for.
    #' @param settings A list of  `GitStats` settings.
    #' @return A table.
    pull_repos = function(org,
                          repos = NULL,
                          with_code = NULL,
                          settings) {
      if (!private$scan_all && settings$verbose) {
        cli::cli_alert_info("[GitHub][Engine:{cli::col_yellow('GraphQL')}][org:{org}] Pulling repositories...")
      }
      repos_table <- private$pull_repos_from_org(
        org = org
      ) %>%
        private$prepare_repos_table()
      if (!is.null(repos)) {
        repos_table <- repos_table %>%
          dplyr::filter(repo_name %in% repos)
      }
      return(repos_table)
    },

    #' @description Method to pull all commits from repositories.
    #' @param org An organization.
    #' @param repos A vector of repositories.
    #' @param date_from A starting date to look commits for.
    #' @param date_until An end date to look commits for.
    #' @param settings A list of  `GitStats` settings.
    #' @param storage A storage of `GitStats` object.
    #' @return A table of commits.
    pull_commits = function(org,
                            repos = NULL,
                            date_from,
                            date_until,
                            settings,
                            storage = NULL) {
      repos_names <- private$set_repositories(
        repos = repos,
        org = org,
        settings = settings,
        storage = storage
      )
      if (!private$scan_all && settings$verbose) {
        if (settings$searching_scope == "org") {
          cli::cli_alert_info("[GitHub][Engine:{cli::col_yellow('GraphQL')}][org:{org}] Pulling commits...")
        }
        if (settings$searching_scope == "repo") {
          cli::cli_alert_info("[GitHub][Engine:{cli::col_yellow('GraphQL')}][org:{org}][custom repositories] Pulling commits...")
        }
      }
      repos_list_with_commits <- private$pull_commits_from_repos(
        org = org,
        repos = repos_names,
        date_from = date_from,
        date_until = date_until
      )
      names(repos_list_with_commits) <- repos_names

      commits_table <- repos_list_with_commits %>%
        purrr::discard(~ length(.) == 0) %>%
        private$prepare_commits_table(org)
      return(commits_table)
    }
  ),
    private = list(

      # @description Iterator over pulling pages of repositories.
      # @param from A character specifying if organization or user.
      # @param org An organization.
      # @param user A user.
      # @return A list of repositories from organization.
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

      # @description Wrapper over building GraphQL query and response.
      # @param org An organization.
      # @param repo_cursor An end cursor for repos page.
      # @return A list of repositories.
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

      # @description Parses repositories list into table.
      # @param repos_list A list of repositories.
      # @return Table of repositories.
      prepare_repos_table = function(repos_list) {
        if (length(repos_list) > 0) {
          repos_table <- purrr::map_dfr(repos_list, function(repo) {
            repo$default_branch <- if(!is.null(repo$default_branch)) {
              repo$default_branch$name
            } else {
              ""
            }
            repo$languages <- purrr::map_chr(repo$languages$nodes, ~ .$name) %>%
              paste0(collapse = ", ")
            repo$created_at <- gts_to_posixt(repo$created_at)
            repo$issues_open <- repo$issues_open$totalCount
            repo$issues_closed <- repo$issues_closed$totalCount
            repo$last_activity_at <- as.POSIXct(repo$last_activity_at)
            repo$organization <- repo$organization$login
            repo <- data.frame(repo) %>%
              dplyr::relocate(
                default_branch,
                .after = repo_name
              )
          })
        } else {
          repos_table <- NULL
        }
        return(repos_table)
      },

      # @description Iterator over pulling commits from all repositories.
      # @param org An organization.
      # @param repos A character vector of repository names.
      # @param date_from A starting date to look commits for.
      # @param date_until An end date to look commits for.
      # @return A list of repositories with commits.
      pull_commits_from_repos = function(org,
                                         repos,
                                         date_from,
                                         date_until) {
        repos_list_with_commits <- purrr::map(repos, function(repo) {
          private$pull_commits_from_one_repo(
            org,
            repo,
            date_from,
            date_until
          )
        }, .progress = !private$scan_all)
        return(repos_list_with_commits)
      },

      # @description An iterator over pulling commit pages from one repository.
      # @param org An organization.
      # @param repo A repository name.
      # @param date_from A starting date to look commits for.
      # @param date_until An end date to look commits for.
      # @param author_id Id of an author.
      # @return A list of commits.
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

      # @description Wrapper over building GraphQL query and response.
      # @param org An organization
      # @param repo A repository.
      # @param date_from A starting date to look commits for.
      # @param date_until An end date to look commits for.
      # @param commits_cursor An end cursor for commits page.
      # @param author_id Id of an author.
      # @return A list.
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
      },

      # @description Parses repositories' list with commits into table of commits.
      # @param repos_list_with_commits A list of repositories with commits.
      # @param org An organization of repositories.
      # @return Table of commits.
      prepare_commits_table = function(repos_list_with_commits,
                                       org) {
        commits_table <- purrr::imap(repos_list_with_commits, function(repo, repo_name) {
          commits_row <- purrr::map_dfr(repo, function(commit) {
            commit_author <- commit$node$author
            commit$node$author <- commit_author$name
            commit$node$author_login <- if (!is.null(commit_author$user$login)) {
              commit_author$user$login
            } else {
              NA
            }
            commit$node$author_name <- if (!is.null(commit_author$user$name)) {
              commit_author$user$name
            } else {
              NA
            }
            commit$node$committed_date <- gts_to_posixt(commit$node$committed_date)
            commit$node
          })
          commits_row$repository <- repo_name
          commits_row
        }) %>%
          purrr::discard(~ length(.) == 1) %>%
          purrr::list_rbind()

        if (nrow(commits_table) > 0) {
          commits_table <- commits_table %>%
            dplyr::mutate(
              organization = org,
              api_url = gsub("/graphql", "", self$gql_api_url)
            ) %>%
            dplyr::relocate(
              any_of(c("author_login", "author_name")),
              .after = author
            )
        }
        return(commits_table)
      },

      # @description Prepare user table.
      # @param user_response A list.
      # @return A table with information on user.
      prepare_user_table = function(user_response) {
        if (!is.null(user_response$data$user)) {
          user_data <- user_response$data$user
          user_data$name <- user_data$name %||% ""
          user_data$starred_repos <- user_data$starred_repos$totalCount
          user_data$commits <- user_data$contributions$totalCommitContributions
          user_data$issues <- user_data$contributions$totalIssueContributions
          user_data$pull_requests <- user_data$contributions$totalPullRequestContributions
          user_data$reviews <- user_data$contributions$totalPullRequestReviewContributions
          user_data$contributions <- NULL
          user_data$email <- user_data$email %||% ""
          user_data$location <- user_data$location %||% ""
          user_data$web_url <- user_data$web_url %||% ""
          user_table <- tibble::as_tibble(user_data) %>%
            dplyr::relocate(c(commits, issues, pull_requests, reviews),
                            .after = starred_repos)
        } else {
          user_table <- NULL
        }
        return(user_table)
      },

      # @description Pull all given files from all repositories of an
      #   organization.
      # @param org An organization.
      # @param file_path Path to a file.
      # @param pulled_repos Optional, if not empty, function will make use of the
      #   argument to iterate over it when pulling files.
      # @return A response in a list form.
      pull_file_from_org = function(org, file_path, pulled_repos = NULL) {
        if (is.null(pulled_repos)) {
          repos_list <- private$pull_repos_from_org(
            org = org
          )
          repositories <- purrr::map(repos_list, ~ .$repo_name)
          def_branches <- purrr::map(repos_list, ~ .$default_branch$name)
        } else {
          repos_table <- pulled_repos %>%
            dplyr::filter(organization == org)
          repositories <- repos_table$repo_name
          def_branches <- repos_table$default_branch
        }
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

      # @description Prepare files table.
      # @param files_response A list.
      # @param org An organization.
      # @return A table with information on files.
      prepare_files_table = function(files_response, org, file_path) {
        if (!is.null(files_response)) {
          files_table <- purrr::map(file_path, function(file) {
            purrr::imap(files_response[[file]], function(repository, name) {
              data.frame(
                "repo_name" = repository$name,
                "repo_id" = repository$id,
                "organization" = org,
                "file_path" = file,
                "file_content" = repository$object$text,
                "file_size" = repository$object$byteSize,
                "repo_url" = repository$url,
                "api_url" = self$gql_api_url
              )
            }) %>%
              purrr::list_rbind()
          }) %>%
            purrr::list_rbind()
        } else {
          files_table <- NULL
        }
        return(files_table)
      },

      # @description Pull all releases from all repositories of an
      #   organization.
      # @param repos_names
      # @param org An organization.
      # @return A response in a list form.
      pull_releases_from_org = function(repos_names, org) {
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

      # @description Prepare releases table.
      # @param releases_response A list.
      # @param org An organization.
      # @return A table with information on releases.
      prepare_releases_table = function(releases_response, org, date_from, date_until) {
        if (!is.null(releases_response)) {
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
                purrr::list_rbind() %>%
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
            purrr::list_rbind() %>%
            dplyr::filter(
              published_at <= as.POSIXct(date_until)
            )
          if (!is.null(date_from)) {
            releases_table <- releases_table %>%
              dplyr::filter(
                published_at >= as.POSIXct(date_from)
              )
          }
        } else {
          releases_table <- NULL
        }
        return(releases_table)
      }
    )
)
