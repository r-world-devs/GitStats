EngineGraphQL <- R6::R6Class(
  "EngineGraphQL",
  inherit = Engine,
  public = list(
    gql_api_url = NULL,

    gql_query = NULL,

    initialize = function(gql_api_url = NA,
                          token = NA,
                          scan_all = FALSE) {
      private$engine <- "graphql"
      self$gql_api_url <- gql_api_url
      private$token <- token
      private$scan_all <- scan_all
    },

    gql_response = function(gql_query, vars = "null", verbose) {
      response <- private$perform_request(
        gql_query = gql_query,
        vars = vars,
        verbose = verbose
      )
      response_list <- httr2::resp_body_json(response) |>
        private$set_graphql_error_class()
      return(response_list)
    },

    get_user = function(username) {
      response <- self$gql_response(
        gql_query = self$gql_query$user(),
        vars = list("user" = username)
      )
      return(response)
    },

    get_issues_from_repos = function(org,
                                     repos_names,
                                     verbose) {
      repos_list_with_issues <- gitstats_map(repos_names, function(repo) {
        private$get_issues_from_one_repo(
          org = org,
          repo = repo,
          verbose = verbose
        )
      })
      names(repos_list_with_issues) <- repos_names
      repos_list_with_issues <- repos_list_with_issues |>
        purrr::discard(~ length(.) == 0)
      return(repos_list_with_issues)
    },

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
          author_login <- issue_data[["node"]][["author"]][["login"]] %||% NA_character_
          data.frame(
            "number" = as.character(get_node_data("number")),
            "title" = get_node_data("title"),
            "description" = get_node_data("description"),
            "created_at" = lubridate::as_datetime(get_node_data("created_at")),
            "closed_at" = lubridate::as_datetime(get_node_data("closed_at")),
            "state" = state,
            "url" = get_node_data("url"),
            "author" = author_login
          )
        })
        issues_row$repo_name <- repo_name
        issues_row
      }) |>
        purrr::discard(~ length(.) == 1) |>
        purrr::list_rbind()
      if (nrow(issues_table) > 0) {
        issues_table <- issues_table |>
          dplyr::mutate(
            organization = org,
            api_url = self$gql_api_url
          ) |>
          dplyr::relocate(
            repo_name,
            .before = number
          )
      }
      return(issues_table)
    },

    get_pr_from_repos = function(org,
                                 repos_names,
                                 verbose) {
      repos_list_with_pr <- gitstats_map(repos_names, function(repo) {
        private$get_pr_from_one_repo(
          org = org,
          repo = repo,
          verbose = verbose
        )
      })
      names(repos_list_with_pr) <- repos_names
      repos_list_with_pr <- repos_list_with_pr |>
        purrr::discard(~ length(.) == 0)
      return(repos_list_with_pr)
    },

    prepare_pr_table = function(repos_list_with_pr,
                                org) {
      pr_table <- purrr::imap(repos_list_with_pr, function(repo, repo_name) {
        pr_row <- purrr::map_dfr(repo, function(pr_data) {
          state <- tolower(pr_data[["node"]][["state"]])
          if (state == "opened") {
            state <- "open"
          }
          get_node_data <- function(node_data) {
            pr_data[["node"]][[node_data]] %||% ""
          }
          author_login <- pr_data[["node"]][["author"]][["login"]] %||% NA_character_
          data.frame(
            "number" = as.character(get_node_data("number")),
            "created_at" = lubridate::as_datetime(get_node_data("created_at")),
            "merged_at" = lubridate::as_datetime(get_node_data("merged_at")),
            "state" = state,
            "author" = author_login,
            "source_branch" = get_node_data("source_branch"),
            "target_branch" = get_node_data("target_branch")
          )
        })
        pr_row$repo_name <- repo_name
        pr_row
      }) |>
        purrr::discard(~ length(.) == 1) |>
        purrr::list_rbind()
      if (nrow(pr_table) > 0) {
        pr_table <- pr_table |>
          dplyr::mutate(
            organization = org,
            api_url = self$gql_api_url
          ) |>
          dplyr::relocate(
            repo_name,
            .before = number
          )
      }
      return(pr_table)
    }
  ),
  private = list(
    perform_request = function(gql_query, vars, token = private$token, verbose = TRUE) {
      response <- NULL
      response <- httr2::request(paste0(self$gql_api_url, "?")) |>
        httr2::req_headers("Authorization" = paste0("Bearer ", token)) |>
        httr2::req_body_json(list(query = gql_query, variables = vars)) |>
        httr2::req_error(is_error = function(resp) FALSE) |>
        httr2::req_perform()
      if (response$status_code %in% c(400, 502)) {
        response <- httr2::request(paste0(self$gql_api_url, "?")) |>
          httr2::req_headers("Authorization" = paste0("Bearer ", token)) |>
          httr2::req_body_json(list(query = gql_query, variables = vars)) |>
          httr2::req_retry(
            is_transient = ~ httr2::resp_status(.x) %in% c(400, 502),
            max_seconds = 60
          ) |>
          httr2::req_perform()
      }
      return(response)
    },

    handle_graphql_error = function(responses_list, verbose) {
      if (verbose && inherits(responses_list, "graphql_error")) {
        cli::cli_alert_danger("GraphQL returned errors:")
        if (inherits(responses_list, "graphql_no_fields_error")) {
          error_fields <- purrr::map_vec(responses_list$errors, ~.$extensions$fieldName %||% "") |>
            purrr::discard(~ . == "")
          cli::cli_alert_info("Your GraphQL does not recognize [{error_fields}] field{?s}.")
          cli::cli_alert_warning("Check version of your GitLab.")
        } else {
          cli::cli_alert_warning(purrr::map_vec(responses_list$errors, ~.$message))
        }
      }
      return(responses_list)
    },

    is_query_error = function(response) {
      check <- FALSE
      if (length(response) > 0) {
        check <- any(names(response) == "errors")
      }
      return(check)
    },

    is_no_fields_query_error = function(response) {
      any(purrr::map_lgl(response$errors, ~ grepl("doesn't exist on type", .$message)))
    },

    is_complexity_error = function(response) {
      any(purrr::map_lgl(response$errors, ~ grepl("Query has complexity", .$message)))
    },

    is_server_error = function(response) {
      any(purrr::map_lgl(response$errors, ~ grepl("Internal server error", .$message)))
    },

    set_graphql_error_class = function(response) {
      if (private$is_query_error(response)) {
        class(response) <- c(class(response), "graphql_error")
        if (private$is_no_fields_query_error(response)) {
          class(response) <- c(class(response), "graphql_no_fields_error")
        }
        if (private$is_complexity_error(response)) {
          class(response) <- c(class(response), "graphql_complexity_error")
        }
        if (private$is_server_error(response)) {
          class(response) <- c(class(response), "graphql_server_error")
        }
      }
      return(response)
    },

    filter_files_by_pattern = function(files_structure, pattern) {
      repo_id <- attr(files_structure, "repo_id")
      files_structure <- files_structure[grepl(paste0(pattern, collapse = "|"), files_structure)]
      attr(files_structure, "repo_id") <- repo_id
      return(files_structure)
    },

    get_path_from_files_structure = function(host_files_structure,
                                             org,
                                             repo = NULL) {
      if (is.null(repo)) {
        file_path <- host_files_structure[[org]] |>
          unlist(use.names = FALSE) |>
          unique()
      } else {
        file_path <- host_files_structure[[org]][[repo]]
      }
      file_path <- file_path[grepl(text_files_pattern, file_path)]
      return(file_path)
    }
  )
)
