#' @noRd
GitHostGitLab <- R6::R6Class("GitHostGitLab",
  inherit = GitHost,
  public = list(
    initialize = function(orgs = NA,
                          repos = NA,
                          token = NA,
                          host = NA,
                          verbose = NA) {
      repos <- if (!is.null(repos)) {
        url_encode(repos)
      }
      orgs <- if (!is.null(orgs)) {
        url_encode(orgs)
      }
      super$initialize(orgs = orgs,
                       repos = repos,
                       token = token,
                       host = host,
                       verbose = verbose)
      if (verbose) {
        cli::cli_alert_success("Set connection to GitLab.")
      }
    },

    # Retrieve content of given text files from all repositories for a host in
    # a table format.
    get_files_content = function(file_path,
                                 host_files_structure = NULL,
                                 only_text_files      = TRUE,
                                 verbose              = TRUE,
                                 progress             = TRUE) {
      if (!private$scan_all && private$are_non_text_files(file_path, host_files_structure)) {
        if (only_text_files) {
          files_table <- private$get_files_content_from_orgs(
            file_path            = file_path,
            host_files_structure = host_files_structure,
            only_text_files      = only_text_files,
            verbose              = verbose,
            progress             = progress
          )
        } else {
          text_files_table <- private$get_files_content_from_orgs(
            file_path            = file_path,
            host_files_structure = host_files_structure,
            only_text_files      = TRUE,
            verbose              = verbose,
            progress             = progress
          )
          non_text_files_table <- private$get_files_content_from_orgs_via_rest(
            file_path = file_path,
            host_files_structure = host_files_structure,
            clean_files_content  = FALSE,
            only_non_text_files  = TRUE,
            verbose              = verbose,
            progress             = progress
          )
          files_table <- purrr::list_rbind(
            list(
              text_files_table,
              non_text_files_table
            )
          )
        }
      } else {
        files_table <- super$get_files_content(
          file_path            = file_path,
          host_files_structure = host_files_structure,
          verbose              = verbose,
          progress             = progress
        )
      }
      return(files_table)
    }
  ),
  private = list(

    # Host
    host_name = "GitLab",

    # API version
    api_version = 4,

    # Default token name
    token_name = "GITLAB_PAT",

    # Minimum access scopes for token
    min_access_scopes = c("read_api"),

    # Access scopes for token
    access_scopes = c("api", "read_api"),

    # Methods for engines
    engine_methods = list(
      "graphql" = list(
        "repos",
        "release_logs"
      ),
      "rest" = list(
        "code",
        "commits",
        "contributors"
      )
    ),

    # Set API URL
    set_api_url = function(host) {
      if (is.null(host)) {
        private$api_url <- glue::glue(
          "https://gitlab.com/api/v{private$api_version}"
        )
      } else {
        private$set_custom_api_url(host)
      }
    },

    # Set web URL
    set_web_url = function(host) {
      if (is.null(host)) {
        private$web_url <- glue::glue(
          "https://gitlab.com"
        )
      } else {
        private$set_custom_web_url(host)
      }
    },

    # Check whether Git platform is public or internal.
    check_if_public = function(host) {
      private$is_public <- is.null(host) || grepl("gitlab.com", host)
    },

    # Set endpoint for basic checks
    set_test_endpoint = function() {
      private$test_endpoint <- glue::glue("{private$api_url}/projects")
    },

    # Set tokens endpoint
    set_tokens_endpoint = function() {
      private$endpoints$tokens <- glue::glue("{private$api_url}/personal_access_tokens")
    },

    # Set groups endpoint
    set_orgs_endpoint = function() {
      private$endpoints$orgs <- glue::glue("{private$api_url}/groups")
    },

    # Set projects endpoint
    set_repositories_endpoint = function() {
      private$endpoints$repositories <- glue::glue("{private$api_url}/projects")
    },

    # Set owner type
    set_owner_type = function(owners) {
      graphql_engine <- private$engines$graphql
      user_or_org_query <- graphql_engine$gql_query$user_or_org_query
      login_types <- purrr::map(owners, function(owner) {
        response <- graphql_engine$gql_response(
          gql_query = user_or_org_query,
          vars = list(
            "username"  = owner,
            "grouppath" = owner
          )
        )
        type <- purrr::discard(response$data, is.null) %>%
          names()
        attr(owner, "type") <- type
        return(owner)
      })
      return(login_types)
    },

    # Setup REST and GraphQL engines
    setup_engines = function() {
      private$engines$rest <- EngineRestGitLab$new(
        rest_api_url = private$api_url,
        token = private$token,
        scan_all = private$scan_all
      )
      private$engines$graphql <- EngineGraphQLGitLab$new(
        gql_api_url = private$graphql_api_url,
        token = private$token,
        scan_all = private$scan_all
      )
    },

    # check token scopes
    # response parameter only for need of super method
    check_token_scopes = function(response = NULL, token) {
      private$token_scopes <- try({
        httr2::request(private$endpoints$tokens) %>%
          httr2::req_headers("Authorization" = paste0("Bearer ", token)) %>%
          httr2::req_perform() %>%
          httr2::resp_body_json() %>%
          purrr::keep(~ .$active) %>%
          purrr::map(function(pat) {
            data.frame(scopes = unlist(pat$scopes), date = pat$last_used_at)
          }) %>%
          purrr::list_rbind() %>%
          dplyr::filter(
            date == max(date)
          ) %>%
          dplyr::select(scopes) %>%
          unlist()
      },
      silent = TRUE)
      any(private$access_scopes %in% private$token_scopes)
    },

    # Add `api_url` column to table.
    add_repo_api_url = function(repos_table) {
      if (!is.null(repos_table) && nrow(repos_table) > 0) {
        repos_table <- dplyr::mutate(
          repos_table,
          api_url = paste0(private$endpoints$repositories,
                           "/",
                           stringr::str_match(repo_id, "[0-9].*"))
        )
      }
      return(repos_table)
    },

    # Get projects API URL from search response
    get_repo_url_from_response = function(search_response, type, progress = TRUE) {
      purrr::map_vec(search_response, function(response) {
        api_url <- paste0(private$api_url, "/projects/", response$project_id)
        if (type == "api") {
          return(api_url)
        } else {
          rest_engine <- private$engines$rest
          project_response <- rest_engine$response(
            endpoint = api_url
          )
          web_url <- project_response$web_url
          return(web_url)
        }
      }, .progress = if (progress && type != "api") {
        "Mapping api URL to web URL..."
      } else {
        FALSE
      })
    },

    # Pull commits from GitHub
    get_commits_from_orgs = function(since,
                                     until,
                                     verbose  = TRUE,
                                     progress = verbose) {
      rest_engine <- private$engines$rest
      commits_table <- purrr::map(private$orgs, function(org) {
        commits_table_org <- NULL
        if (!private$scan_all && verbose) {
          show_message(
            host        = private$host_name,
            engine      = "rest",
            scope       = utils::URLdecode(org),
            information = "Pulling commits"
          )
        }
        repos_names <- private$set_repositories(
          org = org
        )
        commits_table_org <- rest_engine$get_commits_from_repos(
          repos_names = repos_names,
          since       = since,
          until       = until,
          progress    = progress
        ) %>%
          rest_engine$tailor_commits_info(org = org) %>%
          rest_engine$prepare_commits_table() %>%
          rest_engine$get_commits_authors_handles_and_names(
            verbose  = verbose,
            progress = progress
          )
        return(commits_table_org)
      }, .progress = if (private$scan_all && progress) {
        "[GitHost:GitLab] Pulling commits..."
      } else {
        FALSE
      }) %>%
        purrr::list_rbind()
      return(commits_table)
    },

    # Use repositories either from parameter or, if not set, pull them from API
    set_repositories = function(org, settings) {
      if (private$searching_scope == "repo") {
        repos <- private$orgs_repos[[org]]
        repos_names <- paste0(org, "%2f", repos)
      } else {
        repos_table <- private$get_all_repos(
          verbose = FALSE
        )
        gitlab_web_url <- stringr::str_extract(private$api_url, "^.*?(?=api)")
        repos <- stringr::str_remove(repos_table$repo_url, gitlab_web_url)
        repos_names <- utils::URLencode(repos, reserved = TRUE)
      }
      return(repos_names)
    },

    are_non_text_files = function(file_path, host_files_structure) {
      if (!is.null(file_path)) {
        any(grepl(non_text_files_pattern, file_path))
      } else if (!is.null(host_files_structure)) {
        any(grepl(non_text_files_pattern, unlist(host_files_structure, use.names = FALSE)))
      } else {
        FALSE
      }
    },

    # Pull files from orgs via rest
    get_files_content_from_orgs_via_rest = function(file_path,
                                                    host_files_structure,
                                                    only_non_text_files,
                                                    clean_files_content,
                                                    verbose,
                                                    progress) {
      rest_engine <- private$engines$rest
      if (!is.null(host_files_structure)) {
        if (verbose) {
          cli::cli_alert_info(cli::col_green("I will make use of files structure stored in GitStats."))
        }
        result <- private$get_orgs_and_repos_from_files_structure(
          host_files_structure = host_files_structure
        )
        orgs <- result$orgs
        repos <- result$repos
      } else {
        orgs <- private$orgs
        repos <- private$repos
      }
      if (verbose) {
        user_msg <- if (!is.null(host_files_structure)) {
          "Pulling files from files structure"
        } else {
          glue::glue("Pulling files content: [{paste0(file_path, collapse = ', ')}]")
        }
        show_message(
          host = private$host_name,
          engine = "rest",
          information = user_msg
        )
      }
      files_table <- purrr::map(orgs, function(org) {
        if (!is.null(host_files_structure)) {
          file_path <- host_files_structure[[org]] %>% unlist(use.names = FALSE) %>% unique()
        }
        if (only_non_text_files) {
          file_path <- file_path[grepl(non_text_files_pattern, file_path)]
        }
        files_table <- rest_engine$get_files(
          file_paths          = file_path,
          clean_files_content = clean_files_content,
          org                 = org,
          verbose             = FALSE,
          progress            = progress
        ) %>%
          rest_engine$prepare_files_table()
      }, .progress = progress) %>%
        purrr::list_rbind() %>%
        private$add_repo_api_url()
      return(files_table)
    }
  )
)
