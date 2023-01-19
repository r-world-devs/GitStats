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

    #' @description A method to list all repositories for an organization.
    #' @param orgs A character vector of organizations (owners of repositories).
    #' @param by A character, to choose between: \itemize{
    #'   \item{org}{Organizations - owners of repositories} \item(team){A team}}
    #' @param team A list of team members. Specified by \code{set_team()} method
    #'   of GitStats class object.
    #' @return A data.frame of repositories.
    get_repos = function(orgs = self$orgs,
                         by,
                         team) {
      repos_dt <- purrr::map(orgs, function(x) {
        private$get_all_repos_from_owner(repo_owner = x) %>%
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
          private$tailor_repos_info() %>%
          private$prepare_repos_table()
      }) %>%
        rbindlist()

      repos_dt
    },

    #' @description A method to find repositories with given phrase in codelines.
    #' @param phrase A phrase to look for in codelines.
    #' @param language A character specifying language used in repositories.
    #' @return A data.frame of repositories.
    get_repos_by_codephrase = function(phrase,
                                       language = "R") {
      repos_dt <- private$search_by_codephrase(phrase,
        api_url = self$rest_api_url,
        language = language
      ) %>%
        purrr::map_chr(~ .$repository$id) %>%
        unique() %>%
        private$find_repos_by_id() %>%
        private$tailor_repos_info() %>%
        private$prepare_repos_table()

      message(paste0("On GitHub platform (", self$rest_api_url, ") found ", nrow(repos_dt), " repositories with searched codephrase and concerning ", language, " language."))

      repos_dt
    },

    #' @description A method to get information on commits.
    #' @param orgs A character vector of organisations (repository owners).
    #' @param date_from A starting date to look commits for
    #' @param date_until An end date to look commits for
    #' @param by A character, to choose between: \itemize{
    #'   \item{org}{Organizations - owners of repositories} \item(team){A team}}
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

    #' @description A method to pull all repositories for an owner.
    #' @param repo_owner A character, an owner of repository.
    #' @param rest_api_url A url of a REST API.
    #' @param token A token.
    #' @return A list.
    get_all_repos_from_owner = function(repo_owner,
                                        rest_api_url = self$rest_api_url,
                                        token = private$token) {
      repos_list <- list()
      r_page <- 1
      repeat {
        repos_page <- perform_get_request(
          endpoint = paste0(rest_api_url, "/orgs/", repo_owner, "/repos?per_page=100&page=", r_page),
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
    #' @param repos_list A repository list to be filtered.
    #' @param team A character vector with team member names.
    #' @return A list.
    filter_repos_by_team = function(repos_list,
                                    team) {
      purrr::map(repos_list, function(x) {
        contributors <- tryCatch(
          {
            perform_get_request(
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
    #' @param language A character specifying language used in repositories.
    #' @param byte_max According to GitHub
    #'   documentation only files smaller than 384 KB are searchable. See
    #'   \link{https://docs.github.com/en/rest/search?apiVersion=2022-11-28#search-code}
    #'
    #' @return A list as a formatted content of a response.
    search_by_codephrase = function(phrase,
                                    language,
                                    byte_max = "384000",
                                    api_url = self$rest_api_url,
                                    token = private$token) {
      search_endpoint <- paste0(api_url, "/search/code?q='", phrase, "'+language:", language)
      # byte_max <- as.character(byte_max)

      total_n <- perform_get_request(search_endpoint,
        token = token
      )[["total_count"]]

      repos_list <- search_request(search_endpoint, total_n, byte_max, token)

      return(repos_list)
    },

    #' @description Perform get request to find repositories by ids
    #' @param repos_ids A character vector of repositories' ids.
    #' @return A list of repos.
    find_repos_by_id = function(repos_ids,
                                api_url = self$rest_api_url,
                                token = private$token) {
      repos_list <- purrr::map(repos_ids, function(x) {
        content <- perform_get_request(
          paste0(api_url, "/repositories/", x, ""),
          token
        )
      })

      repos_list
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
      repos_list <- private$get_all_repos_from_owner(
        repo_owner = repo_owner,
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
            perform_get_request(
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

      message("GitHub (", enterprise_public, ") (", repo_owner, "): pulled commits from ", length(commits_list), " repositories.")

      commits_list
    },

    #' @description Filter by contributors.
    #' @param commits_list A commits list to be filtered.
    #' @param team A character vector with team member names.
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
            "repo_project" = gsub(
              pattern = paste0(org, "/"),
              replacement = "",
              x = repo_name
            ),
            # "additions" = commit$stats$additions,
            # "deletions" = commit$stats$deletions,
            # "commiterName" = commit$committer_name,
            "committedDate" = commit$commit$committer$date
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
            commit_info <- perform_get_request(
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
