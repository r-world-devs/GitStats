#' @importFrom R6 R6Class
#' @importFrom dplyr mutate rename
#' @importFrom magrittr %>%
#' @importFrom progress progress_bar
#' @importFrom rlang expr %||%
#' @importFrom cli cli_alert cli_alert_success col_green
#'
#' @title A GitHub API Client class
#' @description An object with methods to obtain information form GitHub API.

GitHub <- R6::R6Class("GitHub",
  inherit = GitService,
  cloneable = FALSE,
  public = list(

    #' @field repos_endpoint An expression for repositories endpoint.
    repos_endpoint = rlang::expr(paste0(self$rest_api_url, "/orgs/", org, "/repos")),

    #' @field repo_contributors_endpoint An expression for repositories contributors endpoint.
    repo_contributors_endpoint = rlang::expr(paste0(self$rest_api_url, "/repos/", repo$full_name, "/contributors")),

    #' @description A method to get information on commits.
    #' @param orgs A character vector of organisations.
    #' @param date_from A starting date to look commits for.
    #' @param date_until An end date to look commits for.
    #' @param by A character, to choose between: \itemize{\item{org -
    #'   organizations (owners of repositories or project groups)} \item{team -
    #'   A team} \item{phrase - A keyword in code blobs.}}
    #' @param team A list of team members. Specified by \code{set_team()} method
    #'   of GitStats class object.
    #' @return A data.frame of commits
    get_commits = function(orgs = self$orgs,
                           date_from,
                           date_until = Sys.Date(),
                           by,
                           team) {

      purrr::map(orgs, function(org) {
        private$get_commits_from_org(org,
                                     date_from = date_from,
                                     date_until = date_until)
      }) %>%
        rbindlist()

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

    #' @description
    #' @param org
    #' @param date_from A starting date to look commits for.
    #' @param date_until An end date to look commits for.
    #' @return A table of commits
    get_commits_from_org = function(org,
                                    date_from,
                                    date_until) {

      repos_list <- private$pull_repos_from_org(
        org = org
      )

      enterprise_public <- if (self$enterprise) {
        "Enterprise"
      } else {
        "Public"
      }

      repos_names <- purrr::map_chr(repos_list, ~ .$name)

      pb <- progress::progress_bar$new(
        format = paste0("GitHub ", enterprise_public, " (", org, "). Checking for commits since ", date_from, " in ", length(repos_names), " repos. [:bar] repo: :current/:total"),
        total = length(repos_names)
      )

      repos_list_with_commits <- purrr::map(repos_names, function(repo) {
        next_page <- TRUE
        full_commits_list <- list()
        end_cursor <- ''
        pb$tick()
        while (next_page) {
          gql <- GraphQL$new()
          commits_by_org_query <- gql$gh_commits_by_org(
            org = org,
            repo = repo,
            since = date_to_gts(date_from),
            until = date_to_gts(date_until),
            cursor = end_cursor
          )
          response <- gql_response(
            api_url = self$gql_api_url,
            gql_query = commits_by_org_query,
            token = private$token
          )
          commits_list <- response$data$repository$defaultBranchRef$target$history$edges
          next_page <- response$data$repository$defaultBranchRef$target$history$pageInfo$hasNextPage
          if (is.null(next_page)) next_page <- FALSE
          if (is.null(commits_list)) commits_list <- list()
          if (next_page) {
            end_cursor <- response$data$repository$defaultBranchRef$target$history$pageInfo$endCursor
          } else {
            end_cursor <- ''
          }
          full_commits_list <- append(full_commits_list, commits_list)
        }
        full_commits_list
      })

      names(repos_list_with_commits) <- repos_names

      repos_list_with_commits <- repos_list_with_commits %>%
        purrr::discard(~ length(.) == 0)

      repos_list_with_commits %>%
        private$prepare_commits_table_gql()

    },

    #' @description Pull all organisations form API.
    #' @param org_limit An integer defining how many org may API pull.
    #' @return A character vector of organizations names.
    pull_all_organizations = function(org_limit = self$org_limit) {

      total_count <- get_response(
        endpoint = paste0(self$rest_api_url, "/search/users?q=type:org"),
        token = private$token
      )[["total_count"]]

      if (total_count > org_limit) {
        warning("Number of organizations exceeds limit (", org_limit, "). I will pull only first ", org_limit, " organizations.",
                call. = FALSE,
                immediate. = FALSE
        )
        org_n <- org_limit
      } else {
        cli::cli_alert("Pulling all organizations.")
        org_n <- total_count
      }

      orgs_endpoint <- paste0(self$rest_api_url, "/organizations?per_page=100")

      orgs_list <- get_response(
        endpoint = orgs_endpoint,
        token = private$token
      )

      while (length(orgs_list) < org_n) {
        last_id <- tail(purrr::map_dbl(orgs_list, ~ .$id), 1)
        endpoint <- paste0(orgs_endpoint, "&since=", last_id)
        orgs_list <- get_response(
          endpoint = endpoint,
          token = private$token
        ) %>%
          append(orgs_list, .)
      }

      org_names <- purrr::map_chr(orgs_list, ~ .$login)
      org_n <- length(org_names)

      cli::cli_alert_success(cli::col_green(
        "Pulled {org_n} organizations."))

      return(org_names)
    },

    #' @description Pull organisations from API in which are engaged team members.
    #' @param team A character vector of team members.
    #' @return A character vector of organizations names.
    pull_team_organizations = function(team) {
      cli::cli_alert("Pulling organizations by team.")
      orgs_list <- purrr::map(team, function(team_member) {
        suppressMessages({
          get_response(
            endpoint = paste0(self$rest_api_url, "/users/", team_member, "/orgs"),
            token = private$token
          )
        })
      }) %>%
        purrr::keep(~length(.) > 0) %>%
        unique()

      org_names <- purrr::map(orgs_list, ~purrr::map_chr(., ~ .$login)) %>% unlist()
      org_n <- length(org_names)

      cli::cli_alert_success(cli::col_green(
        "Pulled {org_n} organizations."))

      return(org_names)
    },

    #' @description Method to pull repositories' issues.
    #' @param repos_list A list of repositories.
    #' @return A list of repositories.
    pull_repos_issues = function(repos_list) {
      repos_list <- purrr::map(repos_list, function(repo) {
        issues <- get_response(
          endpoint = paste0(self$rest_api_url, "/repos/", repo$full_name, "/issues"),
          token = private$token
        )

        issues_stats <- list()
        issues_stats[["issues"]] <- length(issues)
        issues_stats[["issues_open"]] <- length(purrr::keep(issues, ~ .$state == "open"))
        issues_stats[["issues_closed"]] <- length(purrr::keep(issues, ~ .$state == "closed"))

        return(issues_stats)
      }) %>%
        purrr::map2(repos_list, function(issue, repository) {
          purrr::list_modify(repository,
            issues = issue$issues,
            issues_open = issue$issues_open,
            issues_closed = issue$issues_closed
          )
        })

      repos_list
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
          "forks" = x$forks_count,
          "stars" = x$stargazers_count,
          "contributors" = paste0(x$contributors, collapse = ","),
          "issues" = x$issues,
          "issues_open" = x$issues_open,
          "issues_closed" = x$issues_closed,
          "description" = x$description
        )
      })

      repos_list
    },

    #' @description Search code by phrase
    #' @param phrase A phrase to look for in
    #'   codelines.
    #' @param org A character, an organization of repositories.
    #' @param language A character specifying language used in repositories.
    #' @param byte_max According to GitHub
    #'   documentation only files smaller than 384 KB are searchable. See
    #'   \link{https://docs.github.com/en/rest/search?apiVersion=2022-11-28#search-code}
    #'
    #' @return A list of repositories.
    search_by_keyword = function(phrase,
                                 org,
                                 language,
                                 byte_max = "384000") {
      search_endpoint <- if (!is.null(language)) {
        paste0(self$rest_api_url, "/search/code?q='", phrase, "'+user:", org, "+language:", language)
      } else {
        paste0(self$rest_api_url, "/search/code?q='", phrase, "'+user:", org)
      }

      total_n <- get_response(search_endpoint,
        token = private$token
      )[["total_count"]]

      if (length(total_n) > 0) {
        repos_list <- private$search_response(
          search_endpoint = search_endpoint,
          total_n = total_n,
          byte_max = byte_max
        )
        repos_list <- purrr::map_chr(repos_list, ~ as.character(.$repository$id)) %>%
          unique() %>%
          private$find_by_id(objects = "repositories")
      } else {
        repos_list <- list()
      }

      return(repos_list)
    },

    #' @description GitHub private method to pull
    #'   commits from repo with REST API.
    #' @param org A character, an owner of repository.
    #' @param date_from A starting date to look commits for.
    #' @param date_until An end date to look commits for.
    #' @return A list of commits.
    pull_commits_from_org = function(org,
                                     date_from,
                                     date_until = Sys.Date()) {
      repos_list <- private$pull_repos_from_org(
        org = org
      )

      enterprise_public <- if (self$enterprise) {
        "Enterprise"
      } else {
        "Public"
      }

      repos_names <- purrr::map_chr(repos_list, ~ .$full_name)

      pb <- progress::progress_bar$new(
        format = paste0("GitHub ", enterprise_public, " (", org, "). Checking for commits since ", date_from, " in ", length(repos_names), " repos. [:bar] repo: :current/:total"),
        total = length(repos_names)
      )

      commits_list <- purrr::map(repos_names, function(x) {
        pb$tick()
        tryCatch(
          {
            get_response(
              endpoint = paste0(
                self$rest_api_url,
                "/repos/",
                x,
                "/commits?since=",
                date_to_gts(date_from),
                "&until=",
                date_to_gts(date_until)
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
      commits_list <- purrr::imap(commits_list, function(repo, repo_name) {
        pb$tick()
        commit_stats <- purrr::map_chr(repo, ~ as.character(.$id)) %>%
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
      return(commits_list)
    },

    #' @description A wrapper for proper pagination of GitHub search REST API
    #' @param search_endpoint A character, a search endpoint
    #' @param total_n Number of results
    #' @param byte_max Max byte size
    #' @return A list
    search_response = function(search_endpoint,
                               total_n,
                               byte_max) {
      if (total_n > 0 & total_n < 100) {
        resp_list <- get_response(paste0(search_endpoint, "+size:0..", byte_max, "&page=1&per_page=100"),
                                  token = private$token
        )[["items"]]

        resp_list
      } else if (total_n >= 100 & total_n < 1e3) {
        resp_list <- list()

        for (page in 1:(total_n %/% 100)) {
          resp_list <- get_response(paste0(search_endpoint, "+size:0..", byte_max, "&page=", page, "&per_page=100"),
                                    token = private$token
          )[["items"]] %>%
            append(resp_list, .)
        }

        resp_list
      } else if (total_n >= 1e3) {
        resp_list <- list()
        index <- c(0, 50)

        pb <- progress::progress_bar$new(
          format = "GitHub search limit (1000 results) exceeded. Results will be divided. :elapsedfull"
        )

        while (index[2] < as.numeric(byte_max)) {
          size_formula <- paste0("+size:", as.character(index[1]), "..", as.character(index[2]))

          pb$tick(0)

          n_count <- tryCatch(
            {
              get_response(paste0(search_endpoint, size_formula),
                           token = private$token
              )[["total_count"]]
            },
            error = function(e) {
              NULL
            }
          )

          if (is.null(n_count)) {
            NULL
          } else if ((n_count - 1) %/% 100 > 0) {
            for (page in (1:(n_count %/% 100) + 1)) {
              resp_list <- get_response(paste0(search_endpoint, size_formula, "&page=", page, "&per_page=100"),
                                        token = private$token
              )[["items"]] %>% append(resp_list, .)
            }
          } else if ((n_count - 1) %/% 100 == 0) {
            resp_list <- get_response(paste0(search_endpoint, size_formula, "&page=1&per_page=100"),
                                      token = private$token
            )[["items"]] %>%
              append(resp_list, .)
          }

          index[1] <- index[2]

          if (index[2] < 1e3) {
            index[2] <- index[2] + 50
          }
          if (index[2] >= 1e3 && index[2] < 1e4) {
            index[2] <- index[2] + 100
          }
          if (index[2] >= 1e4 && index[2] < 1e5) {
            index[2] <- index[2] + 1000
          }
          if (index[2] >= 1e5 && index[2] < 1e6) {
            index[2] <- index[2] + 10000
          }
        }

        resp_list
      }
    },

    prepare_commits_table_gql = function(repos_list_with_commits) {
      commits_table <- purrr::imap(repos_list_with_commits, function(repo, repo_name) {
        commits_row <- purrr::map_dfr(repo, function(commit) {
          commit$node$author <- commit$node$author$name
          commit$node
        })
        commits_row$repository <- repo_name
        commits_row
      }) %>%
        purrr::discard(~length(.) == 1) %>%
        rbindlist() %>%
        dplyr::rename(changed_files = changedFilesIfAvailable)
    }
  )
)
