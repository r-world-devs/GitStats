#' @noRd
GitHostGitLab <- R6::R6Class("GitHostGitLab",
  inherit = GitHost,
  public = list(
    initialize = function(orgs = NA,
                          repos = NA,
                          token = NA,
                          host = NA,
                          verbose = NA,
                          .error = TRUE) {
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
                       verbose = verbose,
                       .error = .error)
      if (verbose) {
        cli::cli_alert_success("Set connection to GitLab.")
      }
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
      private$endpoints$users <- glue::glue("{private$api_url}/users?username=")
    },

    # Set projects endpoint
    set_repositories_endpoint = function() {
      private$endpoints$repositories <- glue::glue("{private$api_url}/projects")
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

    # An empty method to fullfill call from super class.
    check_token_scopes = function(response = NULL, token) {
      TRUE
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

    get_orgs_from_host = function(output, verbose) {
      rest_engine <- private$engines$rest
      orgs_count <- rest_engine$get_orgs_count(verbose)
      if (verbose) {
        cli::cli_alert_info("{orgs_count} organizations found.")
      }
      graphql_engine <- private$engines$graphql
      orgs <- graphql_engine$get_orgs(
        orgs_count = as.integer(orgs_count),
        output = output,
        verbose = verbose
      )
      if (output == "full_table") {
        orgs <- orgs |>
          graphql_engine$prepare_orgs_table()
        private$orgs <- dplyr::pull(orgs, path)
      } else {
        private$orgs <- orgs
      }
      return(orgs)
    },

    get_repos_ids = function(search_response) {
      purrr::map_vec(search_response, ~.$project_id) |> unique()
    },

    # Get projects API URL from search response
    get_repo_url_from_response = function(search_response, type, repos_fullnames = NULL, progress = TRUE) {
      repo_urls <- purrr::map_vec(search_response, function(response) {
        api_url <- paste0(private$api_url, "/projects/", gsub("gid://gitlab/Project/", "", response$node$repo_id))
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
      return(repo_urls)
    },

    get_commits_from_orgs = function(since,
                                     until,
                                     verbose  = TRUE,
                                     progress = verbose) {
      if ("org" %in% private$searching_scope) {
        rest_engine <- private$engines$rest
        commits_table <- purrr::map(private$orgs, function(org) {
          commits_table_org <- NULL
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "rest",
              scope = utils::URLdecode(org),
              information = "Pulling commits"
            )
          }
          repos_names <- private$get_repos_names(
            org = org
          )
          commits_table_org <- rest_engine$get_commits_from_repos(
            repos_names = paste0(org, "%2f", repos_names),
            since = since,
            until = until,
            progress = progress
          ) %>%
            rest_engine$tailor_commits_info(org = org) %>%
            rest_engine$prepare_commits_table() %>%
            rest_engine$get_commits_authors_handles_and_names(
              verbose = verbose,
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
      }
    },

    get_commits_from_repos = function(since,
                                      until,
                                      verbose  = TRUE,
                                      progress = verbose) {
      if ("repo" %in% private$searching_scope) {
        rest_engine <- private$engines$rest
        graphql_engine <- private$engines$graphql
        orgs <- graphql_engine$set_owner_type(
          owners = names(private$orgs_repos)
        )
        commits_table <- purrr::map(orgs, function(org) {
          commits_table_org <- NULL
          repos <- private$orgs_repos[[org]]
          repos_names <- paste0(utils::URLencode(org, reserved = TRUE), "%2f", repos)
          if (!private$scan_all && verbose) {
            show_message(
              host        = private$host_name,
              engine      = "rest",
              scope       = set_repo_scope(org, private),
              information = "Pulling commits"
            )
          }
          commits_table_org <- rest_engine$get_commits_from_repos(
            repos_names = repos_names,
            since = since,
            until = until,
            progress = progress
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
      }
    },

    # Use repositories either from parameter or, if not set, pull them from API
    get_repos_names = function(org) {
      graphql_engine <- private$engines$graphql
      type <- attr(org, "type") %||% "organization"
      repos_names <- graphql_engine$get_repos_from_org(
        org = utils::URLdecode(org),
        type = type
      ) |>
        purrr::map_vec(~ .$node$repo_path)
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

    # Pull files content from organizations
    get_files_content_from_repos = function(file_path,
                                            verbose = TRUE,
                                            progress = TRUE) {
      if ("repo" %in% private$searching_scope) {
        graphql_engine <- private$engines$graphql
        orgs <- graphql_engine$set_owner_type(
          owners = names(private$orgs_repos)
        )
        files_table <- purrr::map(orgs, function(org) {
          if (verbose) {
            show_message(
              host = private$host_name,
              engine = "graphql",
              scope = set_repo_scope(org, private),
              information = glue::glue("Pulling files content: [{paste0(file_path, collapse = ', ')}]")
            )
          }
          type <- attr(org, "type") %||% "organization"
          graphql_engine$get_files_from_org_per_repo(
            org = org,
            type = type,
            repos = private$orgs_repos[[org]],
            file_paths = file_path,
            verbose = verbose,
            progress = progress
          ) |>
            graphql_engine$prepare_files_table(
              org = org
            )
        }) |>
          purrr::list_rbind() |>
          private$add_repo_api_url()
        return(files_table)
      }
    },

    get_files_content_from_files_structure = function(files_structure,
                                                      verbose = TRUE,
                                                      progress = TRUE) {
      graphql_engine <- private$engines$graphql
      result <- private$get_orgs_and_repos_from_files_structure(
        files_structure = files_structure
      )
      orgs <- result$orgs
      repos <- result$repos
      files_table <- purrr::map(orgs, function(org) {
        if (verbose) {
          show_message(
            host = private$host_name,
            engine = "graphql",
            scope = org,
            information = "Pulling files from files structure"
          )
        }
        type <- attr(org, "type") %||% "organization"
        graphql_engine$get_files_from_org_per_repo(
          org = org,
          type = type,
          repos = repos,
          host_files_structure = files_structure,
          verbose = verbose,
          progress = progress
        ) |>
          graphql_engine$prepare_files_table(
            org = org
          )
      }) |>
        purrr::list_rbind() |>
        private$add_repo_api_url()
      return(files_table)
    }
  )
)
