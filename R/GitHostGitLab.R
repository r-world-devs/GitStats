#' @noRd
GitHostGitLab <- R6::R6Class("GitHostGitLab",
  inherit = GitHost,
  public = list(
    initialize = function(orgs = NA,
                          repos = NA,
                          token = NA,
                          host = NA) {
      repos <- if (!is.null(repos)) {
        url_encode(repos)
      }
      orgs <- if (!is.null(orgs)) {
        url_encode(orgs)
      }
      super$initialize(orgs = orgs,
                       repos = repos,
                       token = token,
                       host = host)
      cli::cli_alert_success("Set connection to GitLab.")
    }
  ),
  private = list(

    # Host
    host_name = "GitLab",

    # API version
    api_version = 4,

    # Default token name
    token_name = "GITLAB_PAT",

    # Access scopes for token
    access_scopes = c("api", "read_api"),

    # Methods for engines
    engine_methods = list(
      "graphql" = list(
        "repos",
        "release_logs"
      ),
      "rest" = list(
        "phrase",
        "commits",
        "contributors"
      )
    ),

    # Set API url
    set_api_url = function(host) {
      if (is.null(host)) {
        private$api_url <- glue::glue(
          "https://gitlab.com/api/v{private$api_version}"
        )
      } else {
        private$set_custom_api_url(host)
      }
    },

    # Check whether Git platform is public or internal.
    check_if_public = function(host) {
      private$is_public <- is.null(host) || grepl("gitlab.com", host)
    },

    # Set endpoint for basic checks
    set_test_endpoint = function() {
      private$test_endpoint = glue::glue("{private$api_url}/projects")
    },

    # Set tokens endpoint
    set_tokens_endpoint = function() {
      private$endpoints$tokens = glue::glue("{private$api_url}/personal_access_tokens")
    },

    # Set groups endpoint
    set_orgs_endpoint = function() {
      private$endpoints$orgs = glue::glue("{private$api_url}/groups")
    },

    # Set projects endpoint
    set_repositories_endpoint = function() {
      private$endpoints$repositories = glue::glue("{private$api_url}/projects")
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
      TRUE
    },

    # Add `api_url` column to table.
    add_repo_api_url = function(repos_table){
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

    # Pull commits from GitHub
    pull_commits_from_host = function(since, until, settings, storage) {
      api_engine <- private$run_engine("commits")
      commits_table <- purrr::map(private$orgs, function(org) {
        commits_table_org <- NULL
        repos <- private$set_repos(settings, org)
        commits_table_org <- api_engine$pull_commits(
          org = org,
          repos = repos,
          date_from = since,
          date_until = until,
          settings = settings,
          storage = storage
        )
        return(commits_table_org)
      }, .progress = private$scan_all) %>%
        purrr::list_rbind()
      return(commits_table)
    }
  )
)
