#' @noRd
#' @description A class for methods wrapping GitHub's GraphQL API responses.
EngineGraphQL <- R6::R6Class(
  "EngineGraphQL",
  inherit = Engine,
  public = list(

    #' @field gql_api_url A character, url of GraphQL API.
    gql_api_url = NULL,

    #' @field gql_query An environment for GraphQL queries.
    gql_query = NULL,

    #' Create `EngineGraphQL` object.
    initialize = function(gql_api_url = NA,
                          token = NA,
                          scan_all = FALSE) {
      private$engine <- "graphql"
      self$gql_api_url <- gql_api_url
      private$token <- token
      private$scan_all <- scan_all
    },

    #' Wrapper of GraphQL API request and response.
    gql_response = function(gql_query, vars = "null") {
      response <- private$perform_request(
        gql_query = gql_query,
        vars = vars
      )
      response_list <- httr2::resp_body_json(response)
      return(response_list)
    },

    # A method to pull information on user.
    get_user = function(username) {
      response <- tryCatch(
        {
          self$gql_response(
            gql_query = self$gql_query$user(),
            vars = list("user" = username)
          )
        },
        error = function(e) {
          NULL
        }
      )
      return(response)
    }
  ),
  private = list(

    # GraphQL method for pulling response from API
    perform_request = function(gql_query, vars, token = private$token) {
      response <- httr2::request(paste0(self$gql_api_url, "?")) %>%
        httr2::req_headers("Authorization" = paste0("Bearer ", token)) %>%
        httr2::req_body_json(list(query = gql_query, variables = vars)) %>%
        httr2::req_retry(
          is_transient = ~ httr2::resp_status(.x) %in% c(400, 502),
          max_seconds = 30
        ) %>%
        httr2::req_perform()
      return(response)
    },
    is_query_error = function(response) {
      check <- FALSE
      if (length(response) > 0) {
        check <- names(response) == "errors"
      }
      return(check)
    },
    filter_files_by_pattern = function(files_structure, pattern) {
      files_structure[grepl(pattern, files_structure)]
    },
    get_path_from_files_structure = function(host_files_structure,
                                             only_text_files,
                                             org,
                                             repo = NULL) {
      if (is.null(repo)) {
        file_path <- host_files_structure[[org]] %>%
          unlist(use.names = FALSE) %>%
          unique()
      } else {
        file_path <- host_files_structure[[org]][[repo]]
      }
      if (only_text_files) {
        file_path <- file_path[!grepl(non_text_files_pattern, file_path)]
      }
      return(file_path)
    }
  )
)
