#' @importFrom R6 R6Class
#' @importFrom rlang expr
#' @importFrom cli cli_alert_danger cli_alert_success

#' @title A GitHost superclass

GitHost <- R6::R6Class("GitHost",
  public = list(

    #' @description Create a new `GitPlatform` object
    #' @param orgs A character vector of organisations (owners of repositories
    #'   in case of GitHub and groups of projects in case of GitLab).
    #' @param token A token.
    #' @param api_url An API url.
    #' @return A new `GitPlatform` object
    initialize = function(orgs = NA,
                          token = NA,
                          api_url = NA) {
      if (grepl("https://", api_url) && grepl("github", api_url)) {
        private$engines$rest <- EngineRestGitHub$new(
          token = token,
          rest_api_url = api_url
        )
        private$engines$graphql <- EngineGraphQLGitHub$new(
          token = token,
          gql_api_url = private$set_gql_url(api_url)
        )
        cli::cli_alert_success("Set connection to GitHub.")
      } else if (grepl("https://", api_url) && grepl("gitlab|code", api_url)) {
        private$engines$rest <- EngineRestGitLab$new(
          token = token,
          rest_api_url = api_url
        )
        cli::cli_alert_success("Set connection to GitLab.")
      } else {
        stop("This connection is not supported by GitStats class object.")
      }
      private$orgs <- private$engines$rest$check_organizations(orgs)
    },

    #' @description  A method to list all repositories for an organization, a
    #'   team or by a keyword.
    #' @param settings A list of `GitStats` settings.
    #' @return A data.frame of repositories.
    get_repos = function(settings) {

      repos_table <- purrr::map(private$orgs, function(org) {
        repos_table_org <- purrr::map(private$engines, ~ .$get_repos(
          org = org,
          settings = settings
        )) %>%
          purrr::list_rbind()
        return(repos_table_org)
        cli::cli_alert_info("Number of repositories: {nrow(repos_table_org)}")

      }) %>%
        purrr::list_rbind()

      return(repos_table)
    },

    #' @description A method to get information on commits.
    #' @param date_from A starting date to look commits for.
    #' @param date_until An end date to look commits for.
    #' @param settings A list of `GitStats` settings.
    #' @return A data.frame of commits
    get_commits = function(date_from,
                           date_until = Sys.Date(),
                           settings
                           ) {

      commits_table <- purrr::map(private$orgs, function(org) {
        commits_table_org <- purrr::map(private$engines, ~ .$get_commits(
          org = org,
          date_from = date_from,
          date_until = date_until,
          settings = settings
        )) %>%
          purrr::list_rbind()

        return(commits_table_org)
      }) %>%
        purrr::list_rbind()

      return(commits_table)
    }
  ),
  private = list(

    # @field orgs A character vector of repo organizations.
    orgs = NULL,

    # @field engines A placeholder for REST and GraphQL Engine classes.
    engines = list(),

    # @description GraphQL url handler (if not provided).
    # @param rest_api_url REST API url.
    # @return GraphQL API url.
    set_gql_url = function(rest_api_url) {
      paste0(gsub("/v+.*", "", rest_api_url), "/graphql")
    }
  )
)
