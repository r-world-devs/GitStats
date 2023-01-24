#' @importFrom R6 R6Class
#' @importFrom dplyr mutate
#' @importFrom magrittr %>%
#' @importFrom rlang %||%
#'
#' @title A GitLab API Client class
#' @description An object with methods to obtain information form GitLab API.

GitLab <- R6::R6Class("GitLab",
  inherit = GitService,
  cloneable = FALSE,
  public = list(

    #' @description A method to list all repositories for an organization, a
    #'   team or by a codephrase.
    #' @param orgs A character vector of organisations (project groups).
    #' @param by A character, to choose between: \itemize{\item{org - organizations
    #'   (owners of repositories)} \item{team - A team} \item{phrase - A keyword in
    #'   code blobs.}}
    #' @param team A list of team members. Specified by \code{set_team()} method
    #'   of GitStats class object.
    #' @param phrase A phrase to look for in codelines. Obligatory if \code{by}
    #'   parameter set to \code{"phrase"}.
    #' @param language A character specifying language used in repositories.
    #' @return A data.frame of repositories
    get_repos = function(orgs = self$orgs,
                         by,
                         team,
                         phrase,
                         language = NULL) {
      language <- private$language_handler(language)

      repos_dt <- purrr::map(orgs, function(x) {
        if (by == "phrase") {
          repos_list <- private$search_by_codephrase(phrase,
            project_group = x
          )

          message(paste0("\n On GitLab platform (", self$rest_api_url, ") found ", length(repos_list), " repositories
                 with searched codephrase and concerning ", language, " language and ", x, " organization."))
        } else {
          repos_list <- private$get_all_repos_from_group(project_group = x) %>%
            {
              if (by == "team") {
                private$filter_projects_by_team(
                  projects_list = .,
                  team = team
                )
              } else {
                .
              }
            } %>% {
              if (!is.null(language)) {
                private$filter_by_language(
                  projects_list = .,
                  language = language
                )
              } else {
                .
              }
            }
        }

        repos_dt <- repos_list %>%
          private$tailor_repos_info() %>%
          private$prepare_repos_table()
      }) %>%
        rbindlist()

      repos_dt
    },

    #' @description A method to get information on commits.
    #' @param orgs A character vector of organisations (project groups).
    #' @param date_from A starting date to look commits for
    #' @param date_until An end date to look commits for
    #' @param by A character, to choose between: \itemize{\item{org - organizations
    #'   (owners of repositories)} \item{team - A team} \item{phrase - A keyword in
    #'   code blobs.}}
    #' @param team A list of team members. Specified by \code{set_team()} method
    #'   of GitStats class object.
    #' @return A data.frame of commits
    get_commits = function(orgs = self$orgs,
                           date_from,
                           date_until = Sys.time(),
                           by,
                           team) {
      commits_dt <- purrr::map(orgs, function(x) {
        private$get_all_commits_from_group(
          x,
          date_from,
          date_until
        ) %>%
          {
            if (by == "team") {
              private$filter_commits_by_team(
                commits_list = .,
                team = team
              )
            } else {
              .
            }
          } %>%
          private$tailor_commits_info(group_name = x) %>%
          private$prepare_commits_table()
      }) %>% rbindlist()

      commits_dt
    },

    #' @description A print method for a GitLab object
    print = function() {
      cat("GitLab API Client", sep = "\n")
      cat(paste0(" url: ", self$rest_api_url), sep = "\n")
      orgs <- paste0(self$orgs, collapse = ", ")
      cat(paste0(" orgs: ", orgs), sep = "\n")
    }
  ),
  private = list(

    #' @description A method to pull all repositories for an owner.
    #' @param project_group A character, a group of projects.
    #' @param rest_api_url A url of a REST API.
    #' @param token A token.
    #' @return A list.
    get_all_repos_from_group = function(project_group,
                                        rest_api_url = self$rest_api_url,
                                        token = private$token) {
      repos_list <- list()
      r_page <- 1
      repeat {
        repos_page <- perform_get_request(
          endpoint = paste0(rest_api_url, "/groups/", project_group, "/projects?per_page=100&page=", r_page),
          token = token
        )
        if (length(repos_page) > 0) {
          repos_list <- append(repos_list, repos_page)
          r_page <- r_page + 1
        } else {
          break
        }
      }

      repos_list
    },

    #' @description Filter by contributors.
    #' @details If at least one member of a team is a contributor than a project
    #'   passes through the filter.
    #' @param projects_list A repository list to be filtered.
    #' @param team A character vector with team member names.
    #' @return A list of repositories.
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
    filter_by_language = function(projects_list,
                                  language,
                                  api_url = self$rest_api_url,
                                  token = private$token) {

      projects_id <- unique(purrr::map_chr(projects_list, ~ .$id))

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

      if (length(filtered_projects) > 0){
        purrr::keep(projects_list, ~ .$id %in% names(filtered_projects))
      } else {
        list()
      }

    },

    #' @description A helper to retrieve only important info on repos
    #' @param projects_list A list, a formatted content of response returned by GET API request
    #' @return A list of repos with selected information
    tailor_repos_info = function(projects_list) {
      projects_list <- purrr::map(projects_list, function(x) {
        list(
          "organisation" = x$namespace$path,
          "name" = x$name,
          "created_at" = x$created_at,
          "last_activity_at" = x$last_activity_at,
          "description" = x$description
        )
      })

      projects_list
    },

    #' @description Perform get request to search API.
    #' @param phrase A phrase to look for in codelines.
    #' @param project_group A character, a group of projects.
    #' @param page_max
    #' @return A list of repositories.
    search_by_codephrase = function(phrase,
                                    project_group,
                                    page_max = 1e6,
                                    api_url = self$rest_api_url,
                                    token = private$token) {
      page <- 1
      still_more_hits <- TRUE
      resp_list <- list()
      groups_id <- private$get_group_id(project_group)

      while (still_more_hits | page < page_max) {
        resp <- perform_get_request(paste0(api_url, "/groups/", groups_id, "/search?scope=blobs&search=", phrase, "&per_page=100&page=", page),
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

      repos_list <- purrr::map_chr(resp_list, ~ .$project_id) %>%
        unique() %>%
        private$find_projects_by_id()

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

    #' @description GitLab private method to derive
    #'   commits from repo with REST API.
    #' @param project_group A character, a group of projects.
    #' @param date_from A starting date to look commits for.
    #' @param date_until An end date to look commits for.
    #' @return A list of commits
    get_all_commits_from_group = function(project_group,
                                          date_from,
                                          date_until = Sys.date(),
                                          rest_api_url = self$rest_api_url,
                                          token = private$token) {
      repos_list <- private$get_all_repos_from_group(
        project_group = project_group,
        rest_api_url = rest_api_url,
        token = token
      )

      repos_names <- purrr::map_chr(repos_list, ~ .$name)
      projects_ids <- purrr::map_chr(repos_list, ~ .$id)

      pb <- progress::progress_bar$new(
        format = paste0("GitLab Client (", project_group, "). Checking for commits since ", date_from, " in ", length(repos_names), " repos. [:bar] repo: :current/:total"),
        total = length(repos_names)
      )

      commits_list <- purrr::map(projects_ids, function(x) {
        pb$tick()

        perform_get_request(
          endpoint = paste0(
            self$rest_api_url,
            "/projects/",
            x,
            "/repository/commits?since='",
            git_time_stamp(date_from),
            "'&until='",
            git_time_stamp(date_until),
            "'&with_stats=true"
          ),
          token = private$token
        )
      })

      names(commits_list) <- repos_names

      commits_list <- commits_list %>%
        purrr::discard(~ length(.) == 0)

      message("GitLab (", project_group, "): pulled commits from ", length(commits_list), " repositories.")

      return(commits_list)
    },

    #' @description Filter by contributors.
    #' @param commits_list A commits list to be filtered.
    #' @param team A character vector with team member names.
    filter_commits_by_team = function(commits_list,
                                      team) {
      commits_list <- purrr::map(commits_list, function(repo) {
        purrr::keep(repo, function(commit) {
          if (length(commit$author_name > 0)) {
            commit$author_name %in% team
          } else {
            FALSE
          }
        })
      }) %>% purrr::discard(~ length(.) == 0)

      commits_list
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
            "organisation" = group_name,
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
    #' @return A character
    language_handler = function(language) {
      if (!is.null(language)) {
        substr(language, 1, 1) <- toupper(substr(language, 1, 1))
      }

      language
    },

    #' @description A helper to get group's id
    #' @param project_group A character, a group of projects.
    #' @return An integer, id of group.
    get_group_id = function(project_group) {
      perform_get_request(paste0(self$rest_api_url, "/groups/", project_group),
        token = private$token
      )[["id"]]
    }
  )
)
