#' @title A EngineRestGitHub class
#' @description A class for methods wrapping GitHub's REST API responses.
EngineRestGitHub <- R6::R6Class("EngineRestGitHub",
  inherit = EngineRest,
  public = list(

    #' @description Create new `EngineRestGitHub` object.
    #' @param rest_api_url A REST API url.
    #' @param token A token.
    initialize = function(rest_api_url,
                          token) {
      super$initialize(
        rest_api_url = rest_api_url,
        token = token
      )
    },

    #' @description Check if an organization exists
    #' @param orgs A character vector of organizations
    #' @return orgs or NULL.
    check_organizations = function(orgs) {
      orgs <- purrr::map(orgs, function(org) {
        org_endpoint <- "/orgs/"
        withCallingHandlers(
          {
            self$response(endpoint = paste0(self$rest_api_url, org_endpoint, org))
          },
          message = function(m) {
            if (grepl("404", m)) {
              cli::cli_alert_danger("Organization you provided does not exist. Check spelling in: {org}")
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

    #' @description Method to get repositories with phrase in code blobs.
    #' @param org An organization
    #' @param settings A list of  `GitStats` settings.
    #' @return Table of repositories.
    get_repos = function(org,
                         settings) {
      if (settings$search_param == "phrase") {
        cli::cli_alert_info("[GitHub][Engine:{cli::col_green('REST')}][phrase:{settings$phrase}][org:{org}] Searching repositories...")
        repos_table <- private$search_repos_by_phrase(
          org = org,
          phrase = settings$phrase,
          language = settings$language
        ) %>%
          private$tailor_repos_info() %>%
          private$prepare_repos_table() %>%
          private$add_repos_issues()
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
    get_repos_supportive = function(org,
                                    settings) {
      if (settings$search_param %in% c("org")) {
        cli::cli_alert_info("[GitHub][Engine:{cli::col_green('REST')}][org:{org}] Pulling repositories...")
        repos_table <- private$pull_repos_from_org(
          org = org
        ) %>%
          private$tailor_repos_info() %>%
          private$prepare_repos_table() %>%
          private$add_repos_issues()
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
    #' @return A table of commits.
    get_commits = function(org,
                           date_from,
                           date_until = Sys.date(),
                           settings) {
      NULL
    },

    #' @description A method to add information on repository contributors.
    #' @param repos_table A table of repositories.
    #' @return A table of repositories with added information on contributors.
    add_repos_contributors = function(repos_table) {
      if (nrow(repos_table) > 0) {
        cli::cli_alert_info("[GitHub][Engine:{cli::col_green('REST')}] Pulling contributors...")
        repo_iterator <- paste0(repos_table$organization, "/", repos_table$name)
        user_name <- rlang::expr(.$login)
        repos_table$contributors <- purrr::map_chr(repo_iterator, function(repos_id) {
          contributors_endpoint <- paste0(self$rest_api_url, "/repos/", repos_id, "/contributors")
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
    }
  ),
  private = list(

    # @description Iterator over pulling pages of repositories.
    # @param org A character, an owner of repositories.
    # @return A list of repositories from organization.
    pull_repos_from_org = function(org) {
      full_repos_list <- list()
      page <- 1
      repeat {
        repo_endpoint <- paste0(self$rest_api_url, "/orgs/", org, "/repos?per_page=100&page=", page)
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
      full_repos_list <- full_repos_list #%>%
        #private$pull_repos_languages()
      return(full_repos_list)
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
                                      language,
                                      byte_max = "384000") {
      search_endpoint <- if (!is.null(language)) {
        paste0(self$rest_api_url, "/search/code?q='", phrase, "'+user:", org, "+language:", language)
      } else {
        paste0(self$rest_api_url, "/search/code?q='", phrase, "'+user:", org)
      }

      total_n <- self$response(search_endpoint)[["total_count"]]

      if (length(total_n) > 0) {
        repos_list <- private$search_response(
          search_endpoint = search_endpoint,
          total_n = total_n,
          byte_max = byte_max
        )
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

        pb <- progress::progress_bar$new(
          format = "GitHub search limit (1000 results) exceeded. Results will be divided. :elapsedfull"
        )

        while (index[2] < as.numeric(byte_max)) {
          size_formula <- paste0("+size:", as.character(index[1]), "..", as.character(index[2]))

          pb$tick(0)

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

        resp_list
      }
    },

    # @description A helper to retrieve only important info on repos
    # @param repos_list A list, a formatted content of response returned by GET API request
    # @return A list of repos with selected information
    tailor_repos_info = function(repos_list) {
      repos_list <- purrr::map(repos_list, function(repo) {
        list(
          "id" = repo$id,
          "name" = repo$name,
          "stars" = repo$stargazers_count,
          "forks" = repo$forks_count,
          "created_at" = repo$created_at,
          "last_activity_at" = repo$pushed_at,
          "languages" = repo$language,
          "issues_open" = repo$issues_open,
          "issues_closed" = repo$issues_closed,
          "organization" = repo$owner$login,
          "repo_url" = repo$url
        )
      })

      repos_list
    },

    # @description A method to add information on repository contributors.
    # @param repos_table A table of repositories.
    # @return A table of repositories with added information on contributors.
    add_repos_issues = function(repos_table) {
      if (nrow(repos_table) > 0) {
        repos_iterator <- paste0(repos_table$organization, "/", repos_table$name)
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
