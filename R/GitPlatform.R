#' @importFrom R6 R6Class
#' @importFrom rlang expr
#' @importFrom cli cli_alert_danger cli_alert_success

#' @title A GitHost superclass

GitHost <- R6::R6Class("GitHost",
  public = list(

    #' @field orgs
    orgs = NULL,

    #' @field engines
    engines = list(
      rest = NULL,
      graphql = NULL
    ),

    #' @field parameters
    parameters = NULL,

    #' @field git_service A character specifying whether GitHub or GitLab.
    git_service = NULL,

    #' @description Create a new `GitPlatform` object
    #' @param orgs A character vector of organisations (owners of repositories
    #'   in case of GitHub and groups of projects in case of GitLab).
    #' @param parameters
    #' @param rest_engine
    #' @return A new `GitPlatform` object
    initialize = function(orgs = NA,
                          parameters = NA,
                          rest_engine = NA,
                          graphql_engine = NA) {
      self$engines$rest <- rest_engine
      self$engines$graphql <- graphql_engine
      if (is.null(orgs)) {
        cli::cli_alert_warning("No organizations specified.")
      } else {
        orgs <- self$engines$rest$check_organizations(orgs)
      }
      self$orgs <- orgs
      self$parameters <- parameters
    },

    #' @description  A method to list all repositories for an organization, a
    #'   team or by a keyword.
    #' @return A data.frame of repositories.
    get_repos = function() {

      private$check_for_organizations()

      repos_dt <- purrr::map(self$orgs, function(org) {

        repos_table <- purrr::map(self$engines, ~ .$get_repos(
          org = org,
          parameters = self$parameters
        )) %>%
          data.table::rbindlist()

        return(repos_table)
        cli::cli_alert_info("Number of repositories: {nrow(repos_table)}")

      }) %>%
        rbindlist(use.names = TRUE)

      return(repos_dt)
    },

    #' @description A method to get information on commits.
    #' @param date_from A starting date to look commits for.
    #' @param date_until An end date to look commits for.
    #' @return A data.frame of commits
    get_commits = function(date_from,
                           date_until = Sys.Date()
                           ) {
      private$check_for_organizations()

      commits_dt <- purrr::map(self$orgs, function(org) {
        commits_table <- purrr::map(self$engines, ~ .$get_commits(
          org = org,
          date_from = date_from,
          date_until = date_until,
          parameters = self$parameters
        )) %>%
          data.table::rbindlist()

        return(commits_table)
      }) %>%
        rbindlist()

      return(commits_dt)
    }

  ),
  private = list(

    #' @description Check if organizations are defined.
    check_for_organizations = function() {
      if (is.null(self$orgs)) {
        cli::cli_abort(c(
          "Please specify first organizations for [{self$rest_engine$rest_api_url}] with `set_organizations()`."
        ))
      }
    }
  )
)
