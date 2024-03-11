#' @noRd
#' @title A EngineRestGitLab class
#' @description A class for methods wrapping GitLab's REST API responses.
EngineRestGitLab <- R6::R6Class("EngineRestGitLab",
  inherit = EngineRest,
  public = list(

    #' @description A method to retrieve all repositories for an organization in
    #'   a table format.
    #' @param org A character, a group of projects.
    #' @param settings A list of  `GitStats` settings.
    #' @return A table.
    pull_repos = function(org,
                          settings) {
      if (settings$search_param == "phrase") {
        if (!private$scan_all) {
          cli::cli_alert_info("[GitLab][Engine:{cli::col_green('REST')}][phrase:{settings$phrase}][org:{gsub('%2f', '/', org)}] Searching repositories...")
        }
        repos_table <- private$search_repos_by_phrase(
          org = org,
          phrase = settings$phrase,
          files = settings$files,
          language = settings$language
        ) %>%
          private$tailor_repos_info() %>%
          private$prepare_repos_table() %>%
          private$pull_repos_issues()
      } else if (settings$search_param == "team") {
        if (!private$scan_all) {
          cli::cli_alert_info("[GitLab][Engine:{cli::col_green('REST')}][org:{gsub('%2f', '/', org)}][team:{settings$team_name}] Pulling repositories...")
        }
        org <- private$get_group_id(org)
        repos_table <- private$pull_repos_from_org(org) %>%
          private$tailor_repos_info() %>%
          private$prepare_repos_table() %>%
          private$pull_repos_issues()
        suppressMessages({
        repos_table <- self$pull_repos_contributors(
          repos_table = repos_table
          ) %>%
          private$filter_repos_by_team(team = settings$team)
        })
      } else {
        repos_table <- NULL
      }
      return(repos_table)
    },

    #' @description An empty method to satisfy engine iterator.
    #' @param org An organization.
    #' @param settings A list of  `GitStats` settings.
    #' @return Nothing.
    pull_repos_supportive = function(org,
                                     settings) {
      repos_table <- NULL
      if (settings$search_param == "org") {
        if (!private$scan_all) {
          cli::cli_alert_info("[GitLab][Engine:{cli::col_green('REST')}][org:{gsub('%2f', '/', org)}] Pulling repositories...")
        }
        org <- private$get_group_id(org)
        repos_table <- private$pull_repos_from_org(org) %>%
          private$tailor_repos_info() %>%
          private$prepare_repos_table() %>%
          private$pull_repos_issues()
      }
      return(repos_table)
    },

    #' @description A method to add information on repository contributors.
    #' @param repos_table A table of repositories.
    #' @return A table of repositories with added information on contributors.
    pull_repos_contributors = function(repos_table) {
      if (nrow(repos_table) > 0) {
        if (!private$scan_all) {
          cli::cli_alert_info("[GitLab][Engine:{cli::col_green('REST')}][org:{unique(repos_table$organization)}] Pulling contributors...")
        }
        repo_iterator <- repos_table$repo_id
        user_name <- rlang::expr(.$name)
        repos_table$contributors <- purrr::map_chr(repo_iterator, function(repos_id) {
          id <- gsub("gid://gitlab/Project/", "", repos_id)
          tryCatch({
            contributors_endpoint <- paste0(self$rest_api_url, "/projects/", id, "/repository/contributors")
            contributors_vec <- private$pull_contributors_from_repo(
              contributors_endpoint = contributors_endpoint,
              user_name = user_name
            )
            return(contributors_vec)
            },
            error = function(e) {
              NA
            }
          )
        })
      }
      return(repos_table)
    },

    #' @description GitLab private method to derive
    #'   commits from repo with REST API.
    #' @param org A character, a group of projects.
    #' @param repos A character vector of repositories.
    #' @param date_from A starting date to look commits for.
    #' @param date_until An end date to look commits for.
    #' @param settings A list of  `GitStats` settings.
    #' @param .storage A storage of `GitStats` object.
    #' @return A table of commits.
    pull_commits = function(org = NULL,
                            repos = NULL,
                            date_from,
                            date_until = Sys.date(),
                            settings,
                            .storage = NULL) {
      if (is.null(repos)) {
        if (is.null(.storage$repositories)) {
          repos_table <- self$pull_repos_supportive(
            org = org,
            settings = list(search_param = "org")
          )
        } else {
          repos_table <- .storage$repositories %>%
            dplyr::filter(
              organization == org
            )
        }
        gitlab_web_url <- stringr::str_extract(self$rest_api_url, "^.*?(?=api)")
        repos <- stringr::str_remove(repos_table$repo_url, gitlab_web_url)
        repos_names <- stringr::str_replace_all(repos, "/", "%2f")
      } else {
        repos_names <- paste0(org, "%2f", repos)
      }
      if (!private$scan_all) {
        org_disp <- stringr::str_replace_all(org, "%2f", "/")
        if (settings$search_param == "org") {
          cli::cli_alert_info("[GitLab][Engine:{cli::col_green('REST')}][org:{org_disp}] Pulling commits...")
        } else if (settings$search_param == "repo") {
          cli::cli_alert_info("[GitLab][Engine:{cli::col_green('REST')}][org:{org_disp}][custom repositories] Pulling commits...")
        } else if (settings$search_param == "team") {
          cli::cli_alert_info("[GitLab][Engine:{cli::col_green('REST')}][org:{org_disp}][team:{settings$team_name}] Pulling commits...")
        }
      }
      repos_list_with_commits <- private$pull_commits_from_repos(
        repos_names = repos_names,
        date_from = date_from,
        date_until = date_until
      ) %>%
        purrr::discard(~ length(.) == 0)
      if (settings$search_param == "team") {
        repos_list_with_commits <- private$filter_commits_by_team(
          repos_list_with_commits = repos_list_with_commits,
          team = settings$team
        )
      }
      commits_table <- repos_list_with_commits %>%
        private$tailor_commits_info(org = org) %>%
        private$prepare_commits_table() %>%
        private$get_commits_authors_handles_and_names()

      return(commits_table)
    }
  ),
  private = list(

    # @description Check if the token gives access to API.
    # @param token A token.
    # @return A token.
    check_token = function(token) {
      super$check_token(token)
      if (nchar(token) > 0) {
        withCallingHandlers({
          self$response(endpoint = paste0(self$rest_api_url, "/projects"),
                        token = token)
        },
        message = function(m) {
          if (grepl("401", m$message)) {
            cli::cli_abort(c(
              "x" = m$message
            ))
          }
        })
      }
      return(invisible(token))
    },

    # @description Iterator over pulling pages of repositories.
    # @param org A character, a group of projects.
    # @return A list of repositories from organization.
    pull_repos_from_org = function(org) {
      repo_endpoint <- paste0(self$rest_api_url, "/groups/", org, "/projects")
      repos_response <- private$paginate_results(
        endpoint = repo_endpoint
      )
      full_repos_list <- repos_response %>%
        private$pull_repos_languages()
      return(full_repos_list)
    },

    # @description Perform get request to search API.
    # @details For the time being there is no possibility to search GitLab with
    #   filtering by language. For more information look here:
    #   https://gitlab.com/gitlab-org/gitlab/-/issues/340333
    # @param phrase A phrase to look for in codelines.
    # @param org A character, a group of projects.
    # @param language A character, programming language.
    # @param page_max An integer, maximum number of pages.
    # @return A list of repositories.
    search_repos_by_phrase = function(phrase,
                                      org,
                                      files,
                                      language = "All",
                                      page_max = 1e6) {
      page <- 1
      still_more_hits <- TRUE
      full_repos_list <- list()
      groups_url <- if (!private$scan_all) {
        paste0("/groups/", private$get_group_id(org))
      } else {
        ""
      }
      while (still_more_hits | page < page_max) {
        repos_list <- self$response(
          paste0(
            self$rest_api_url, groups_url,
            "/search?scope=blobs&search=%22", phrase, "%22&per_page=100&page=", page
          )
        )
        if (length(repos_list) == 0) {
          still_more_hits <- FALSE
          break()
        } else {
          if (!is.null(files)) {
            repos_list <- purrr::keep(repos_list, function(repository) {
              any(repository$path %in% files)
            })
          }
          full_repos_list <- append(full_repos_list, repos_list)
          page <- page + 1
        }
      }
      full_repos_list <- full_repos_list %>%
        private$find_repos_by_id() %>%
        private$pull_repos_languages()
      return(full_repos_list)
    },

    # @description Perform get request to find projects by ids.
    # @param repos_list A list of repositories - search response.
    # @return A list of repositories.
    find_repos_by_id = function(repos_list) {
      ids <- purrr::map_chr(repos_list, ~ as.character(.$project_id)) %>%
        unique()

      repos_list <- purrr::map(ids, function(x) {
        content <- self$response(
          endpoint = paste0(self$rest_api_url, "/projects/", x)
        )
      })
      repos_list
    },

    # @description Pull languages of repositories.
    # @param repos_list A list of repositories.
    # @return A list of repositories with 'languages' slot.
    pull_repos_languages = function(repos_list) {
      repos_list_with_languages <- purrr::map(repos_list, function(repo) {
        id <- repo$id
        repo$languages <- names(self$response(paste0(self$rest_api_url, "/projects/", id, "/languages")))
        repo
      })
      return(repos_list_with_languages)
    },

    # @description A helper to retrieve only important info on repos
    # @param projects_list A list, a formatted content of response returned by GET API request
    # @return A list of repos with selected information
    tailor_repos_info = function(projects_list) {
      projects_list <- purrr::map(projects_list, function(project) {
        list(
          "repo_id" = project$id,
          "repo_name" = project$name,
          "default_branch" = project$default_branch,
          "stars" = project$star_count,
          "forks" = project$fork_count,
          "created_at" = project$created_at,
          "last_activity_at" = project$last_activity_at,
          "languages" = paste0(project$languages, collapse = ", "),
          "issues_open" = project$issues_open,
          "issues_closed" = project$issues_closed,
          "organization" = project$namespace$path,
          "repo_url" = project$web_url
        )
      })
      projects_list
    },

    # @description A method to add information on open and closed issues of a repository.
    # @param repos_table A table of repositories.
    # @return A table of repositories with added information on issues.
    pull_repos_issues = function(repos_table) {
      if (nrow(repos_table) > 0) {
        issues <- purrr::map(repos_table$repo_id, function(repos_id) {
          id <- gsub("gid://gitlab/Project/", "", repos_id)
          issues_endpoint <- paste0(self$rest_api_url, "/projects/", id, "/issues_statistics")

          self$response(
            endpoint = issues_endpoint
          )[["statistics"]][["counts"]]
        })
        repos_table$issues_open <- purrr::map_dbl(issues, ~ .$opened)
        repos_table$issues_closed <- purrr::map_dbl(issues, ~ .$closed)
      }
      return(repos_table)
    },

    # @description Filter repositories by contributors.
    # @details If at least one member of a team is a contributor than a project
    #   passes through the filter.
    # @param repos_table A repository table to be filtered.
    # @param team A list with team members.
    # @return A repos table.
    filter_repos_by_team = function(repos_table,
                                    team) {
      team_logins <- unlist(team)
      if (nrow(repos_table) > 0) {
        filtered_contributors <- purrr::keep(repos_table$contributors, function(row) {
          any(purrr::map_lgl(team_logins, ~ grepl(., row)))
        })
        repos_table <- repos_table %>%
          dplyr::filter(contributors %in% filtered_contributors)
      } else {
        repos_table
      }
      return(repos_table)
    },

    # @description Method to pull all commits from organization.
    # @param repos_names Character vector of repositories names.
    # @param date_from A starting date to look commits for.
    # @param date_until An end date to look commits for.
    # @return A list of repositories with commits.
    pull_commits_from_repos = function(repos_names,
                                       date_from,
                                       date_until) {
      repos_list_with_commits <- purrr::map(repos_names, function(repo_path) {
        commits_from_repo <- private$pull_commits_from_one_repo(
          repo_path = repo_path,
          date_from = date_from,
          date_until = date_until
        )
        return(commits_from_repo)
      }, .progress = !private$scan_all)
      names(repos_list_with_commits) <- repos_names
      return(repos_list_with_commits)
    },

    # @description Iterator over pages of commits response.
    # @param repo_path A repo url path.
    # @param date_from A starting date to look commits for.
    # @param date_until An end date to look commits for.
    # @return A list of commits.
    pull_commits_from_one_repo = function(repo_path,
                                          date_from,
                                          date_until) {
      commits_endpoint <- paste0(
        self$rest_api_url,
        "/projects/",
        repo_path,
        "/repository/commits?since='",
        date_to_gts(date_from),
        "'&until='",
        date_to_gts(date_until),
        "'&with_stats=true"
      )
      all_commits_in_repo <- private$paginate_results(
        endpoint = commits_endpoint,
        joining_sign = "&"
      )
      return(all_commits_in_repo)
    },

    # @description A helper to retrieve only important info on commits.
    # @param repos_list_with_commits A list of repositories with commits.
    # @param org A character, name of a group.
    # @return A list of commits with selected information.
    tailor_commits_info = function(repos_list_with_commits,
                                   org) {
      repos_list_with_commits_cut <- purrr::map(repos_list_with_commits, function(repo) {
        purrr::map(repo, function(commit) {
          list(
            "id" = commit$id,
            "committed_date" = gts_to_posixt(commit$committed_date),
            "author" = commit$author_name,
            "additions" = commit$stats$additions,
            "deletions" = commit$stats$deletions,
            "repository" = gsub(
              pattern = paste0("/-/commit/", commit$id),
              replacement = "",
              x = gsub(paste0("(.*)", org, "/"), "", commit$web_url)
            ),
            "organization" = org
          )
        })
      })
      return(repos_list_with_commits_cut)
    },

    # @description Filter by contributors.
    # @param repos_list_with_commits A list of repositories with commits.
    # @param team A list of team members.
    # @return A list.
    filter_commits_by_team = function(repos_list_with_commits,
                                      team) {
      team_names <- purrr::map_chr(team, ~ .$name)
      filtered_repos_list_with_commits <- purrr::map(repos_list_with_commits, function(repo) {
        purrr::keep(repo, function(commit) {
          if (length(commit$author_name > 0)) {
            commit$author_name %in% team_names
          } else {
            FALSE
          }
        })
      }) %>% purrr::discard(~ length(.) == 0)

      return(filtered_repos_list_with_commits)
    },

    # @description A helper to turn list of data.frames into one data.frame
    # @param commits_list A list
    # @return A data.frame
    prepare_commits_table = function(commits_list) {
      commits_dt <- purrr::map(commits_list, function(x) {
        purrr::map(x, ~ data.frame(.)) %>%
          rbindlist()
      }) %>% rbindlist()

      if (length(commits_dt) > 0) {
        commits_dt <- dplyr::mutate(
          commits_dt,
          api_url = self$rest_api_url
        )
      }
      return(commits_dt)
    },

    # @description A method to get separately GL logins and display names
    # @param commits_table A table
    # @return A data.frame
    get_commits_authors_handles_and_names = function(commits_table) {
      if (nrow(commits_table) > 0) {
        cli::cli_alert_info("Looking up for authors' names and logins...")
        authors_dict <- purrr::map(unique(commits_table$author), function(author) {
          if (self$rest_api_url != "https://gitlab.com/api/v4") {
            author <- stringr::str_replace_all(author, " ", "%20")
          }
          search_endpoint <- paste0(
            self$rest_api_url,
            "/search?scope=users&search=%22", author, "%22"
          )
          user_response <- list()
          try({
            user_response <- self$response(endpoint = search_endpoint)
          }, silent = TRUE)
          if (length(user_response) == 0) {
            author <- stringi::stri_trans_general(author, "Latin-ASCII")
            search_endpoint <- paste0(
              self$rest_api_url,
              "/search?scope=users&search=%22", author, "%22"
            )
            try({
              user_response <- self$response(endpoint = search_endpoint)
            }, silent = TRUE)
          }
          if (!is.null(user_response) && length(user_response) > 1) {
            user_response <- purrr::keep(user_response, ~ grepl(author, .$name))
          }
          if (is.null(user_response) || length(user_response) == 0) {
            user_tbl <- tibble::tibble(
              author = stringr::str_replace_all(author, "%20", " "),
              author_login = NA,
              author_name = NA
            )
          } else {
            user_tbl <- tibble::tibble(
              author = stringr::str_replace_all(author, "%20", " "),
              author_login = user_response[[1]]$username,
              author_name = user_response[[1]]$name
            )
          }
          return(user_tbl)
        }, .progress = TRUE) %>%
          purrr::list_rbind()

        commits_table <- commits_table %>%
          dplyr::mutate(
            author_login = NA,
            author_name = NA
          ) %>%
          dplyr::relocate(
            any_of(c("author_login", "author_name")),
            .after = author
          )

        empty_dict <- all(is.na(authors_dict[, c("author_login", "author_name")] %>%
                                  unlist()))
        if (!empty_dict) {
          commits_table <- dplyr::mutate(
            commits_table,
            author_login = purrr::map_vec(author, ~ authors_dict$author_login[. == authors_dict$author]),
            author_name = purrr::map_vec(author, ~ authors_dict$author_name[. == authors_dict$author])
          )
        }
        return(commits_table)
      }
    },

    # @description A helper to get group's id
    # @param project_group A character, a group of projects.
    # @return An integer, id of group.
    get_group_id = function(project_group) {
      self$response(paste0(self$rest_api_url, "/groups/", project_group))[["id"]]
    }
  )
)
