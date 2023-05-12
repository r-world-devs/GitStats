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
    #' @return A `Rest` object.
    initialize = function(rest_api_url = NA,
                          token = NA) {
      private$token <- private$check_token(token)
      self$rest_api_url <- rest_api_url
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

    # @description Check whether the token exists.
    # @param token A token.
    # @return A token.
    check_token = function(token) {
      if (nchar(token) == 0) {
        cli::cli_abort(c(
          "i" = "No token provided.",
          "x" = "Host will not be passed to `GitStats` object."
        ))
      }
      return(invisible(token))
    },

    # @description A helper to prepare table for repositories content
    # @param repos_list A repository list.
    # @return A data.frame.
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
          id = as.character(id),
          created_at = as.POSIXct(created_at),
          last_activity_at = difftime(Sys.time(), as.POSIXct(last_activity_at),
            units = "days"
          ) %>% round(2),
          forks = as.integer(forks),
          issues_open = as.integer(issues_open),
          issues_closed = as.integer(issues_closed),
          api_url = self$rest_api_url
        )
      }
      return(repos_dt)
    },

    # @description A wrapper for httr2 functions to prepare get request to REST API endpoint.
    # @param endpoint An API endpoint.
    # @param token An API token.
    # @returns A request.
    perform_request = function(endpoint, token) {
      tryCatch(
        {
          resp <- private$build_request(endpoint, token) %>%
            httr2::req_perform()
        },
        error = function(e) {
          if (!is.null(e$status)) {
            if (e$status == 400) {
              message("HTTP 400 Bad Request.")
            } else if (e$status == 401) {
              message("HTTP 401 Unauthorized.")
            } else if (e$status == 403) {
              message("HTTP 403 API limit reached.")
            } else if (e$status == 404) {
              message("HTTP 404 No such address")
            }
          } else if (grepl("Could not resolve host", e)) {
            cli::cli_abort(c(
              "Could not resolve host {endpoint}",
              "x" = "'GitStats' object will not be created."
            ))
          }
          resp <<- NULL
        }
      )
      return(resp)
    },

    # @description A wrapper for httr2 functions to prepare get request to REST API endpoint.
    # @param endpoint An API endpoint.
    # @param token An API token.
    # @returns A request.
    build_request = function(endpoint, token) {
      httr2::request(endpoint) %>%
        httr2::req_headers("Authorization" = paste0("Bearer ", token)) %>%
        httr2::req_error(body = private$resp_error_body) %>%
        httr2::req_retry(
          is_transient = private$resp_is_transient,
          after = private$req_after
        )
    },

    # @description Handler for rate-limit error (403 on GitHub).
    resp_is_transient = function(resp) {
      httr2::resp_status(resp) == 403 &&
        httr2::resp_header(resp, "X-RateLimit-Remaining") == "0"
    },

    # @description Handler for rate-limit error (403 on GitHub).
    req_after = function(resp) {
      time <- as.numeric(httr2::resp_header(resp, "X-RateLimit-Reset"))
      time - unclass(Sys.time())
    },

    # @description Handler for rate-limit error (403 on GitHub).
    resp_error_body = function(resp) {
      body <- httr2::resp_body_json(resp)

      message <- body$message
      if (!is.null(body$documentation_url)) {
        message <- c(message, paste0("See docs at <", body$documentation_url, ">"))
      }
      message
    }
  )
)
