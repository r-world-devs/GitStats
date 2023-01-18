#' @importFrom progress progress_bar
#' @importFrom magrittr %>%

#' @description A wrapper for proper pagination of GitHub search REST API
#' @param search_endpoint A character, a search endpoint
#' @param total_n Number of results
#' @param byte_max Max byte size
#' @param token a token
search_request <- function(search_endpoint,
                           total_n,
                           byte_max,
                           token,
                           divider = 1e3) {
  if (total_n > 0 & total_n < 100) {
    resp_list <- perform_get_request(paste0(search_endpoint, "+size:0..", byte_max, "&page=1&per_page=100"),
      token = token
    )[["items"]]

    resp_list
  } else if (total_n >= 100 & total_n < 1e3) {
    resp_list <- list()

    for (page in 1:(total_n %/% 100)) {
      resp_list <- perform_get_request(paste0(search_endpoint, "+size:0..", byte_max, "&page=", page, "&per_page=100"),
        token = token
      )[["items"]] %>%
        append(resp_list, .)
    }

    resp_list
  } else if (total_n >= 1e3) {
    resp_list <- list()
    index <- c(0, divider)

    pb <- progress::progress_bar$new(
      format = "GitHub search limit (1000 results) exceeded. Results will be divided. :elapsedfull"
    )

    while (index[2] < as.numeric(byte_max)) {
      size_formula <- paste0("+size:", as.character(index[1]), "..", as.character(index[2]))

      pb$tick(0)

      n_count <- tryCatch(
        {
          perform_get_request(paste0(search_endpoint, size_formula),
            token = token
          )[["total_count"]]
        },
        error = function(e) {
          NULL
        }
      )

      if (is.null(n_count)) {
        NULL
      } else if ((n_count - 1) %/% 100 > 0) {
        for (page in (1:(n_count %/% 100))) {
          resp_list <- perform_get_request(paste0(search_endpoint, size_formula, "&page=", page, "&per_page=100"),
            token = token
          )[["items"]] %>% append(resp_list, .)
        }
      } else if ((n_count - 1) %/% 100 == 0) {
        resp_list <- perform_get_request(paste0(search_endpoint, size_formula, "&page=1&per_page=100"),
          token = token
        )[["items"]] %>%
          append(resp_list, .)
      }

      index[1] <- index[2]
      index[2] <- index[2] + divider
    }

    resp_list
  }
}

#' @importFrom httr2 request req_headers req_perform resp_body_json
#'
#' @name perform_get_request
#'
#' @description A wrapper for httr2 functions to perform get request to REST API endpoints.
#'
#' @param endpoint An API endpoint.
#' @param token An API token.
#'
#' @returns A content of response formatted to list.
#'
perform_get_request <- function(endpoint, token) {
  resp <- httr2::request(endpoint) %>%
    httr2::req_headers("Authorization" = paste0("Bearer ", token)) %>%
    httr2::req_error(body = resp_error_body) %>%
    httr2::req_retry(
      is_transient = resp_is_transient,
      after = req_after
    ) %>%
    httr2::req_perform()

  result <- resp %>% httr2::resp_body_json(check_type = FALSE)

  return(result)
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

#' @importFrom ghql GraphqlClient Query
#' @description Get response form GitHub GraphQL API endpoint.
#' @details Typically, you might get a HTTP 502 Error - an uninformative one. In
#'   that case repeat the request.
get_resp_gql <- function(api_url, token, query) {
  con <- ghql::GraphqlClient$new(
    url = api_url,
    headers = list(Authorization = paste0("Bearer ", token))
  )

  qry <- ghql::Query$new()

  qry$query("getcommits", query)

  data_from_json <- con$exec(qry$queries$getcommits) %>%
    jsonlite::fromJSON()

  return(data_from_json)
}
