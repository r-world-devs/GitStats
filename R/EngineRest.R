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
                        token = private$token) {
      resp <- private$perform_request(endpoint, token)
      if (!is.null(resp)) {
        result <- resp %>% httr2::resp_body_json(check_type = FALSE)
      } else {
        result <- list()
      }
      return(result)
    },

    # Prepare table for repositories content
    prepare_repos_table = function(repos_list, output = "table_full", verbose = TRUE) {
      repos_dt <- purrr::map(repos_list, function(repo) {
        repo <- purrr::map(repo, function(attr) {
          attr <- attr %||% ""
        })
        data.frame(repo)
      }) %>%
        purrr::list_rbind()
      if (verbose) {
        cli::cli_alert_info("Preparing repositories table...")
      }
      if (length(repos_dt) > 0) {
        if (output == "table_full") {
          repos_dt <- dplyr::mutate(
            repos_dt,
            repo_id = as.character(repo_id),
            created_at = as.POSIXct(created_at),
            last_activity_at = as.POSIXct(last_activity_at),
            forks = as.integer(forks),
            issues_open = as.integer(issues_open),
            issues_closed = as.integer(issues_closed)
          )
        }
        if (output == "table_min") {
          repos_dt <- dplyr::mutate(
            repos_dt,
            repo_id = as.character(repo_id),
            created_at = as.POSIXct(created_at)
          )
        }
      }
      return(repos_dt)
    }

  ),
  private = list(

    # Paginate contributors and parse response into character vector
    get_contributors_from_repo = function(contributors_endpoint, user_name) {
      contributors_response <- private$paginate_results(contributors_endpoint)
      contributors_vec <- contributors_response %>%
        purrr::map_chr(~ eval(user_name)) %>%
        paste0(collapse = ", ")
      return(contributors_vec)
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

    # @description A wrapper for httr2 functions to prepare get request to REST API endpoint.
    # @param endpoint An API endpoint.
    # @param token An API token.
    # @returns A request.
    perform_request = function(endpoint, token) {
      resp <- NULL
      resp <- httr2::request(endpoint) %>%
        httr2::req_headers("Authorization" = paste0("Bearer ", token)) %>%
        httr2::req_error(is_error = function(resp) httr2::resp_status(resp) == 404) %>%
        httr2::req_perform()
      if (!private$scan_all) {
        if (resp$status == 401) {
          message("HTTP 401 Unauthorized.")
        }
      }
      if (resp$status %in% c(400, 500, 403)) {
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
  )
)
