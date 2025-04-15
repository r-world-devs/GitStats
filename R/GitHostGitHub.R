#' @noRd
GitHostGitHub <- R6::R6Class(
  classname = "GitHostGitHub",
  inherit = GitHost,
  public = list(
    initialize = function(orgs = NA,
                          repos = NA,
                          token = NA,
                          host = NA,
                          verbose = NA,
                          .error = TRUE) {
      super$initialize(orgs = orgs,
                       repos = repos,
                       token = token,
                       host = host,
                       verbose = verbose,
                       .error = .error)
      if (verbose) {
        cli::cli_alert_success("Set connection to GitHub.")
      }
    }
  ),
  private = list(

    # Host
    host_name = "GitHub",

    # API version
    api_version = 3,

    # Default token name
    token_name = "GITHUB_PAT",

    # Minimum access scopes for token
    min_access_scopes = c("public_repo", "read:org", "read:user"),

    # Access scopes for token
    access_scopes = list(
      org = c("read:org", "admin:org"),
      repo = c("public_repo", "repo"),
      user = c("read:user", "user")
    ),

    # Methods for engines
    engine_methods = list(
      "graphql" = list(
        "repos",
        "commits",
        "release_logs"
      ),
      "rest" = list(
        "code",
        "contributors"
      )
    ),

    # Set API URL
    set_api_url = function(host) {
      if (is.null(host) ||
            host == "https://github.com" ||
            host == "http://github.com" ||
            host == "github.com") {
        private$api_url <- "https://api.github.com"
      } else {
        private$set_custom_api_url(host)
      }
    },

    # Set web URL
    set_web_url = function(host) {
      if (is.null(host)) {
        private$web_url <- "https://github.com"
      } else {
        private$set_custom_web_url(host)
      }
    },

    # Check whether Git platform is public or internal.
    check_if_public = function(host) {
      private$is_public <- is.null(host) || grepl("github.com", host)
    },

    # Set endpoint for basic checks
    set_test_endpoint = function() {
      private$test_endpoint <- private$api_url
    },

    # Set tokens endpoint
    set_tokens_endpoint = function() {
      private$endpoints$tokens <- NULL
    },

    # Set groups endpoint
    set_orgs_endpoint = function() {
      private$endpoints$orgs <- glue::glue("{private$api_url}/orgs")
      private$endpoints$users <- glue::glue("{private$api_url}/users")
    },

    # Set projects endpoint
    set_repositories_endpoint = function() {
      private$endpoints$repositories <- glue::glue("{private$api_url}/repos")
    },

    # Setup REST and GraphQL engines
    setup_engines = function() {
      private$engines$rest <- EngineRestGitHub$new(
        rest_api_url = private$api_url,
        token = private$token,
        scan_all = private$scan_all
      )
      private$engines$graphql <- EngineGraphQLGitHub$new(
        gql_api_url = private$graphql_api_url,
        token = private$token,
        scan_all = private$scan_all
      )
    },

    # Check token scopes
    # token parameter only for need of super method
    check_token_scopes = function(response, token = NULL) {
      private$token_scopes <- response$headers$`x-oauth-scopes` %>%
        stringr::str_split(", ") %>%
        unlist()
      org_scopes <- any(private$access_scopes$org %in% private$token_scopes)
      repo_scopes <- any(private$access_scopes$repo %in% private$token_scopes)
      user_scopes <- any(private$access_scopes$user %in% private$token_scopes)
      all(c(org_scopes, repo_scopes, user_scopes))
    },

    # Add `api_url` column to table.
    add_repo_api_url = function(repos_table) {
      if (!is.null(repos_table) && nrow(repos_table) > 0) {
        repos_table <- dplyr::mutate(
          repos_table,
          api_url = paste0(private$endpoints$repositories, "/", organization, "/", repo_name),
        )
      }
      return(repos_table)
    },

    get_orgs_from_host = function(output, verbose) {
      graphql_engine <- private$engines$graphql
      orgs <- graphql_engine$get_orgs(
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
      purrr::map_vec(search_response, ~.$repository$node_id) |> unique()
    },

    # Get projects URL from search response
    get_repo_url_from_response = function(search_response, repos_fullnames = NULL, type, progress = TRUE) {
      if (!is.null(repos_fullnames)) {
        search_response <- search_response |>
          purrr::keep(~ paste0(.$organization$login, "/", .$repo_name) %in% repos_fullnames)
      }
      purrr::map_vec(search_response, function(project) {
        if (type == "api") {
          paste0(private$api_url, "/repos/", project$organization$login, "/", project$repo_name)
        } else {
          project$repo_url
        }
      })
    },

    # Pull commits from GitHub
    get_commits_from_orgs = function(since, until, verbose, progress) {
      if ("org" %in% private$searching_scope) {
        graphql_engine <- private$engines$graphql
        commits_table <- purrr::map(private$orgs, function(org) {
          commits_table_org <- NULL
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "graphql",
              scope = org,
              information = "Pulling commits"
            )
          }
          repos_names <- private$get_repos_names(org)
          commits_table_org <- graphql_engine$get_commits_from_repos(
            org = org,
            repos_names = repos_names,
            since = since,
            until = until,
            progress = progress
          ) %>%
            graphql_engine$prepare_commits_table(
              org = org
            )
          return(commits_table_org)
        }, .progress = if (private$scan_all && progress) {
          "[GitHost:GitHub] Pulling commits..."
        } else {
          FALSE
        }) %>%
          purrr::list_rbind()
        return(commits_table)
      }
    },

    # Pull commits from GitHub
    get_commits_from_repos = function(since, until, verbose, progress) {
      if ("repo" %in% private$searching_scope) {
        graphql_engine <- private$engines$graphql
        orgs <- graphql_engine$set_owner_type(
          owners = names(private$orgs_repos)
        )
        commits_table <- purrr::map(orgs, function(org) {
          commits_table_org <- NULL
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "graphql",
              scope = set_repo_scope(org, private),
              information = "Pulling commits"
            )
          }
          commits_table_org <- graphql_engine$get_commits_from_repos(
            org = org,
            repos_names = private$orgs_repos[[org]],
            since = since,
            until = until,
            progress = progress
          ) %>%
            graphql_engine$prepare_commits_table(
              org = org
            )
          return(commits_table_org)
        }, .progress = if (private$scan_all && progress) {
          "[GitHost:GitHub] Pulling commits..."
        } else {
          FALSE
        }) %>%
          purrr::list_rbind()
        return(commits_table)
      }
    },

    # Use repositories either from parameter or, if not set, pull them from API
    get_repos_names = function(org) {
      owner_type <- attr(org, "type") %||% "organization"
      org <- utils::URLdecode(org)
      graphql_engine <- private$engines$graphql
      repos_names <- graphql_engine$get_repos_from_org(
        org = org,
        owner_type = owner_type,
        verbose = verbose
      ) |>
        purrr::map_vec(~ .$repo_name)
      return(repos_names)
    },

    # Get repository url
    set_repo_url = function(repo_fullname) {
      paste0(private$endpoints$repositories, "/", repo_fullname)
    }
  )
)
