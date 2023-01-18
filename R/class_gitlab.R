#' @importFrom R6 R6Class
#' @importFrom dplyr mutate
#' @importFrom magrittr %>%
#' @importFrom rlang %||%
#'
#' @title A GitLab API Client class
#' @description An object with methods to derive information form GitLab API.

GitLabClient <- R6::R6Class("GitLabClient",
  inherit = GitClient,
  cloneable = FALSE,
  public = list(
    groups = NULL,

    #' @description Create a new `GitLabClient` object
    #' @param rest_api_url A url of rest API.
    #' @param token A token.
    #' @param groups A character vector of groups of projects.
    #' @return A new `GitLabClient` object
    initialize = function(rest_api_url = NA,
                          token = NA,
                          groups = NA) {
      self$rest_api_url <- rest_api_url
      self$gql_api_url <- paste0(rest_api_url, "/graphql")
      private$token <- token
      self$groups <- groups
    },

    #' @description A method to list all repositories for an organization.
    #' @param project_groups A character vector of project groups.
    #' @return A data.frame of repositories
    get_projects_by_group = function(project_groups = self$groups) {
      tryCatch(
        {
          repos_dt <- purrr::map(project_groups, function(x) {
            perform_get_request(
              endpoint = paste0(self$rest_api_url, "/groups/", x, "/projects"),
              token = private$token
            ) %>%
              private$tailor_repos_info() %>%
              private$prepare_repos_table()
          }) %>%
            rbindlist()
        },
        error = function(e) {
          warning(paste0("HTTP status ", e$status, " noted when performing request for ", self$rest_api_url, ". \n Are you sure you defined properly your groups?"),
            call. = FALSE
          )
        }
      )

      repos_dt
    },

    #' @description A method to list all repositories
    #'   for a team.
    #' @param team A list of team members. Specified
    #'   by \code{set_team()} method of GitStats class
    #'   object.
    #' @param project_groups
    #' @return A data.frame of repositories
    get_repos_by_team = function(team,
                                 project_groups = self$groups) {
      repos_dt <- purrr::map(project_groups, function(x) {
        perform_get_request(
          endpoint = paste0(self$rest_api_url, "/groups/", x, "/projects"),
          token = private$token
        ) %>%
          private$filter_projects_by_team(team = team) %>%
          private$tailor_repos_info() %>%
          private$prepare_repos_table()
      }) %>%
        rbindlist()

      repos_dt
    },

    #' @description A method to find repositories with given phrase in code lines.
    #' @param phrase A phrase to look for in codelines.
    #' @param language A character specifying language used in repositories.
    #' @return A data.frame of repositories
    get_repos_by_codephrase = function(phrase,
                                       language = "R") {
      language <- private$language_handler(language)

      repos_dt <- private$search_by_codephrase(phrase,
        api_url = self$rest_api_url,
        language = language
      ) %>%
        purrr::map_chr(~ .$project_id) %>%
        unique() %>%
        private$find_projects_by_id() %>%
        private$tailor_repos_info() %>%
        private$prepare_repos_table()

      message(paste0("On GitLab platform (", self$rest_api_url, ") found ", nrow(repos_dt), " repositories with searched codephrase and concerning ", language, " language."))

      repos_dt
    },

    #' @description A method to get information on commits.
    #' @param groups
    #' @param date_from
    #' @param date_until
    #' @return A data.frame
    get_commits_by_group = function(groups = self$groups,
                                    date_from,
                                    date_until = Sys.time()) {
      commits_dt <- purrr::map(groups, function(x) {
        private$get_all_commits_from_group(
          x,
          date_from,
          date_until
        ) %>%
          private$tailor_commits_info(group_name = x) %>%
          private$prepare_commits_table()
      }) %>% rbindlist()

      return(commits_dt)
    },

    #' @description A method to get information on commits.
    #' @param team
    #' @param groups
    #' @param date_from
    #' @param date_until
    #' @param by
    #' @return A data.frame
    get_commits_by_team = function(team,
                                   groups = self$groups,
                                   date_from,
                                   date_until = Sys.time(),
                                   by) {
      commits_dt <- purrr::map(groups, function(x) {
        private$get_all_commits_from_group(
          x,
          date_from,
          date_until
        ) %>%
          private$filter_commits_by_team(team) %>%
          private$tailor_commits_info(group_name = x) %>%
          private$prepare_commits_table()
      }) %>% rbindlist()

      return(commits_dt)
    },

    #' @description A print method for a GitHubClient object
    print = function() {
      cat("GitLab API Client", sep = "\n")
      cat(paste0(" url: ", self$rest_api_url), sep = "\n")
      cat(paste0(" groups: ", self$groups), sep = "\n")
    }
  ),
  private = list(

    #' @description A helper to prepare table for repositories content
    #' @param projects_list A projects list
    #' @return A data.frame
    prepare_repos_table = function(projects_list) {
      projects_dt <- purrr::map(projects_list, function(project) {
        project <- purrr::map(project, function(attr) {
          attr <- attr %||% ""
        })
        data.frame(project)
      }) %>%
        data.table::rbindlist()

      if (length(projects_dt) > 0) {
        projects_dt <- dplyr::mutate(projects_dt,
          git_platform = "GitLab",
          api_url = self$rest_api_url,
          created_at = as.POSIXct(created_at),
          last_activity_at = difftime(Sys.time(), as.POSIXct(last_activity_at),
            units = "days"
          )
        )
      }

      return(projects_dt)
    },

    #' @description Filter by contributors.
    #' @param projects_list A repository list to be filtered.
    #' @param team A character vector with team member names.
    filter_projects_by_team = function(projects_list,
                                       team) {
      purrr::map(projects_list, function(x) {
        members <- tryCatch(
          {
            perform_get_request(
              endpoint = paste0(self$rest_api_url, "/projects/", x$id, "/members/all"),
              token = private$token
            ) %>% purrr::map_chr(~ .$username)
          },
          error = function(e) {
            NA
          }
        )

        if (length(intersect(team, members)) > 0) {
          return(x)
        } else {
          return(NULL)
        }
      }) %>% purrr::keep(~ length(.) > 0)
    },

    #' @description Perform get request to search API.
    #' @param phrase A phrase to look for in codelines.
    #' @param language A character specifying language used in repositories.
    #' @param page_max
    #' @return A list as a formatted content of a reponse.
    search_by_codephrase = function(phrase,
                                    language,
                                    page_max = 1e6,
                                    api_url = self$rest_api_url,
                                    token = private$token) {
      page <- 1
      still_more_hits <- TRUE
      resp_list <- list()

      while (still_more_hits | page < page_max) {
        resp <- perform_get_request(paste0(api_url, "/search?scope=blobs&search='", phrase, "'&per_page=1000&page=", page),
          token = private$token
        )

        if (length(resp) == 0) {
          still_more_hits <- FALSE
          break()
        } else {
          resp_list <- append(resp_list, resp)
          page <- page + 1
        }
      }

      repos_list <- private$filter_by_language(resp_list, language)

      return(repos_list)
    },

    #' @description Perform get request to find projects by ids.
    #' @param project_ids A character vector of projects' ids.
    #' @return A list of projects.
    find_projects_by_id = function(projects_ids,
                                   api_url = self$rest_api_url,
                                   token = private$token) {
      projects_list <- purrr::map(projects_ids, function(x) {
        content <- perform_get_request(
          paste0(api_url, "/projects/", x, ""),
          token
        )
      })

      projects_list
    },

    #' @description A helper to retrieve only important info on repos
    #' @param projects_list A list, a formatted content of response returned by GET API request
    #' @return A list of repos with selected information
    tailor_repos_info = function(projects_list) {
      projects_list <- purrr::map(projects_list, function(x) {
        list(
          "owner/group" = x$namespace$path,
          "name" = x$name,
          "created_at" = x$created_at,
          "last_activity_at" = x$last_activity_at,
          "description" = x$description
        )
      })

      projects_list
    },

    #' @description Filter projects by programming
    #'   language
    #' @param projects_list A list of projects to be
    #'   filtered.
    #' @param language A character, name of a
    #'   programming language.
    #' @details This method is specific for GitLab
    #'   Client class as there is no possibility
    #'   currently to add language filter to search
    #'   endpoint. As for now, an epic is in progress
    #'   on GitLab to add this feature. For more
    #'   details you can visit:
    #'   \link{https://gitlab.com/gitlab-org/gitlab/-/issues/342648}
    #' @return A list of projects where speicfied
    #'   language is used.
    #'
    filter_by_language = function(projects_list,
                                  language,
                                  api_url = self$rest_api_url,
                                  token = private$token) {
      projects_id <- unique(purrr::map_chr(projects_list, ~ .$project_id))

      projects_language_list <- purrr::map(projects_id, function(x) {
        perform_get_request(
          endpoint = paste0(api_url, "/projects/", x, "/languages"),
          token = token
        )
      })

      names(projects_language_list) <- projects_id

      filtered_projects <- purrr::map(projects_language_list, function(x) {
        purrr::map_chr(x, ~.)
      }) %>%
        purrr::keep(~ language %in% names(.))

      filtered_projects_list <- purrr::keep(projects_list, ~ .$project_id %in% names(filtered_projects))

      return(filtered_projects_list)
    },

    #' @description
    #' @param commits_list
    #' @return A data.frame
    prepare_commits_table = function(commits_list) {
      purrr::map(commits_list, function(x) {
        purrr::map(x, ~ data.frame(.)) %>%
          rbindlist()
      }) %>% rbindlist()
    },

    #' @description GitLab private method to derive
    #'   commits from repo with REST API.
    #' @param project_group
    #' @param date_from
    #' @param date_until
    #' @return A list of commits
    get_all_commits_from_group = function(project_group,
                                          date_from,
                                          date_until = Sys.date()) {
      commits_list <- perform_get_request(
        endpoint = paste0(self$rest_api_url, "/groups/", project_group, "/projects"),
        token = private$token
      ) %>%
        purrr::map_chr(~ .$id) %>%
        purrr::map(~ perform_get_request(
          endpoint = paste0(
            self$rest_api_url,
            "/projects/",
            .,
            "/repository/commits?since=",
            git_time_stamp(date_from),
            "&until=",
            git_time_stamp(date_until),
            "&with_stats=true"
          ),
          token = private$token
        ))

      message("GitLab (", project_group, "): pulled commits from ", length(commits_list), " repositories.")

      commits_list
    },

    #' @description Filter by contributors.
    #' @param commits_list A commits list to be filtered.
    #' @param team A character vector with team member names.
    filter_commits_by_team = function(commits_list,
                                      team) {

    },

    #' @description A helper to retrieve only important info on commits
    #' @param commits_list A list, a formatted content of response returned by GET API request
    #' @param group_name A character, name of a group
    #' @return A list of commits with selected information
    tailor_commits_info = function(commits_list,
                                   group_name) {
      commits_list <- purrr::map(commits_list, function(x) {
        purrr::map(x, function(y) {
          list(
            "id" = y$id,
            "owner_group" = group_name,
            "repo_project" = gsub(
              pattern = paste0("/-/commit/", y$id),
              replacement = "",
              x = gsub(paste0("(.*)", group_name, "/"), "", y$web_url)
            ),
            "additions" = y$stats$additions,
            "deletions" = y$stats$deletions,
            # "commiterName" = y$committer_name,
            "committedDate" = y$committed_date
          )
        })
      })

      commits_list
    },

    #' @description Switcher to manage language names
    #' @details E.g. GitLab API will not filter
    #'   properly if you provide 'python' language
    #'   with small letter.
    #' @param language A character, language name
    language_handler = function(language) {
      substr(language, 1, 1) <- toupper(substr(language, 1, 1))

      language
    }
  )
)
