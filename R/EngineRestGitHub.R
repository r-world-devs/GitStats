EngineRestGitHub <- R6::R6Class("EngineRestGitHub",

  inherit = EngineRest,

  public = list(
    #' @description A method to add information on repository contributors.
    #' @param repos_table A table of repositories.
    #' @return A table of repositories with added information on contributors.
    get_repos_contributors = function(repos_table) {
      if (nrow(repos_table) > 0) {
        repo_iterator <- paste0(repos_table$organization, "/", repos_table$name)
        user_name <- rlang::expr(.$login)

        repos_table$contributors <- purrr::map(repo_iterator, function(repos_id) {
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
    },

    #' @description A method to add information on repository contributors.
    #' @param repos_table A table of repositories.
    #' @return A table of repositories with added information on contributors.
    get_repos_issues = function(repos_table) {
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
    }
  ),

  private = list(

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
    search_repos_by_phrase = function(phrase,
                                      org,
                                      language,
                                      byte_max = "384000") {
      cli::cli_alert_info("[GitHub][{org}][Engine:{cli::col_green('REST')}] Searching repos...")
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
        repos_list <- purrr::map_chr(repos_list, ~ as.character(.$repository$id)) %>%
          unique() %>%
          private$find_by_id(objects = "repositories")
      } else {
        repos_list <- list()
      }

      return(repos_list)
    },

    #' @description A wrapper for proper pagination of GitHub search REST API
    #' @param search_endpoint A character, a search endpoint
    #' @param total_n Number of results
    #' @param byte_max Max byte size
    #' @return A list
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
              self$response(paste0(search_endpoint, size_formula)
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
              resp_list <- self$response(paste0(search_endpoint, size_formula, "&page=", page, "&per_page=100")
              )[["items"]] %>% append(resp_list, .)
            }
          } else if ((n_count - 1) %/% 100 == 0) {
            resp_list <- self$response(paste0(search_endpoint, size_formula, "&page=1&per_page=100")
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

    #' @description A helper to retrieve only important info on repos
    #' @param repos_list A list, a formatted content of response returned by GET API request
    #' @return A list of repos with selected information
    tailor_repos_info = function(repos_list) {
      repos_list <- purrr::map(repos_list, function(x) {
        list(
          "id" = x$id,
          "name" = x$name,
          "stars" = x$stargazers_count,
          "forks" = x$forks_count,
          "created_at" = x$created_at,
          "last_push" = x$pushed_at,
          "last_activity_at" = x$updated_at,
          "languages" = x$language,
          "issues_open" = x$issues_open,
          "issues_closed" = x$issues_closed,
          "contributors" = paste0(x$contributors, collapse = ","),
          "repo_url" = x$url,
          "organization" = x$owner$login
        )
      })

      repos_list
    }
  )
)
