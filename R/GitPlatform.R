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

      private$check_for_organizations()

      repos_dt <- purrr::map(self$orgs, function(org) {
        if (by %in% c("org", "team")) {
          repos_table <- self$graphql_engine$get_repos_by_org(
            org = org,
            by = by,
            team = team,
            language = language
          )
          cli::cli_alert_info("Number of repositories: {nrow(repos_table)}")
        }

        if (by == "phrase") {
          repos_table <- self$rest_engine$get_repos_by_phrase(
            phrase = phrase,
            org = org,
            language = language
          )
          cli::cli_alert_info(paste0("\n On ", self$git_service,
                              " [", org, "] found ",
                              nrow(repos_table), " repositories."))
        }
        return(repos_table)
      }) %>%
        rbindlist(use.names = TRUE)

      return(repos_dt)
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
        withCallingHandlers({
          self$rest_engine$response(endpoint = check_endpoint,
                                    token = token)
          },
          message = function(m) {
            if (grepl("401", m)) {
              cli::cli_abort(c(
                "i" = "Token provided for ... is invalid.",
                "x" = "Host will not be passed to `GitStats` object."
              ))
            }
        })
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

    #' @description GraphQL url handler (if not provided).
    #' @param rest_api_url
    #' @return GraphQL API url.
    set_gql_url = function(rest_api_url) {
      paste0(gsub("/v+.*", "", rest_api_url), "/graphql")
    }
  )
)
