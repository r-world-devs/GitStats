#' @title A EngineRestGitLab class
#' @description A class for methods wraping GitLab's REST API responses.
EngineRestGitLab <- R6::R6Class("EngineRestGitLab",
  inherit = EngineRest,
  public = list(

    initialize = function(rest_api_url,
                          token) {
      super$initialize(
        rest_api_url = rest_api_url,
        token = token
      )
      self$git_platform <- "GitLab"
    },

    #' @description Check if an organization exists
    #' @param orgs A character vector of organizations
    #' @return orgs or NULL.
    check_organizations = function(orgs) {
      orgs <- purrr::map(orgs, function(org) {
        org_endpoint <- "/groups/"
        withCallingHandlers(
          {
            self$response(endpoint = paste0(self$rest_api_url, org_endpoint, org))
          },
          message = function(m) {
            if (grepl("404", m)) {
              cli::cli_alert_danger("Group name passed in a wrong way: {org}")
              cli::cli_alert_warning("If you are using `GitLab`, please type your group name as you see it in `url`.")
              cli::cli_alert_info("E.g. do not use spaces. Group names as you see on the page may differ from their 'address' name.")
              org <<- NULL
            }
          }
        )
        return(org)
      }) %>%
        purrr::keep(~ length(.) > 0) %>%
        unlist()

      if (length(orgs) == 0) {
        return(NULL)
      }
      orgs
    },

    #' @description A method to retrieve all repositories for an organization in
    #'   a table format.
    #' @param org
    #' @param settings
    #' @return A table.
    get_repos = function(org,
                         settings) {
      repos_table <- super$get_repos(
        org = org,
        settings = settings
      )
      if (settings$search_param %in% c("org", "team")) {
        if (settings$search_param == "org") {
          cli::cli_alert_info("[{self$git_platform}][Engine:{cli::col_green('REST')}][org:{org}] Pulling repositories...")
        } else {
          cli::cli_alert_info("[{self$git_platform}][Engine:{cli::col_green('REST')}][org:{org}][team:{settings$team_name}] Pulling repositories...")
        }
        org <- private$get_group_id(org)
        repos_table <- private$pull_repos_from_org(org) %>%
          private$tailor_repos_info() %>%
          private$prepare_repos_table() %>%
          self$get_repos_contributors()
        if (settings$search_param == "team") {
          repos_table <- private$filter_repos_by_team(
            repos_table = repos_table,
            team = settings$team
          )
        }
        if (!is.null(settings$language)) {
          repos_table <- private$filter_repos_by_language(
            repos_table = repos_table
          )
        }
      }
      return(repos_table)
    },

    #' @description A method to add information on repository contributors.
    #' @param repos_table A table of repositories.
    #' @return A table of repositories with added information on contributors.
    get_repos_contributors = function(repos_table) {
      if (nrow(repos_table) > 0) {
        repo_iterator <- repos_table$id
        user_name <- rlang::expr(.$name)
        repos_table$contributors <- purrr::map_chr(repo_iterator, function(repos_id) {
          id <- gsub("gid://gitlab/Project/", "", repos_id)
          contributors_endpoint <- paste0(self$rest_api_url, "/projects/", id, "/repository/contributors")
          tryCatch(
            {
              self$response(
                endpoint = contributors_endpoint
              ) %>%
                purrr::map_chr(~ eval(user_name)) %>%
                paste0(collapse = ", ")
            },
            error = function(e) {
              NA
            }
          )
        })
      }
      return(repos_table)
    },

    #' @description A method to add information on repository contributors.
    #' @param repos_table A table of repositories.
    #' @return A table of repositories with added information on contributors.
    get_repos_issues = function(repos_table) {
      if (nrow(repos_table) > 0) {
        issues <- purrr::map(repos_table$id, function(repos_id) {
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

    #' @description GitLab private method to derive
    #'   commits from repo with REST API.
    #' @param org A character, a group of projects.
    #' @param date_from A starting date to look commits for.
    #' @param date_until An end date to look commits for.
    #' @param settings
    #' @return A table of commits.
    get_commits = function(org,
                           date_from,
                           date_until = Sys.date(),
                           settings) {

      repos_table <- self$get_repos(
        org = org,
        settings = settings
      )

      if (settings$search_param == "org") {
        cli::cli_alert_info("[GitLab][Engine:{cli::col_green('REST')}][org:{org}] Pulling commits...")
      } else if (settings$search_param == "team") {
        cli::cli_alert_info("[GitLab][Engine:{cli::col_green('REST')}][org:{org}][team:{settings$team_name}] Pulling commits...")
      }

      repos_list_with_commits <- private$pull_commits_from_org(
        repos_table = repos_table,
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
        private$prepare_commits_table()

      return(commits_table)
    }
  ),
  private = list(

    #' @description Iterator over pulling pages of repositories.
    #' @param org An organization.
    #' @return A list of repositories from organization.
    pull_repos_from_org = function(org) {
      full_repos_list <- list()
      page <- 1
      repeat {
        repo_endpoint <- paste0(self$rest_api_url, "/groups/", org, "/projects?per_page=100&page=", page)
        repos_page <- self$response(
          endpoint = repo_endpoint
        )
        if (length(repos_page) > 0) {
          full_repos_list <- append(full_repos_list, repos_page)
          page <- page + 1
        } else {
          break
        }
      }
      return(full_repos_list)
    },

    #' @description Perform get request to search API.
    #' @details For the time being there is no possibility to search GitLab with
    #'   filtering by language. For more information look here:
    #'   https://gitlab.com/gitlab-org/gitlab/-/issues/340333
    #' @param phrase A phrase to look for in codelines.
    #' @param org A character, a group of projects.
    #' @param language
    #' @param page_max An integer, maximum number of pages.
    #' @return A list of repositories.
    search_repos_by_phrase = function(phrase,
                                      org,
                                      language,
                                      page_max = 1e6) {
      page <- 1
      still_more_hits <- TRUE
      resp_list <- list()
      groups_id <- private$get_group_id(org)

      while (still_more_hits | page < page_max) {
        resp <- self$response(
          paste0(
            self$rest_api_url, "/groups/", groups_id,
            "/search?scope=blobs&search=", phrase, "&per_page=100&page=", page
          )
        )

        if (length(resp) == 0) {
          still_more_hits <- FALSE
          break()
        } else {
          resp_list <- append(resp_list, resp)
          page <- page + 1
        }
      }

      repos_list <- purrr::map_chr(resp_list, ~ as.character(.$project_id)) %>%
        unique() %>%
        private$find_by_id(objects = "projects") #%>%
        # private$filter_repos_by_language(language = language)

      return(repos_list)
    },

    filter_repos_by_language = function(repos_list,
                                        language) {

      repos_list <- purrr::map(repos_list, function(x) {
        x
      })
      return(repos_list)
    },

    #' @description A helper to retrieve only important info on repos
    #' @param projects_list A list, a formatted content of response returned by GET API request
    #' @return A list of repos with selected information
    tailor_repos_info = function(projects_list) {
      projects_list <- purrr::map(projects_list, function(x) {
        list(
          "id" = x$id,
          "name" = x$name,
          "stars" = x$star_count,
          "forks" = x$fork_count,
          "created_at" = x$created_at,
          "last_push" = NULL,
          "last_activity_at" = x$last_activity_at,
          "languages" = NULL,
          "issues_open" = x$issues_open,
          "issues_closed" = x$issues_closed,
          "contributors" = NULL,
          "organization" = x$namespace$path
        )
      })
      projects_list
    },

    #' @description Method to pull all commits from organization.
    #' @param repos_table A table of repositories.
    #' @param date_from A starting date to look commits for.
    #' @param date_until An end date to look commits for.
    #' @return A list of repositories with commits.
    pull_commits_from_org = function(repos_table,
                                     date_from,
                                     date_until
                                     ) {

      repos_names <- repos_table$name
      projects_ids <- gsub("gid://gitlab/Project/", "", repos_table$id)

      pb <- progress::progress_bar$new(
        format = paste0("Checking for commits since ", date_from, " in ", length(repos_names), " repos. [:bar] repo: :current/:total"),
        total = length(repos_names)
      )

      repos_list_with_commits <- purrr::map(projects_ids, function(project_id) {
        pb$tick()
        commits_from_repo <- private$pull_commits_from_repo(
          project_id = project_id,
          date_from = date_from,
          date_until = date_until
        )
        return(commits_from_repo)
      })
      names(repos_list_with_commits) <- repos_names
      return(repos_list_with_commits)
    },

    #' @description Iterator over pages of commits response.
    #' @param project_id Id of a project.
    #' @param date_from A starting date to look commits for.
    #' @param date_until An end date to look commits for.
    #' @return A list of commits.
    pull_commits_from_repo = function(project_id,
                                      date_from,
                                      date_until) {
      all_commits_in_repo <- list()
      page <- 1
      repeat {
        commits_page <- self$response(
          endpoint = paste0(
            self$rest_api_url,
            "/projects/",
            project_id,
            "/repository/commits?since='",
            date_to_gts(date_from),
            "'&until='",
            date_to_gts(date_until),
            "'&with_stats=true",
            "&page=", page
          )
        )
        if (length(commits_page) > 0) {
          all_commits_in_repo <- append(all_commits_in_repo, commits_page)
          page <- page + 1
        } else {
          break
        }
      }
      return(all_commits_in_repo)
    },

    #' @description A helper to retrieve only important info on commits.
    #' @param repos_list_with_commits A list of repositories with commits.
    #' @param org A character, name of a group.
    #' @return A list of commits with selected information.
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

    #' @description Filter by contributors.
    #' @param repos_list_with_commits A list of repositories with commits.
    #' @param team A list of team members.
    #' @return A list.
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

    #' @description A helper to turn list of data.frames into one data.frame
    #' @param commits_list A list
    #' @return A data.frame
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

    #' @description A helper to get group's id
    #' @param project_group A character, a group of projects.
    #' @return An integer, id of group.
    get_group_id = function(project_group) {
      self$response(paste0(self$rest_api_url, "/groups/", project_group))[["id"]]
    }
  )
)
