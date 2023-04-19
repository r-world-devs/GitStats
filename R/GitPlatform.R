#' @importFrom R6 R6Class
#' @importFrom rlang expr
#' @importFrom cli cli_alert_danger cli_alert_success

#' @title A Git Service API Client superclass
#' @description  A superclass for GitHub and GitLab classes

GitPlatform <- R6::R6Class("GitPlatform",
  public = list(

    #' @field graphql_engine A GraphQL engine.
    graphql_engine = NULL,

    #' @field rest_engine A REST engine.
    rest_engine = NULL,

    #' @field orgs A character vector of organizations.
    orgs = NULL,

    #' @field git_service A character specifying whether GitHub or GitLab.
    git_service = NULL,

    #' @description Create a new `GitPlatform` object
    #' @param orgs A character vector of organisations (owners of repositories
    #'   in case of GitHub and groups of projects in case of GitLab).
    #' @return A new `GitPlatform` object
    initialize = function(orgs = NA) {
      priv <- environment(self$rest_engine$initialize)$private
      private$check_token(priv$token)
      if (is.null(orgs)) {
        cli::cli_alert_warning("No organizations specified.")
      } else {
        orgs <- private$check_organizations(orgs)
      }
      self$orgs <- orgs
    }

  ),
  private = list(

    #' @description Check whether the token exists.
    #' @param token A token.
    #' @return A token.
    check_token = function(token) {
      if (nchar(token) == 0) {
        cli::cli_abort(c(
          "i" = "No token provided.",
          "x" = "Host will not be passed to `GitStats` object."
        ))
      } else if (nchar(token) > 0) {
        check_endpoint <- if ("GitLab" %in% class(self)) {
          paste0(self$rest_engine$rest_api_url, "/projects")
        } else if ("GitHub" %in% class(self)) {
          self$rest_engine$rest_api_url
        }
        withCallingHandlers(
          {
            self$rest_engine$response(
              endpoint = check_endpoint,
              token = token
            )
          },
          message = function(m) {
            if (grepl("401", m)) {
              cli::cli_abort(c(
                "i" = "Token provided for ... is invalid.",
                "x" = "Host will not be passed to `GitStats` object."
              ))
            }
          }
        )
      }
      return(invisible(token))
    },

    #' @description Check if organizations are defined.
    check_for_organizations = function() {
      if (is.null(self$orgs)) {
        cli::cli_abort(c(
          "Please specify first organizations for [{self$rest_engine$rest_api_url}] with `set_organizations()`."
        ))
      }
    },

    #' @description Filter repositories by contributors.
    #' @details If at least one member of a team is a contributor than a project
    #'   passes through the filter.
    #' @param repos_table A repository table to be filtered.
    #' @param team A list with team members.
    #' @return A repos table.
    filter_repos_by_team = function(repos_table,
                                    team) {
      cli::cli_alert_info("Filtering by team members.")
      team_logins <- purrr::map(team, ~ .$logins) %>%
        unlist()
      if (nrow(repos_table) > 0) {
        filtered_contributors <- purrr::keep(repos_table$contributors, function(row) {
          any(purrr::map_lgl(team_logins, ~ grepl(., row)))
        })
        repos_table <- repos_table %>%
          dplyr::filter(contributors %in% filtered_contributors)
      } else {
        repos_table
      }
      return(repos_table)
    },

    #' @description Filter repositories by contributors.
    #' @details If at least one member of a team is a contributor than a project
    #'   passes through the filter.
    #' @param repos_table A repository table to be filtered.
    #' @param language A language used in repository.
    #' @return A repos table.
    filter_repos_by_language = function(repos_table,
                                        language) {
      cli::cli_alert_info("Filtering by language.")
      filtered_langs <- purrr::keep(repos_table$languages, function(row) {
        grepl(language, row)
      })
      repos_table <- repos_table %>%
        dplyr::filter(languages %in% filtered_langs)
      return(repos_table)
    },

    #' @description GraphQL url handler (if not provided).
    #' @param rest_api_url REST API url.
    #' @return GraphQL API url.
    set_gql_url = function(rest_api_url) {
      paste0(gsub("/v+.*", "", rest_api_url), "/graphql")
    }
  )
)
