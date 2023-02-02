#' @importFrom R6 R6Class
#' @importFrom dplyr mutate
#' @importFrom magrittr %>%
#' @importFrom rlang %||%
#'
#' @title A GitHub API Client class
#' @description An object with methods to obtain information form GitHub API.

GitHub <- R6::R6Class("GitHub",
  inherit = GitService,
  cloneable = FALSE,
  public = list(

    #' @description  A method to list all repositories for an organization,
    #'   a team or by a keyword.
    #' @param orgs A character vector of organizations (owners of repositories).
    #' @param by A character, to choose between: \itemize{\item{org - organizations
    #'   (owners of repositories)} \item{team - A team} \item{phrase - A keyword in
    #'   code blobs.}}
    #' @param team A list of team members. Specified by \code{set_team()} method
    #'   of GitStats class object.
    #' @param phrase A character to look for in code blobs. Obligatory if
    #'   \code{by} parameter set to \code{"phrase"}.
    #' @param language A character specifying language used in repositories.
    #' @return A data.frame of repositories.
    get_repos = function(orgs = self$orgs,
                         by,
                         team,
                         phrase,
                         language = NULL) {
      repos_dt <- purrr::map(orgs, function(x) {
        if (by == "phrase") {
          repos_list <- private$search_by_keyword(phrase,
            repo_owner = x,
            language = language
          )

          message(paste0("\n On GitHub platform (", self$rest_api_url, ") found ", length(repos_list), " repositories
               with searched keyword and concerning ", language, " language and ", x, " organization."))
        } else {
          repos_list <- private$pull_repos_from_org(org = x) %>%
            {
              if (by == "team") {
                private$filter_repos_by_team(
                  repos_list = .,
                  team = team
                )
              } else {
                .
              }
            } %>%
            {
              if (!is.null(language)) {
                private$filter_by_language(
                  repos_list = .,
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
    #' @param orgs A character vector of organisations (repository owners).
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
        private$get_all_commits_from_owner(
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
          private$tailor_commits_info(org = x) %>%
          private$attach_commits_stats() %>%
          private$prepare_commits_table()
      }) %>% rbindlist()

      commits_dt
    },

    #' @description A print method for a GitHub object
    print = function() {
      cat("GitHub API Client", sep = "\n")
      cat(paste0(" url: ", self$rest_api_url), sep = "\n")
      orgs <- paste0(self$orgs, collapse = ", ")
      cat(paste0(" orgs: ", orgs), sep = "\n")
    }
  ),
  private = list(

    #' @description Filter by contributors.
    #' @details If at least one member of a team is a contributor than a project
    #'   passes through the filter.
    #' @param repos_list A repository list to be filtered.
    #' @param team A character vector with team member names.
    #' @return A list.
    filter_repos_by_team = function(repos_list,
                                    team) {
      purrr::map(repos_list, function(x) {
        contributors <- tryCatch(
          {
            get_response(
              endpoint = paste0(self$rest_api_url, "/repos/", x$full_name, "/contributors"),
              token = private$token
            ) %>% purrr::map_chr(~ .$login)
          },
          error = function(e) {
            NA
          }
        )

        if (length(intersect(team, contributors)) > 0) {
          return(x)
        } else {
          return(NULL)
        }
      }) %>% purrr::keep(~ length(.) > 0)
    },

    #' @description Method to filter repositories by language used
    #' @param repos_list A repository list to be filtered.
    #' @param language A character specifying language used in repositories.
    #' @return A list of repositories.
    filter_by_language = function(repos_list,
                                  language) {
      purrr::keep(repos_list, ~ length(intersect(.$language, language)) > 0)
    },

    #' @description A helper to retrieve only important info on repos
    #' @param repos_list A list, a formatted content of response returned by GET API request
    #' @return A list of repos with selected information
    tailor_repos_info = function(repos_list) {
      repos_list <- purrr::map(repos_list, function(x) {
        list(
          "organisation" = x$owner$login,
          "name" = x$name,
          "created_at" = x$created_at,
          "last_activity_at" = x$updated_at,
          "description" = x$description
        )
      })

      repos_list
    },

    #' @description Search code by phrase
    #' @param phrase A phrase to look for in
    #'   codelines.
    #' @param repo_owner A character, an owner of repository.
    #' @param language A character specifying language used in repositories.
    #' @param byte_max According to GitHub
    #'   documentation only files smaller than 384 KB are searchable. See
    #'   \link{https://docs.github.com/en/rest/search?apiVersion=2022-11-28#search-code}
    #'
    #' @return A list of repositories.
    search_by_keyword = function(phrase,
                                    repo_owner,
                                    language,
                                    byte_max = "384000",
                                    api_url = self$rest_api_url,
                                    token = private$token) {
      search_endpoint <- if (!is.null(language)) {
        paste0(api_url, "/search/code?q='", phrase, "'+user:", repo_owner, "+language:", language)
      } else {
        paste0(api_url, "/search/code?q='", phrase, "'+user:", repo_owner)
      }

      total_n <- get_response(search_endpoint,
        token = token
      )[["total_count"]]

      if (length(total_n) > 0) {
        repos_list <- search_request(search_endpoint, total_n, byte_max, token)
        repos_list <- purrr::map_chr(repos_list, ~ .$repository$id) %>%
          unique() %>%
          private$find_by_id(objects = "repositories")
      } else {
        repos_list <- list()
      }

      return(repos_list)
    },

    #' @description GitHub private method to pull
    #'   commits from repo with REST API.
    #' @param repo_owner A character, an owner of repository.
    #' @param date_from A starting date to look commits for.
    #' @param date_until An end date to look commits for.
    #' @param rest_api_url A url of a REST API.
    #' @param token A token.
    #' @return A list of commits.
    get_all_commits_from_owner = function(repo_owner,
                                          date_from,
                                          date_until = Sys.date(),
                                          rest_api_url = self$rest_api_url,
                                          token = private$token) {
      repos_list <- private$pull_repos_from_org(
        org = repo_owner,
        rest_api_url = rest_api_url,
        token = token
      )

      enterprise_public <- if (self$enterprise) {
        "Enterprise"
      } else {
        "Public"
      }

      repos_names <- purrr::map_chr(repos_list, ~ .$full_name)

      pb <- progress::progress_bar$new(
        format = paste0("GitHub (", enterprise_public, ") Client (", repo_owner, "). Checking for commits since ", date_from, " in ", length(repos_names), " repos. [:bar] repo: :current/:total"),
        total = length(repos_names)
      )

      commits_list <- purrr::map(repos_names, function(x) {
        pb$tick()
        tryCatch(
          {
            get_response(
              endpoint = paste0(
                rest_api_url,
                "/repos/",
                x,
                "/commits?since=",
                git_time_stamp(date_from),
                "&until=",
                git_time_stamp(date_until)
              ),
              token = token
            )
          },
          error = function(e) {
            NULL
          }
        )
      })
      names(commits_list) <- repos_names

      commits_list <- commits_list %>% purrr::discard(~ length(.) == 0)

      # message("GitHub (", enterprise_public, ") (", repo_owner, "): pulled commits from ", length(commits_list), " repositories.")

      commits_list
    },

    #' @description Filter by contributors.
    #' @param commits_list A commits list to be filtered.
    #' @param team A character vector with team member names.
    #' @return A list.
    filter_commits_by_team = function(commits_list,
                                      team) {
      commits_list <- purrr::map(commits_list, function(repo) {
        purrr::keep(repo, function(commit) {
          if (length(commit$author$login > 0)) {
            commit$author$login %in% team
          } else {
            FALSE
          }
        })
      }) %>% purrr::discard(~ length(.) == 0)

      commits_list
    },

    #' @description A helper to retrieve
    #'   only important info on commits
    #' @details In case of GitHub REST API
    #'   there is no possibility to retrieve
    #'   stats from basic get commits API
    #'   endpoint. It is necessary to reach
    #'   to the API endpoint of single
    #'   commit, which is done in
    #'   \code{attach_commit_stats()}
    #'   method. Therefore
    #'   \code{tailor_commits_info()} is
    #'   'poorer" than the same method for
    #'   GitLab Client class, where you can
    #'   derive stats directly from commits
    #'   API endpoint with \code{with_stats}
    #'   attribute.
    #' @param commits_list A list, a
    #'   formatted content of response
    #'   returned by GET API request
    #' @param org A character, name
    #'   of an organisation
    #' @return A list of commits with
    #'   selected information
    tailor_commits_info = function(commits_list,
                                   org) {
      commits_list <- purrr::imap(commits_list, function(repo, repo_name) {
        purrr::map(repo, function(commit) {
          list(
            "id" = commit$sha,
            "organisation" = org,
            "repository" = gsub(
              pattern = paste0(org, "/"),
              replacement = "",
              x = repo_name
            ),
            "committed_date" = commit$commit$committer$date
          )
        })
      })

      commits_list
    },

    #' @description A method to retrieve statistics for commits.
    #' @param commits_list A list of commits.
    #' @return A list.
    attach_commits_stats = function(commits_list) {
      pb <- progress::progress_bar$new(
        format = paste0("Attaching commits stats: [:bar] repo: :current/:total"),
        total = length(commits_list)
      )
      purrr::imap(commits_list, function(repo, repo_name) {
        pb$tick()
        commit_stats <- purrr::map_chr(repo, ~ .$id) %>%
          purrr::map(function(commit_id) {
            commit_info <- get_response(
              endpoint = paste0(self$rest_api_url, "/repos/", repo_name, "/commits/", commit_id),
              token = private$token
            )

            list(
              additions = commit_info$stats$additions,
              deletions = commit_info$stats$deletions,
              files_changes = length(commit_info$files),
              files_added = length(grep("added", purrr::map_chr(commit_info$files, ~ .$status))),
              files_modified = length(grep("modified", purrr::map_chr(commit_info$files, ~ .$status)))
            )
          })

        purrr::map2(repo, commit_stats, function(repo_commit, repo_stats) {
          purrr::list_modify(repo_commit,
            additions = repo_stats$additions,
            deletions = repo_stats$deletions
          )
        })
      })
    }
  )
)
