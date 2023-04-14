EngineRestGitLab <- R6::R6Class("EngineRestGitLab",

  inherit = EngineRest,

  public = list(

    #' @description GitLab private method to derive
    #'   commits from repo with REST API.
    #' @param org A character, a group of projects.
    #' @param repos_table A table of repositories.
    #' @param date_from A starting date to look commits for.
    #' @param date_until An end date to look commits for.
    #' @param by A search parameter - `team` or `orgs`.
    #' @param team A list of team members.
    #' @return A table of commits.
    get_commits_from_org = function(org,
                                     repos_table,
                                     date_from,
                                     date_until = Sys.date(),
                                     by,
                                     team) {

      repos_names <- repos_table$name
      projects_ids <- gsub("gid://gitlab/Project/", "", repos_table$id)

      cli::cli_alert_info("[GitLab][{org}][Engine:{cli::col_green('REST')}] Pulling commits...")

      pb <- progress::progress_bar$new(
        format = paste0("Checking for commits since ", date_from, " in ", length(repos_names), " repos. [:bar] repo: :current/:total"),
        total = length(repos_names)
      )

      commits_list <- purrr::map(projects_ids, function(project_id) {
        pb$tick()
        all_commits_in_repo <- list()
        page <- 1
        repeat {
          commits_page <- private$pull_commits_page_from_repo(project_id = project_id,
                                                              date_from = date_from,
                                                              date_until = date_until,
                                                              page = page)
          if (length(commits_page) > 0) {
            all_commits_in_repo <- append(all_commits_in_repo, commits_page)
            page <- page + 1
          } else {
            break
          }
        }
        return(all_commits_in_repo)
      })

      names(commits_list) <- repos_names

      commits_list <- commits_list %>%
        purrr::discard(~ length(.) == 0)

      if (by == "team") {
        private$filter_commits_by_team(
          commits_list = commits_list,
          team = team
        )
      }
      commits_table <- commits_list %>%
      private$tailor_commits_info(org = org)  %>%
      private$prepare_commits_table()

      return(commits_table)
    }
  ),

  private = list(

    #' @description Perform get request to search API.
    #' @param phrase A phrase to look for in codelines.
    #' @param org A character, a group of projects.
    #' @param language A character specifying language used in repositories.
    #' @param page_max An integer, maximum number of pages.
    #' @return A list of repositories.
    search_repos_by_phrase = function(phrase,
                                      org,
                                      language,
                                      page_max = 1e6) {
      cli::cli_alert_info("[GitLab][{org}][Engine:{cli::col_green('REST')}] Searching repos...")
      page <- 1
      still_more_hits <- TRUE
      resp_list <- list()
      groups_id <- private$get_group_id(org)

      while (still_more_hits | page < page_max) {
        resp <- self$response(
          paste0(self$rest_api_url, "/groups/", groups_id,
                 "/search?scope=blobs&search=", phrase, "&per_page=100&page=", page)
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
        self$find_by_id(objects = "projects")

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
          "last_push" = NA,
          "last_activity_at" = x$last_activity_at,
          "languages" = NA,
          "issues_open" = x$issues_open,
          "issues_closed" = x$issues_closed,
          "contributors" = NA,
          "organization" = x$namespace$path
        )
      })

      projects_list
    },

    #' @description A method to add information on repository contributors.
    #' @param repos_table A table of repositories.
    #' @return A table of repositories with added information on contributors.
    get_repos_contributors = function(repos_table) {
      if (nrow(repos_table) > 0) {
        repo_iterator <- repos_table$id
        user_name <- rlang::expr(.$name)
        repos_table$contributors <- purrr::map(repo_iterator, function(repos_id) {
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
        repos_table$issues_open <- purrr::map_dbl(issues, ~.$opened)
        repos_table$issues_closed <- purrr::map_dbl(issues, ~.$closed)
      }
      return(repos_table)
    },

    #' @description Handler for pagination of commits response.
    #' @param project_id Id of a project.
    #' @param date_from A starting date to look commits for.
    #' @param date_until An end date to look commits for.
    #' @param page Page of a response.
    #' @return A list of commits.
    pull_commits_page_from_repo = function(project_id,
                                           date_from,
                                           date_until,
                                           page) {
      self$response(
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
    },

    #' @description A helper to retrieve only important info on commits
    #' @param commits_list A list, a formatted content of response returned by
    #'   GET API request
    #' @param org A character, name of a group
    #' @return A list of commits with selected information
    tailor_commits_info = function(commits_list,
                                   org) {
      commits_list <- purrr::map(commits_list, function(x) {
        purrr::map(x, function(y) {
          list(
            "id" = y$id,
            "organization" = org,
            "repository" = gsub(
              pattern = paste0("/-/commit/", y$id),
              replacement = "",
              x = gsub(paste0("(.*)", org, "/"), "", y$web_url)
            ),
            "additions" = y$stats$additions,
            "deletions" = y$stats$deletions,
            "committed_date" = gts_to_posixt(y$committed_date),
            "author" = y$author_name
          )
        })
      })

      commits_list
    },

    #' @description Filter by contributors.
    #' @param commits_list A commits list to be filtered.
    #' @param team A character vector with team member names.
    #' @return A list.
    filter_commits_by_team = function(commits_list,
                                      team) {
      team_names <- purrr::map_chr(team, ~.$name)
      commits_list <- purrr::map(commits_list, function(repo) {
        purrr::keep(repo, function(commit) {
          if (length(commit$author_name > 0)) {
            commit$author_name %in% team_names
          } else {
            FALSE
          }
        })
      }) %>% purrr::discard(~ length(.) == 0)

      commits_list
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
      self$response(paste0(self$rest_api_url, "/groups/", project_group)
      )[["id"]]
    }
  )
)
