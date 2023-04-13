#' @importFrom R6 R6Class
#' @importFrom dplyr mutate
#' @importFrom magrittr %>%
#' @importFrom rlang %||%
#' @importFrom cli cli_alert cli_alert_success col_green
#'
#' @title A GitLab API Client class
#' @description An object with methods to obtain information form GitLab API.

GitLab <- R6::R6Class("GitLab",
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
        cli::cli_alert_info("Checking for GrahpQL API url.")
        gql_api_url <- private$set_gql_url(rest_api_url)
      }
      self$graphql_engine <- EngineGraphQLGitLab$new(
        token = token,
        gql_api_url = gql_api_url
      )
      self$rest_engine <- EngineRestGitLab$new(
        token = token,
        rest_api_url = rest_api_url
      )
      self$git_service <- "GitLab"
      super$initialize(orgs = orgs)
    },

    #' @description  A method to list all repositories for an organization, a
    #'   team or by a keyword.
    #' @param by A character, to choose between: \itemize{\item{org -
    #'   organizations (project groups)} \item{team -
    #'   A team} \item{phrase - A keyword in code blobs.}}
    #' @param team A list of team members.
    #' @param phrase A character to look for in code blobs. Obligatory if
    #'   \code{by} parameter set to \code{"phrase"}.
    #' @param language A character specifying language used in repositories.
    #' @return A data.frame of repositories.
    get_repos = function(by,
                         team,
                         phrase,
                         language) {

      language <- private$language_handler(language)

      repos_dt <- super$get_repos(
        by = by,
        team = team,
        phrase = phrase,
        language = language
      ) %>%
        self$rest_engine$get_repos_contributors()

      return(repos_dt)
    },

    #' @description A method to get information on commits.
    #' @param date_from A starting date to look commits for
    #' @param date_until An end date to look commits for
    #' @param by A character, to choose between: \itemize{\item{org -
    #'   organizations (owners of repositories or project groups)} \item{team -
    #'   A team} \item{phrase - A keyword in code blobs.}}
    #' @param team A list of team members.
    #' @return A data.frame of commits
    get_commits = function(date_from,
                           date_until = Sys.time(),
                           by,
                           team) {

      private$check_for_organizations()

      commits_dt <- purrr::map(self$orgs, function(org) {
        repos_table <- self$graphql_engine$pull_repos_from_org(
          org = org
        )
        self$rest_engine$get_commits_from_org(
          repos_table,
          org,
          date_from,
          date_until,
          by,
          team
        )
      }) %>% rbindlist()

      commits_dt
    },

    #' @description A print method for a GitLab object
    print = function() {
      cat("GitLab API Client", sep = "\n")
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
        org_endpoint <- "/groups/"
        withCallingHandlers({
          self$rest_engine$response(endpoint = paste0(self$rest_engine$rest_api_url, org_endpoint, org))
        },
        message = function(m) {
          if (grepl("404", m)) {
            cli::cli_alert_danger("Group name passed in a wrong way: {org}")
            cli::cli_alert_warning("If you are using `GitLab`, please type your group name as you see it in `url`.")
            cli::cli_alert_info("E.g. do not use spaces. Group names as you see on the page may differ from their 'address' name.")
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
    },

    #' @description Switcher to manage language names
    #' @details E.g. GitLab API will not filter
    #'   properly if you provide 'python' language
    #'   with small letter.
    #' @param language A character, language name
    #' @return A character
    language_handler = function(language) {
      if (!is.null(language)) {
        substr(language, 1, 1) <- toupper(substr(language, 1, 1))
      }

      language
    }
  )
)
