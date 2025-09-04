#' @noRd
#' @description A superclass for methods wrapping Rest API responses.
EngineRest <- R6::R6Class("EngineRest",
  inherit = Engine,

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
      private$engine <- "rest"
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
                        token = private$token,
                        verbose) {
      resp <- self$perform_request(
        endpoint = endpoint,
        token = token,
        verbose = verbose
      )
      if (!is.null(resp)) {
        result <- resp %>% httr2::resp_body_json(check_type = FALSE)
      } else {
        result <- list()
      }
      return(result)
    },

    # @description A wrapper for httr2 functions to prepare get request to REST API endpoint.
    # @param endpoint An API endpoint.
    # @param token An API token.
    # @returns A request.
    perform_request = function(endpoint, token, verbose) {
      resp <- NULL
      resp <- httr2::request(endpoint) %>%
        httr2::req_headers("Authorization" = paste0("Bearer ", token)) %>%
        httr2::req_error(is_error = function(resp) FALSE) %>%
        httr2::req_perform()
      if (resp$status_code == 401 && verbose) {
        cli::cli_alert_danger("HTTP 401 Unauthorized.")
      }
      if (resp$status_code == 404 && verbose) {
        cli::cli_alert_danger("HTTP 404 Not Found.")
      }
      if (resp$status_code %in% c(400, 500, 403)) {
        resp <- httr2::request(endpoint) %>%
          httr2::req_headers("Authorization" = paste0("Bearer ", token)) %>%
          httr2::req_retry(
            is_transient = ~ httr2::resp_status(.x) %in% c(400, 500, 403),
            max_seconds = 60
          ) %>%
          httr2::req_perform()
      }
      return(resp)
    }

  ),
  private = list(

    # Paginate contributors and parse response into character vector
    get_contributors_from_repo = function(contributors_endpoint, user_name, verbose) {
      contributors_response <- private$paginate_results(
        endpoint = contributors_endpoint,
        verbose = verbose
      )
      contributors_vec <- contributors_response %>%
        purrr::map_chr(~ eval(user_name)) %>%
        paste0(collapse = ", ")
      return(contributors_vec)
    },

    # Helper
    paginate_results = function(endpoint, joining_sign = "?", verbose = TRUE) {
      full_response <- list()
      page <- 1
      repeat {
        endpoint_with_pagination <- paste0(endpoint, joining_sign, "per_page=100&page=", page)
        response_page <- self$response(
          endpoint = endpoint_with_pagination,
          verbose = verbose
        )
        if (length(response_page) > 0) {
          full_response <- append(full_response, response_page)
          page <- page + 1
        } else {
          break
        }
      }
      return(full_response)
    }
  )
)
