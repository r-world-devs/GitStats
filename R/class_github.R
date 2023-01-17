#' @importFrom R6 R6Class
#' @importFrom dplyr mutate
#' @importFrom magrittr %>%
#' @importFrom rlang %||%
#'
#' @title A GitHub API Client class
#' @description An object with methods to derive information form GitHub API.

GitHub <- R6::R6Class("GitHub",
  inherit = GitService,
  cloneable = FALSE,
  public = list(
    owners = NULL,

    enterprise = NULL,

    #' @description Create a new `GitHub` object
    #' @param rest_api_url A url of rest API.
    #' @param gql_api_url A url of GraphQL API.
    #' @param token A token.
    #' @param owners A character vector of owners of repositories.
    #' @return A new `GitHub` object
    initialize = function(rest_api_url = NA,
                          gql_api_url = NA,
                          token = NA,
                          owners = NA) {
      self$rest_api_url <- rest_api_url
      if (is.na(gql_api_url)) {
        private$set_gql_url()
      } else {
        self$gql_api_url <- gql_api_url
      }
      private$token <- token
      self$owners <- owners
      self$enterprise <- private$check_enterprise_github(self$rest_api_url)
    },

    #' @description A method to list all repositories for an organization.
    #' @param repos_owner A character vector of repository owners.
    #' @return A data.frame of repositories
    get_repos_by_owner = function(repos_owner = self$owners) {
      tryCatch(
        {
          repos_dt <- purrr::map(repos_owner, function(x) {
            perform_get_request(
              endpoint = paste0(self$rest_api_url, "/orgs/", x, "/repos"),
              token = private$token
            ) %>%
              private$tailor_repos_info() %>%
              private$prepare_repos_table()
          }) %>%
            rbindlist()
        },
        error = function(e) {
          warning(paste0("HTTP status ", e$status, " noted when performing request for ", self$rest_api_url, ". \n Are you sure you defined properly your owners?"),
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
    #' @param repos_owners
    #' @return A data.frame of repositories
    get_repos_by_team = function(team,
                                 repos_owners = self$owners) {
      repos_dt <- purrr::map(repos_owners, function(x) {
        perform_get_request(
          endpoint = paste0(self$rest_api_url, "/orgs/", x, "/repos"),
          token = private$token
        ) %>%
          private$filter_repos_by_team(team = team) %>%
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
    #' @param owner
    #' @param date_from
    #' @param date_until
    #' @return A data.frame
    get_commits_by_owner = function(owners = self$owners,
                                    date_from,
                                    date_until = Sys.time()) {
      commits_dt <- purrr::map(owners, function(x) {
        private$get_gql_commit_query(
          owner = x,
          date_from,
          date_until
        )
      }) %>%
        private$prepare_commits_table()

      return(commits_dt)
    },

    #' @description A method to get information on commits.
    #' @param team
    #' @param date_from
    #' @param date_until
    #' @return A data.frame
    get_commits_by_team = function(team,
                                   owners = self$owners,
                                   date_from,
                                   date_until = Sys.time()) {
      commits_dt <- purrr::map(owners, function(x) {
        private$get_all_commits_from_owner(
          x,
          date_from,
          date_until
        ) %>%
          private$filter_commits_by_team(team) %>%
          private$tailor_commits_info(repos_owner = x) %>%
          private$attach_commits_stats() %>%
          private$prepare_commits_table()
      }) %>% rbindlist()

      return(commits_dt)
    },

    #' @description A print method for a GitHub object
    print = function() {
      cat("GitHub API Client", sep = "\n")
      cat(paste0(" url: ", self$rest_api_url), sep = "\n")
      owners <- paste0(self$owners, collapse = ", ")
      cat(paste0(" owners: ", owners), sep = "\n")
    }
  ),
  private = list(

    #' @description A helper to prepare table for repositories content
    #' @param repos_list A repository list.
    #' @return A data.frame.
    prepare_repos_table = function(repos_list) {
      repos_dt <- purrr::map(repos_list, function(repo) {
        repo <- purrr::map(repo, function(attr) {
          attr <- attr %||% ""
        })
        data.frame(repo)
      }) %>%
        data.table::rbindlist()

      if (length(repos_dt) > 0) {
        repos_dt <- dplyr::mutate(repos_dt,
          git_platform = "GitHub",
          api_url = self$rest_api_url,
          created_at = as.POSIXct(created_at),
          last_activity_at = difftime(Sys.time(), as.POSIXct(last_activity_at),
            units = "days"
          )
        )
      }

      return(repos_dt)
    },

    #' @description Filter by contributors.
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

    #' @description A helper to retrieve only important info on repos
    #' @param repos_list A list, a formatted content of response returned by GET API request
    #' @return A list of repos with selected information
    tailor_repos_info = function(repos_list) {
      repos_list <- purrr::map(repos_list, function(x) {
        list(
          "owner/group" = x$owner$login,
          "name" = x$name,
          "created_at" = x$created_at,
          "last_activity_at" = x$updated_at,
          "description" = x$description
        )
      })

      repos_list
    },

    #' @description GitLab private method to derive
    #'   commits from repo with REST API.
    #' @param repo_owner
    #' @param date_from
    #' @param date_until
    #' @return A list of commits
    get_all_commits_from_owner = function(repo_owner,
                                          date_from,
                                          date_until = Sys.date()) {

      # total_n <- perform_get_request(endpoint = paste0(self$rest_api_url, "/search/repositories?q='org:", repo_owner, "'"),
      #                                token = private$token)[["total_count"]]
      repos_list <- list()
      r_page <- 1
      repeat {
        repos_page <- perform_get_request(
          endpoint = paste0(self$rest_api_url, "/orgs/", repo_owner, "/repos?per_page=100&page=", r_page),
          token = private$token
        )
        if (length(repos_page) > 0) {
          repos_list <- append(repos_list, repos_page)
          r_page <- r_page + 1
        } else {
          break
        }
      }

      repos_names <- purrr::map_chr(repos_list, ~ .$full_name)

      enterprise_public <- if (self$enterprise) {
        "Enterprise"
      } else {
        "Public"
      }

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
                self$rest_api_url,
                "/repos/",
                x,
                "/commits?since=",
                git_time_stamp(date_from),
                "&until=",
                git_time_stamp(date_until)
              ),
              token = private$token
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
    #' @param repos_owner A character, name
    #'   of an owner
    #' @return A list of commits with
    #'   selected information
    tailor_commits_info = function(commits_list,
                                   repos_owner) {
      commits_list <- purrr::imap(commits_list, function(repo, repo_name) {
        purrr::map(repo, function(commit) {
          list(
            "id" = commit$sha,
            "owner_group" = repos_owner,
            "repo_project" = gsub(
              pattern = paste0(repos_owner, "/"),
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
      purrr::imap(commits_list, function(repo, repo_name) {
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

    #' #' @description
    #' #' @param repo
    #' find_owner_by_repo = function(repo){
    #'
    #'   list_repos <- purrr::map(self$owners, ~self$get_repos_by_owner(.)$name)
    #'   names(list_repos) <- self$owners
    #'   owner <- which(purrr::map_lgl(list_repos, ~repo %in% .))
    #'
    #'   if (length(owner)>0){
    #'     names(owner)
    #'   } else {
    #'     "no owner found"
    #'   }
    #'
    #' },

    #' @description GraphQL url handler (if not provided)
    set_gql_url = function(gql_api_url = self$gql_api_url,
                           rest_api_url = self$rest_api_url) {
      self$gql_api_url <- paste0(gsub("/v+.*", "", rest_api_url), "/graphql")
    },

    #' @description A helper to check if GitHub Client is Public or Enterprise.
    #' @param api_url A character, a url of API.
    #' @return A boolean.
    check_enterprise_github = function(api_url){

      if (api_url != "https://api.github.com" && grepl("github", api_url)){
        TRUE
      } else {
        FALSE
      }

    }
  )
)
