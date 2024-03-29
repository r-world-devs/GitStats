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
      self$rest_api_url <- rest_api_url
      private$token <- private$check_token(token)
      private$scan_all <- scan_all
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

    #' @description Check if repositories exist
    #' @param repos A character vector of repositories
    #' @return repos or NULL.
    check_repositories = function(repos) {
      repos <- purrr::map(repos, function(repo) {
        private$check_endpoint(
          repo = repo
        )
        return(repo)
      }) %>%
        purrr::keep(~ length(.) > 0) %>%
        unlist()

      if (length(repos) == 0) {
        return(NULL)
      }
      repos
    },

    #' @description Check if organizations exist
    #' @param orgs A character vector of organizations
    #' @return orgs or NULL.
    check_organizations = function(orgs) {
      orgs <- purrr::map(orgs, function(org) {
        org <- private$check_endpoint(
          org = org
        )
        return(org)
      }) %>%
        purrr::keep(~ length(.) > 0) %>%
        unlist()
      if (length(orgs) == 0) {
        return(NULL)
      }
      orgs
    }
  ),
  private = list(

    # @field token A token authorizing access to API.
    token = NULL,

    # @field A boolean.
    scan_all = FALSE,

    # @description Check whether the token exists.
    # @param token A token.
    # @return A token.
    check_token = function(token) {
      if (nchar(token) == 0) {
        cli::cli_abort(c(
          "i" = "No token provided."
        ))
      }
    },

    # @description Check whether the endpoint exists.
    # @param repo Repository path.
    # @param org Organization path.
    check_endpoint = function(repo = NULL, org = NULL) {
      if (!is.null(repo)) {
        type <- "Repository"
        repo_endpoint <- if(grepl("github", self$rest_api_url)) "/repos/" else "/projects/"
        endpoint <- paste0(self$rest_api_url, repo_endpoint, repo)
        object <- repo
      }
      if (!is.null(org)) {
        type <- "Organization"
        org_endpoint <- if(grepl("github", self$rest_api_url)) "/orgs/" else "/groups/"
        endpoint <- paste0(self$rest_api_url, org_endpoint, org)
        object <- org
      }
      withCallingHandlers(
        {
          self$response(endpoint = endpoint)
        },
        message = function(m) {
          if (grepl("404", m)) {
            cli::cli_alert_danger("{type} you provided does not exist or its name was passed in a wrong way: {endpoint}")
            cli::cli_alert_warning("Please type your {tolower(type)} name as you see it in `url`.")
            cli::cli_alert_info("E.g. do not use spaces. {type} names as you see on the page may differ from their 'address' name.")
            object <<- NULL
          }
        }
      )
      return(object)
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
