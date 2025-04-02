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
    },

    # Iterator over pulling issues from all repositories.
    get_issues_from_repos = function(org,
                                     repos_names,
                                     progress) {
      repos_list_with_issues <- purrr::map(repos_names, function(repo) {
        private$get_issues_from_one_repo(
          org   = org,
          repo  = repo
        )
      }, .progress = !private$scan_all && progress)
      names(repos_list_with_issues) <- repos_names
      repos_list_with_issues <- repos_list_with_issues %>%
        purrr::discard(~ length(.) == 0)
      return(repos_list_with_issues)
    },

    # Parses repositories' list with issues into table of issues.
    prepare_issues_table = function(repos_list_with_issues,
                                    org) {
      issues_table <- purrr::imap(repos_list_with_issues, function(repo, repo_name) {
        issues_row <- purrr::map_dfr(repo, function(issue_data) {
          state <- tolower(issue_data[["node"]][["state"]])
          if (state == "opened") {
            state <- "open"
          }
          get_node_data <- function(node_data) {
            issue_data[["node"]][[node_data]] %||% ""
          }
          data.frame(
            number = as.character(get_node_data("number")),
            title = get_node_data("title"),
            description = get_node_data("description"),
            created_at = lubridate::as_datetime(get_node_data("created_at")),
            closed_at = lubridate::as_datetime(get_node_data("closed_at")),
            state = state,
            url = get_node_data("url"),
            author = issue_data[["node"]][["author"]][["login"]]
          )
        })
        issues_row$repository <- repo_name
        issues_row
      }) %>%
        purrr::discard(~ length(.) == 1) %>%
        purrr::list_rbind()
      if (nrow(issues_table) > 0) {
        issues_table <- issues_table %>%
          dplyr::mutate(
            organization = org,
            api_url = self$gql_api_url
          )
      }
      return(issues_table)
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
          max_seconds = 60
        ) %>%
        httr2::req_perform()
      return(response)
    },

    is_query_error = function(response) {
      check <- FALSE
      if (length(response) > 0) {
        check <- any(names(response) == "errors")
      }
      return(check)
    },

    filter_files_by_pattern = function(files_structure, pattern) {
      files_structure[grepl(paste0(pattern, collapse = "|"), files_structure)]
    },

    get_path_from_files_structure = function(host_files_structure,
                                             org,
                                             repo = NULL) {
      if (is.null(repo)) {
        file_path <- host_files_structure[[org]] %>%
          unlist(use.names = FALSE) %>%
          unique()
      } else {
        file_path <- host_files_structure[[org]][[repo]]
      }
      file_path <- file_path[grepl(text_files_pattern, file_path)]
      return(file_path)
    }
  )
)
