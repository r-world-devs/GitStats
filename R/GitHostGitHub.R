#' @noRd
GitHostGitHub <- R6::R6Class(
  classname = "GitHostGitHub",
  inherit = GitHost,
  public = list(
    initialize = function(orgs = NA,
                          repos = NA,
                          token = NA,
                          host = NA,
                          verbose = NA) {
      super$initialize(orgs = orgs,
                       repos = repos,
                       token = token,
                       host = host,
                       verbose = verbose)
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
    },

    # Set projects endpoint
    set_repositories_endpoint = function() {
      private$endpoints$repositories <- glue::glue("{private$api_url}/repos")
    },

    # Set owner type
    set_owner_type = function(owners) {
      graphql_engine <- private$engines$graphql
      user_or_org_query <- graphql_engine$gql_query$user_or_org_query
      login_types <- purrr::map(owners, function(owner) {
        response <- graphql_engine$gql_response(
          gql_query = user_or_org_query,
          vars = list(
            "login" = owner
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

    # Get projects URL from search response
    get_repo_url_from_response = function(search_response, type, progress = TRUE) {
      purrr::map_vec(search_response, function(project) {
        if (type == "api") {
          project$repository$url
        } else {
          project$repository$html_url
        }
      })
    },

    # Pull commits from GitHub
    get_commits_from_orgs = function(since, until, verbose, progress) {
      graphql_engine <- private$engines$graphql
      commits_table <- purrr::map(private$orgs, function(org) {
        commits_table_org <- NULL
        if (!private$scan_all && verbose) {
          show_message(
            host        = private$host_name,
            engine      = "graphql",
            scope       = org,
            information = "Pulling commits"
          )
        }
        repos_names <- private$set_repositories(
          org = org
        )
        commits_table_org <- graphql_engine$get_commits_from_repos(
          org         = org,
          repos_names = repos_names,
          since       = since,
          until       = until,
          progress    = progress
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
    },

    # Use repositories either from parameter or, if not set, pull them from API
    set_repositories = function(org) {
      if (private$searching_scope == "repo") {
        repos_names <- private$orgs_repos[[org]]
      } else {
        repos_table <- private$get_all_repos(
          verbose = FALSE
        )
        repos_names <- repos_table$repo_name
      }
      return(repos_names)
    },

    # Prepare files table from REST API.
    prepare_files_table_from_rest = function(files_list) {
      files_table <- NULL
      if (!is.null(files_list)) {
        files_table <- purrr::map(files_list, function(file_data) {
          repo_fullname <- private$get_repo_fullname(file_data$url)
          org_repo <- stringr::str_split_1(repo_fullname, "/")
          data.frame(
            "repo_name" = org_repo[2],
            "repo_id" = NA_character_,
            "organization" = org_repo[1],
            "file_path" = file_data$path,
            "file_content" = file_data$content,
            "file_size" = file_data$size,
            "repo_url" = private$set_repo_url(file_data$url)
          )
        }) %>%
          purrr::list_rbind()
      }
      return(files_table)
    },

    # Get repository full name
    get_repo_fullname = function(file_url) {
      stringr::str_remove_all(file_url,
                              paste0(private$endpoints$repositories, "/")) %>%
        stringr::str_replace_all("/contents.*", "")
    },

    # Get repository url
    set_repo_url = function(repo_fullname) {
      paste0(private$endpoints$repositories, "/", repo_fullname)
    }
  )
)
