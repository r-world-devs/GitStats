#' @importFrom R6 R6Class
#' @importFrom rlang expr
#' @importFrom cli cli_alert_danger cli_alert_success

#' @title A GitHost superclass

GitHost <- R6::R6Class("GitHost",
  public = list(

    #' @description Create a new `GitPlatform` object
    #' @param orgs A character vector of organisations (owners of repositories
    #'   in case of GitHub and groups of projects in case of GitLab).
    #' @param token
    #' @param api_url
    #' @param settings
    #' @return A new `GitPlatform` object
    initialize = function(orgs = NA,
                          token = NA,
                          api_url = NA,
                          settings = NA) {
      if (grepl("https://", api_url) && grepl("github", api_url)) {
        private$engines$rest <- EngineRestGitHub$new(
          token = token,
          rest_api_url = api_url
        )
        private$engines$graphql <- EngineGraphQLGitHub$new(
          token = token,
          gql_api_url = api_url
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
      if (is.null(orgs)) {
        cli::cli_alert_warning("No organizations specified.")
      } else {
        orgs <- private$engines$rest$check_organizations(orgs)
      }
      private$orgs <- orgs
      private$settings <- settings
    },

    #' @description  A method to list all repositories for an organization, a
    #'   team or by a keyword.
    #' @return A data.frame of repositories.
    get_repos = function() {

      private$check_for_organizations()

      repos_table <- purrr::map(private$orgs, function(org) {
        repos_table_org <- purrr::map(private$engines, ~ .$get_repos(
          org = org,
          settings = private$settings
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
    #' @return A data.frame of commits
    get_commits = function(date_from,
                           date_until = Sys.Date()
                           ) {
      private$check_for_organizations()

      commits_table <- purrr::map(private$orgs, function(org) {
        commits_table_org <- purrr::map(private$engines, ~ .$get_commits(
          org = org,
          date_from = date_from,
          date_until = date_until,
          settings = private$settings
        )) %>%
          purrr::list_rbind()

        return(commits_table_org)
      }) %>%
        purrr::list_rbind()

      if (private$settings$search_param == "team" && !is.null(private$settings$team)) {
        cli::cli_alert_success(
          paste0(
            "For '", private$settings$team_name, "' team: pulled ",
            nrow(commits_table), " commits from ",
            length(unique(commits_table$repository)), " repositories."
          )
        )
      }
      return(commits_table)
    },

    #' @description Method to update settings
    update_settings = function(settings) {
      private$settings <- settings
    }

  ),
  private = list(

    #' @field orgs
    orgs = NULL,

    #' @field engines
    engines = list(),

    #' @field settings
    settings = NULL,

    #' @description Check if organizations are defined.
    check_for_organizations = function() {
      if (is.null(private$orgs)) {
        cli::cli_abort(c(
          "Please specify first organizations for [{private$engine$rest$api_url}] with `set_organizations()`."
        ))
      }
    }
  )
)
