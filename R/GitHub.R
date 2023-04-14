#' @importFrom R6 R6Class
#' @importFrom dplyr mutate rename
#' @importFrom magrittr %>%
#' @importFrom progress progress_bar
#' @importFrom rlang %||%
#' @importFrom cli cli_alert cli_alert_success col_green
#'
#' @title A GitHub API Client class
#' @description An object with methods to obtain information form GitHub API.

GitHub <- R6::R6Class("GitHub",
  inherit = GitPlatform,
  cloneable = FALSE,
  public = list(

    #' @description Create a new `GitHub` object
    #' @param rest_api_url A url of rest API.
    #' @param gql_api_url A url of GraphQL API.
    #' @param token A token.
    #' @param orgs A character vector of organisations (owners of repositories
    #'   in case of GitHub).
    #' @return A new `GitHub` object
    initialize = function(rest_api_url = NA,
                          gql_api_url = NA,
                          token = NA,
                          orgs = NA) {
      if (is.na(gql_api_url)) {
        gql_api_url <- private$set_gql_url(rest_api_url)
      }
      self$rest_engine <- EngineRestGitHub$new(
        token = token,
        rest_api_url = rest_api_url
      )
      self$graphql_engine <- EngineGraphQLGitHub$new(
        token = token,
        gql_api_url = gql_api_url
      )
      self$git_service <- "GitHub"
      super$initialize(orgs = orgs)
    },

    #' @description A method to get information on commits.
    #' @param date_from A starting date to look commits for.
    #' @param date_until An end date to look commits for.
    #' @param by A character, to choose between: \itemize{\item{org -
    #'   organizations (owners of repositories or project groups)} \item{team -
    #'   A team} \item{phrase - A keyword in code blobs.}}
    #' @param team A list of team members.
    #' @return A data.frame of commits
    get_commits = function(date_from,
                           date_until = Sys.Date(),
                           by,
                           team) {

      private$check_for_organizations()

      commits_dt <- purrr::map(self$orgs, function(org) {
        repos_table <- self$graphql_engine$get_repos_from_org(
          org = org
        )
        commits <- self$graphql_engine$get_commits_from_org(
          org = org,
          repos_table = repos_table,
          date_from = date_from,
          date_until = date_until,
          by = by,
          team = team
        )
        commits
      }) %>%
        rbindlist()

      return(commits_dt)
    },

    #' @description A print method for a GitHub object
    print = function() {
      cat("GitHub API Client", sep = "\n")
      cat(paste0(" url: ", self$rest_api_url), sep = "\n")
      orgs <- paste0(self$orgs, collapse = ", ")
      cat(paste0(" orgs: ", orgs), sep = "\n")
    }
  ),

  private = list(
    #' @description Check if an organization exists
    #' @param orgs A character vector of organizations
    #' @return orgs or NULL.
    check_organizations = function(orgs) {
      orgs <- purrr::map(orgs, function(org) {
        org_endpoint <- "/orgs/"
        withCallingHandlers({
          self$rest_engine$response(endpoint = paste0(self$rest_engine$rest_api_url, org_endpoint, org))
        },
        message = function(m) {
          if (grepl("404", m)) {
            cli::cli_alert_danger("Organization you provided does not exist. Check spelling in: {org}")
            org <<- NULL
          }
        })
        return(org)
      }) %>%
        purrr::keep(~length(.) > 0) %>%
        unlist()

      if (length(orgs) == 0) {
        return(NULL)
      }
      orgs
    }
  )
)
