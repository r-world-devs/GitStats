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
    #' @param rest_api_url A url of rest API.
    #' @param gql_api_url A url of GraphQL API.
    #' @param orgs A character vector of organisations (owners of repositories
    #'   in case of GitHub and groups of projects in case of GitLab).
    #' @return A new `GitPlatform` object
    initialize = function(rest_api_url = NA,
                          gql_api_url = NA,
                          orgs = NA) {
      if (is.null(orgs)) {
        cli::cli_alert_warning("No organizations specified.")
      } #else {
      #   orgs <- private$check_orgs(orgs)
      # }
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

    #' @description GraphQL url handler (if not provided).
    #' @param rest_api_url
    #' @return GraphQL API url.
    set_gql_url = function(rest_api_url) {
      paste0(gsub("/v+.*", "", rest_api_url), "/graphql")
    },

    #' @description Check if an organization exists
    #' @param orgs A character vector of organizations
    #' @return orgs or NULL.
    check_orgs = function(orgs) {
      orgs <- purrr::map(orgs, function(org) {
        org_endpoint <- if (self$git_service == "GitHub") {
          "/orgs/"
        } else if (self$git_service == "GitLab") {
          "/groups/"
        }
        withCallingHandlers({
          self$rest_engine$response(endpoint = paste0(self$rest_api_url, org_endpoint, org))
        },
        message = function(m) {
          if (grepl("404", m)) {
            if (grepl(" ", org) & self$git_service == "GitLab") {
              cli::cli_alert_danger("Group name passed in a wrong way: {org}")
              cli::cli_alert_warning("If you are using `GitLab`, please type your group name as you see it in `url`.")
              cli::cli_alert_info("E.g. do not use spaces. Group names as you see on the page may differ from their 'address' name.")
            } else {
              cli::cli_alert_danger("Organization you provided does not exist. Check spelling in: {org}")
            }
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
