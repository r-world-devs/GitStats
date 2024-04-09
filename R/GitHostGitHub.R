#' @noRd
GitHostGitHub <- R6::R6Class("GitHostGitHub",
  inherit = GitHost,
  public = list(
    initialize = function(orgs = NA,
                          repos = NA,
                          token = NA,
                          host = NA) {
      super$initialize(orgs = orgs,
                       repos = repos,
                       token = token,
                       host = host)
      cli::cli_alert_success("Set connection to GitHub.")
    }
  ),
  private = list(

    # Host
    host_name = "GitHub",

    # API version
    api_version = 3,

    # Default token name
    token_name = "GITHUB_PAT",

    # Access scopes for token
    access_scopes = c("public_repo", "read:org", "read:user"),

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

    # Set API url
    set_api_url = function(host) {
      if (is.null(host)) {
        private$api_url <- "https://api.github.com"
      } else {
        private$set_custom_api_url(host)
      }
    },

    # Check whether Git platform is public or internal.
    check_if_public = function(host) {
      private$is_public <- is.null(host) || grepl("github.com", host)
    },

    # Set endpoint for basic checks
    set_test_endpoint = function() {
      private$test_endpoint = private$api_url
    },

    # Set tokens endpoint
    set_tokens_endpoint = function() {
      private$endpoints$tokens = NULL
    },

    # Set groups endpoint
    set_orgs_endpoint = function() {
      private$endpoints$orgs = glue::glue("{private$api_url}/orgs")
    },

    # Set projects endpoint
    set_repositories_endpoint = function() {
      private$endpoints$repositories = glue::glue("{private$api_url}/repos")
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
      token_scopes <- response$headers$`x-oauth-scopes` %>%
        stringr::str_split(", ") %>% unlist()
      all(private$access_scopes %in% token_scopes)
    },

    # Add `api_url` column to table.
    add_repo_api_url = function(repos_table){
      if (!is.null(repos_table) && nrow(repos_table) > 0) {
        repos_table <- dplyr::mutate(
            repos_table,
            api_url = paste0(private$endpoints$repositories, "/", organization, "/", repo_name),
          )
      }
      return(repos_table)
    },

    # Pull commits from GitHub
    pull_commits_from_host = function(since, until, settings, storage) {
      commits_table <- purrr::map(private$orgs, function(org) {
        commits_table_org <- NULL
        repos <- private$set_repos(settings, org)
        api_engine <- private$set_engine("commits")
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
