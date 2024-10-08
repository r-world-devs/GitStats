#' @noRd
#' @description A class for methods wrapping GitHub's REST API responses.
EngineRestGitHub <- R6::R6Class(
  classname = "EngineRestGitHub",
  inherit = EngineRest,
  public = list(

    # Pull repositories with files
    get_files = function(files) {
      files_list <- list()
      for (filename in files) {
        search_file_endpoint <- paste0(private$endpoints[["search"]], "filename:", filename)
        total_n <- self$response(search_file_endpoint)[["total_count"]]
        if (length(total_n) > 0) {
          search_result <- private$search_response(
            search_endpoint = search_file_endpoint,
            total_n = total_n
          ) %>%
            purrr::keep(~ .$path == filename)
          files_content <- private$get_files_content(search_result, filename)
          files_list <- append(files_list, files_content)
        }
      }
      return(files_list)
    },

    # Pulling repositories where code appears
    get_repos_by_code = function(code,
                                 org        = NULL,
                                 filename   = NULL,
                                 in_path    = FALSE,
                                 raw_output = FALSE,
                                 verbose    = TRUE,
                                 progress   = TRUE) {
      user_query <- if (!is.null(org)) {
        paste0('+user:', org)
      } else {
        ''
      }
      query <- if (!in_path) {
        paste0('"', code, '"', user_query)
      } else {
        paste0('"', code, '"+in:path', user_query)
      }
      if (!is.null(filename)) {
        query <- paste0(query, '+in:file+filename:', filename)
      }
      search_endpoint <- paste0(private$endpoints[["search"]], query)
      if (verbose) cli::cli_alert_info("Searching for code [{code}]...")
      total_n <- self$response(search_endpoint)[["total_count"]]
      if (length(total_n) > 0) {
        search_result <- private$search_response(
          search_endpoint = search_endpoint,
          total_n = total_n
        )
        if (!raw_output) {
          search_output <- private$map_search_into_repos(
            search_response = search_result,
            progress        = progress
          )
        } else {
          search_output <- search_result
        }
      } else {
        search_output <- list()
      }
      return(search_output)
    },

    #' Pull all repositories URLS from organization
    get_repos_urls = function(type, org) {
      repos_urls <- self$response(
        endpoint = paste0(private$endpoints[["organizations"]], org, "/repos")
      ) %>%
        purrr::map_vec(function(repository) {
          if (type == "api") {
            repository$url
          } else {
            repository$html_url
          }
        })
      return(repos_urls)
    },

    #' A method to add information on open and closed issues of a repository.
    get_repos_issues = function(repos_table, progress) {
      if (nrow(repos_table) > 0) {
        repos_iterator <- paste0(repos_table$organization, "/", repos_table$repo_name)
        issues <- purrr::map_dfr(repos_iterator, function(repo_path) {
          issues_endpoint <- paste0(private$endpoints[["repositories"]], repo_path, "/issues")
          issues <- self$response(
            endpoint = issues_endpoint
          )
          data.frame(
            "open" = length(purrr::keep(issues, ~ .$state == "open")),
            "closed" = length(purrr::keep(issues, ~ .$state == "closed"))
          )
        }, .progress = if (progress) {
          "Pulling repositories issues..."
        } else {
          FALSE
        })
        repos_table$issues_open <- issues$open
        repos_table$issues_closed <- issues$closed
      }
      return(repos_table)
    },

    #' Add information on repository contributors.
    get_repos_contributors = function(repos_table, progress) {
      if (nrow(repos_table) > 0) {
        repo_iterator <- paste0(repos_table$organization, "/", repos_table$repo_name)
        user_name <- rlang::expr(.$login)
        repos_table$contributors <- purrr::map_chr(repo_iterator, function(repos_id) {
          tryCatch({
            contributors_endpoint <- paste0(private$endpoints[["repositories"]], repos_id, "/contributors")
            contributors_vec <- private$pull_contributors_from_repo(
              contributors_endpoint = contributors_endpoint,
              user_name = user_name
            )
            return(contributors_vec)
          },
          error = function(e) {
            NA
          })
        }, .progress = if (progress) {
          "[GitHost:GitHub] Pulling contributors..."
        } else {
          FALSE
        })
      }
      return(repos_table)
    }
  ),
  private = list(

    # List of endpoints
    endpoints = list(
      search = NULL,
      organizations = NULL,
      repositories = NULL
    ),

    # Set endpoints for the API
    set_endpoints = function() {
      private$endpoints[["search"]] <- paste0(
        self$rest_api_url,
        '/search/code?q='
      )
      private$endpoints[["organizations"]] <- paste0(
        self$rest_api_url,
        "/orgs/"
      )
      private$endpoints[["repositories"]] <- paste0(
        self$rest_api_url,
        "/repos/"
      )
    },

    # A wrapper for proper pagination of GitHub search REST API
    # @param search_endpoint A character, a search endpoint
    # @param total_n Number of results
    # @param byte_max According to GitHub documentation only files smaller than
    #   384 KB are searchable. See
    #   \link{https://docs.github.com/en/rest/search?apiVersion=2022-11-28#search-code}
    search_response = function(search_endpoint,
                               total_n,
                               byte_max = "384000") {
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
              resp_list <- self$response(paste0(search_endpoint,
                                                size_formula,
                                                "&page=",
                                                page,
                                                "&per_page=100"))[["items"]] |>
                append(resp_list, .)
            }
          } else if ((n_count - 1) %/% 100 == 0) {
            resp_list <- self$response(paste0(search_endpoint, size_formula, "&page=1&per_page=100"))[["items"]] |>
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

    # Parse search response into repositories output
    map_search_into_repos = function(search_response, progress) {
      repos_ids <- purrr::map_chr(search_response, ~ as.character(.$repository$id)) %>%
        unique()
      repos_list <- purrr::map(repos_ids, function(repo_id) {
        content <- self$response(
          endpoint = paste0(self$rest_api_url, "/repositories/", repo_id)
        )
      }, .progress = if (progress) {
        "Parsing search response into respositories output..."
      } else {
        FALSE
      })
      repos_list
    },

    # Get files content
    get_files_content = function(search_result, filename) {
      purrr::map(search_result, ~ self$response(.$url),
                 .progress = glue::glue("Adding file [{filename}] info...")) %>%
        unique()
    }
  )
)
