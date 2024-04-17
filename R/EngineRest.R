#' @noRd
#' @importFrom httr2 request req_headers req_perform resp_body_json
#' @importFrom cli cli_abort col_green
#' @importFrom rlang %||%
#'
#' @title A EngineRest class
#' @description A superclass for methods wrapping Rest API responses.
EngineRest <- R6::R6Class("EngineRest",
  public = list(

    #' @field rest_api_url A character, url of Rest API.
    rest_api_url = NULL,

    #' @description Create a new `Rest` object
    #' @param rest_api_url A character, url of Rest API.
    #' @param token A token.
    #' @param scan_all A boolean.
    #' @return A `Rest` object.
    initialize = function(rest_api_url = NA,
                          token = NA,
                          scan_all = FALSE) {
      private$token <- token
      self$rest_api_url <- rest_api_url
      private$scan_all <- scan_all
      private$set_endpoints()
    },

    #' @description A wrapper for httr2 functions to perform get request to REST API endpoints.
    #' @param endpoint An API endpoint.
    #' @param token A token.
    #' @return A content of response formatted to list.
    response = function(endpoint,
                        token = private$token) {
      resp <- private$perform_request(endpoint, token)
      if (!is.null(resp)) {
        result <- resp %>% httr2::resp_body_json(check_type = FALSE)
      } else {
        result <- list()
      }
      return(result)
    }

  ),
  private = list(

    # @field token A token authorizing access to API.
    token = NULL,

    # @field A boolean.
    scan_all = FALSE,

    # Paginate contributors and parse response into character vector
    pull_contributors_from_repo = function(contributors_endpoint, user_name) {
      contributors_response <- private$paginate_results(contributors_endpoint)
      contributors_vec <- contributors_response %>%
        purrr::map_chr(~ eval(user_name)) %>%
        paste0(collapse = ", ")
      return(contributors_vec)
    },

    # Filtering handler if files are set for scanning scope
    limit_search_to_files = function(repos_list, files) {
      if (!is.null(files)) {
        repos_list <- purrr::keep(repos_list, function(repository) {
          any(repository$path %in% files)
        })
      }
      return(repos_list)
    },

    # Helper
    paginate_results = function(endpoint, joining_sign = "?") {
      full_response <- list()
      page <- 1
      repeat {
        endpoint_with_pagination <- paste0(endpoint, joining_sign, "per_page=100&page=", page)
        response_page <- self$response(
          endpoint = endpoint_with_pagination
        )
        if (length(response_page) > 0) {
          full_response <- append(full_response, response_page)
          page <- page + 1
        } else {
          break
        }
      }
      return(full_response)
    },

    # @description A helper to prepare table for repositories content
    # @param repos_list A repository list.
    # @return A data.frame.
    prepare_repos_table = function(repos_list, settings) {
      repos_dt <- purrr::map(repos_list, function(repo) {
        repo <- purrr::map(repo, function(attr) {
          attr <- attr %||% ""
        })
        data.frame(repo)
      }) %>%
        purrr::list_rbind()
      if (settings$verbose) {
        cli::cli_alert_info("Preparing repositories table...")
      }
      if (length(repos_dt) > 0) {
        repos_dt <- dplyr::mutate(repos_dt,
          repo_id = as.character(repo_id),
          created_at = as.POSIXct(created_at),
          last_activity_at = as.POSIXct(last_activity_at),
          forks = as.integer(forks),
          issues_open = as.integer(issues_open),
          issues_closed = as.integer(issues_closed)
        )
      }
      return(repos_dt)
    },

    # @description A wrapper for httr2 functions to prepare get request to REST API endpoint.
    # @param endpoint An API endpoint.
    # @param token An API token.
    # @returns A request.
    perform_request = function(endpoint, token) {
      resp <- NULL
      tryCatch({
          resp <- httr2::request(endpoint) %>%
            httr2::req_headers("Authorization" = paste0("Bearer ", token)) %>%
            httr2::req_error(is_error = function(resp) FALSE) %>%
            httr2::req_perform()
          if (!private$scan_all) {
            if (resp$status == 401) {
              message("HTTP 401 Unauthorized.")
            }
            if (resp$status == 404) {
              message("HTTP 404 No such address")
            }
          }
          if (resp$status %in% c(400, 403)) {
            resp <- httr2::request(endpoint) %>%
              httr2::req_headers("Authorization" = paste0("Bearer ", token)) %>%
              httr2::req_retry(
                is_transient = ~ httr2::resp_status(.x) %in% c(400, 403),
                max_seconds = 60
              ) %>%
              httr2::req_perform()
          }
        },
        error = function(e) {
          cli::cli_alert_danger(e$message)
          if (!is.null(e$parent$message)) {
            cli::cli_abort(c(
              e$parent$message,
              "x" = "'GitStats' object will not be created."
            ))
          }
        }
      )
      return(resp)
    }
  )
)
