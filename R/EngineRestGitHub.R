#' @noRd
#' @title A EngineRestGitHub class
#' @description A class for methods wrapping GitHub's REST API responses.
EngineRestGitHub <- R6::R6Class("EngineRestGitHub",
  inherit = EngineRest,
  public = list(

    #' @description Method to get repositories with phrase in code blobs.
    #' @param org An organization
    #' @param settings A list of  `GitStats` settings.
    #' @return Table of repositories.
    pull_repos = function(org,
                          settings) {
      if (settings$search_param == "phrase") {
        if (!private$scan_all && settings$verbose) {
          cli::cli_alert_info("[GitHub][Engine:{cli::col_green('REST')}][phrase:{settings$phrase}][org:{org}] Searching repositories...")
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
      } else {
        repos_table <- NULL
      }
      return(repos_table)
    },

    #' @description An supportive method to pull repos by org in case GraphQL
    #'   Engine breaks.
    #' @param org An organization.
    #' @param settings A list of  `GitStats` settings.
    #' @return A table of repositories.
    pull_repos_supportive = function(org,
                                     settings) {
      repos_table <- NULL
      if (settings$search_param %in% c("org")) {
        if (!private$scan_all) {
          if (settigs$verbose) {
            cli::cli_alert_info("[GitHub][Engine:{cli::col_green('REST')}][org:{org}] Pulling repositories...")
          }
        }
        repos_endpoint <- paste0(self$rest_api_url, "/orgs/", org, "/repos")
        repos_table <- private$paginate_results(
          repos_endpoint = repos_endpoint
        ) %>%
          private$tailor_repos_info() %>%
          private$prepare_repos_table() %>%
          private$pull_repos_issues()
      }
      return(repos_table)
    },

    #' @description Method to get commits.
    #' @details This method is empty as this class does not support pulling
    #'   commits - it is done for GitHub via GraphQL. Still the method must
    #'   exist as it is called from the GitHost wrapper above.
    #' @param org An organization.
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
      NULL
    },

    #' @description A method to add information on repository contributors.
    #' @param repos_table A table of repositories.
    #' @param settings GitStats settings.
    #' @return A table of repositories with added information on contributors.
    pull_repos_contributors = function(repos_table, settings) {
      if (nrow(repos_table) > 0) {
        if (!private$scan_all && settings$verbose) {
          cli::cli_alert_info(
            "[GitHub][Engine:{cli::col_green('REST')}][org:{unique(repos_table$organization)}] Pulling contributors..."
          )
        }
        repo_iterator <- paste0(repos_table$organization, "/", repos_table$repo_name)
        user_name <- rlang::expr(.$login)
        repos_table$contributors <- purrr::map_chr(repo_iterator, function(repos_id) {
          tryCatch({
              contributors_endpoint <- paste0(self$rest_api_url, "/repos/", repos_id, "/contributors")
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
          self$response(endpoint = self$rest_api_url,
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

    # @description Search code by phrase
    # @param phrase A phrase to look for in
    #   codelines.
    # @param org A character, an organization of repositories.
    # @param language A character specifying language used in repositories.
    # @param byte_max According to GitHub
    #   documentation only files smaller than 384 KB are searchable. See
    #   \link{https://docs.github.com/en/rest/search?apiVersion=2022-11-28#search-code}
    #
    # @return A list of repositories.
    search_repos_by_phrase = function(phrase,
                                      org,
                                      files,
                                      language,
                                      byte_max = "384000") {
      user_query <- if (!private$scan_all) {
        paste0('+user:', org)
      } else {
        ''
      }
      query <- paste0('"', phrase, '"', user_query)
      if (language != "All") {
        query <- paste0(query, '+language:', language)
      }
      search_endpoint <- paste0(self$rest_api_url, '/search/code?q=', query)
      total_n <- self$response(search_endpoint)[["total_count"]]
      if (length(total_n) > 0) {
        repos_list <- private$search_response(
          search_endpoint = search_endpoint,
          total_n = total_n,
          byte_max = byte_max
        )
        if (!is.null(files)) {
          repos_list <- purrr::keep(repos_list, function(repository) {
            any(repository$path %in% files)
          })
        }
        repos_list <- private$find_repos_by_id(repos_list)
      } else {
        repos_list <- list()
      }
      return(repos_list)
    },

    # @description A wrapper for proper pagination of GitHub search REST API
    # @param search_endpoint A character, a search endpoint
    # @param total_n Number of results
    # @param byte_max Max byte size
    # @return A list
    search_response = function(search_endpoint,
                               total_n,
                               byte_max) {
      if (total_n >= 0 & total_n < 1e3) {
        resp_list <- list()
        for (page in 1:(total_n %/% 100)) {
          resp_list <- self$response(
            paste0(search_endpoint, "+size:0..", byte_max, "&page=", page, "&per_page=100")
          )[["items"]] %>%
            append(resp_list, .)
        }
        resp_list
      } else if (total_n >= 1e3) {
        resp_list <- list()
        index <- c(0, 50)
        spinner <- cli::make_spinner(
          which = "timeTravel",
          template = cli::col_grey(
            "GitHub search limit (1000 results) exceeded. Results will be divided. {spin}"
          )
        )
        while (index[2] < as.numeric(byte_max)) {
          size_formula <- paste0("+size:", as.character(index[1]), "..", as.character(index[2]))
          spinner$spin()
          n_count <- tryCatch(
            {
              self$response(paste0(search_endpoint, size_formula))[["total_count"]]
            },
            error = function(e) {
              NULL
            }
          )
          if (is.null(n_count)) {
            NULL
          } else if ((n_count - 1) %/% 100 > 0) {
            for (page in (1:(n_count %/% 100) + 1)) {
              resp_list <- self$response(paste0(search_endpoint, size_formula, "&page=", page, "&per_page=100"))[["items"]] %>% append(resp_list, .)
            }
          } else if ((n_count - 1) %/% 100 == 0) {
            resp_list <- self$response(paste0(search_endpoint, size_formula, "&page=1&per_page=100"))[["items"]] %>%
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
        spinner$finish()
        resp_list
      }
    },

    # @description A helper to retrieve only important info on repos
    # @param repos_list A list, a formatted content of response returned by GET API request
    # @return A list of repos with selected information
    tailor_repos_info = function(repos_list) {
      repos_list <- purrr::map(repos_list, function(repo) {
        list(
          "repo_id" = repo$id,
          "repo_name" = repo$name,
          "default_branch" = repo$default_branch,
          "stars" = repo$stargazers_count,
          "forks" = repo$forks_count,
          "created_at" = gts_to_posixt(repo$created_at),
          "last_activity_at" = if (!is.null(repo$pushed_at)) gts_to_posixt(repo$pushed_at) else gts_to_posixt(repo$created_at),
          "languages" = repo$language,
          "issues_open" = repo$issues_open,
          "issues_closed" = repo$issues_closed,
          "organization" = repo$owner$login,
          "repo_url" = repo$html_url
        )
      })
      repos_list
    },

    # @description A method to add information on open and closed issues of a repository.
    # @param repos_table A table of repositories.
    # @return A table of repositories with added information on issues.
    pull_repos_issues = function(repos_table) {
      if (nrow(repos_table) > 0) {
        repos_iterator <- paste0(repos_table$organization, "/", repos_table$repo_name)
        issues <- purrr::map_dfr(repos_iterator, function(repo_path) {
          issues_endpoint <- paste0(self$rest_api_url, "/repos/", repo_path, "/issues")

          issues <- self$response(
            endpoint = issues_endpoint
          )

          data.frame(
            "open" = length(purrr::keep(issues, ~ .$state == "open")),
            "closed" = length(purrr::keep(issues, ~ .$state == "closed"))
          )
        })
        repos_table$issues_open <- issues$open
        repos_table$issues_closed <- issues$closed
      }
      return(repos_table)
    },

    # @description Perform get request to find projects by ids.
    # @param repos_list A list of repositories - search response.
    # @return A list of repositories.
    find_repos_by_id = function(repos_list) {
      ids <- purrr::map_chr(repos_list, ~ as.character(.$repository$id)) %>%
        unique()
      repos_list <- purrr::map(ids, function(x) {
        content <- self$response(
          endpoint = paste0(self$rest_api_url, "/repositories/", x)
        )
      })
      repos_list
    }
  )
)
