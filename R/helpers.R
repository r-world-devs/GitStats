#' @importFrom httr2 request req_headers req_perform resp_body_json
#'
#' @name get_response
#'
#' @description A wrapper for httr2 functions to perform get request to REST API endpoints.
#'
#' @param endpoint An API endpoint.
#' @param token An API token.
#'
#' @returns A content of response formatted to list.
#'
get_response <- function(endpoint, token) {
  tryCatch(
    {
      resp <- perform_request(endpoint, token)
      result <- resp %>% httr2::resp_body_json(check_type = FALSE)
    },
    error = function(e) {
      # if (e$status == 400) {
      #   message("HTTP 400 Bad Request.")
      # }
      if (!is.null(e$status)) {
        if (e$status == 403) {
          message("HTTP 403 API limit reached.")
        } else if (e$status == 404) {
          message("HTTP 404 No such address")
        }
        result <<- list()
      } else if (grepl("Could not resolve host", e)) {
        cli::cli_abort(c(
          "Could not resolve host {endpoint}",
          "x" = "'GitStats' object will not be created."
        ))
      }
    }
  )

  return(result)
}

perform_request <- function(endpoint, token) {
  resp <- build_request(endpoint, token) %>%
    httr2::req_perform()

  return(resp)
}

#' @description A wrapper for httr2 functions to prepare get request to REST API endpoint.
#'
#' @param endpoint An API endpoint.
#' @param token An API token.
#'
#' @returns A request.
build_request <- function(endpoint, token) {
  httr2::request(endpoint) %>%
    httr2::req_headers("Authorization" = paste0("Bearer ", token)) %>%
    httr2::req_error(body = resp_error_body) %>%
    httr2::req_retry(
      is_transient = resp_is_transient,
      after = req_after
    )
}

#' @description Handler for rate-limit error (403 on GitHub).
#' \link{}
resp_is_transient <- function(resp) {
  httr2::resp_status(resp) == 403 &&
    httr2::resp_header(resp, "X-RateLimit-Remaining") == "0"
}

#' @description Handler for rate-limit error (403 on GitHub).
#' \link{}
req_after <- function(resp) {
  time <- as.numeric(httr2::resp_header(resp, "X-RateLimit-Reset"))
  time - unclass(Sys.time())
}

#' @description Handler for rate-limit error (403 on GitHub).
#' \link{}
resp_error_body <- function(resp) {
  body <- httr2::resp_body_json(resp)

  message <- body$message
  if (!is.null(body$documentation_url)) {
    message <- c(message, paste0("See docs at <", body$documentation_url, ">"))
  }
  message
}

#' @description Wrapper of GraphQL API request and response.
#' @param api_url A url of GraphQL API.
#' @param gql_query A string with GraphQL query.
#' @param token a token.
#' @return A list.
gql_response <- function(api_url,
                         gql_query,
                         token) {

  request(paste0(api_url, "?")) %>%
    httr2::req_headers("Authorization" = paste0("Bearer ", token)) %>%
    httr2::req_body_json(list(query=gql_query, variables="null")) %>%
    httr2::req_perform() %>%
    httr2::resp_body_json()

}
