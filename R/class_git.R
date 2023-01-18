#' @importFrom R6 R6Class

#' @title A Git Service API Client superclass
#' @description  A superclass for GitHub and GitLab classes

GitService <- R6::R6Class("GitService",
  public = list(
    rest_api_url = NULL,
    gql_api_url = NULL,
    orgs = NULL,
    enterprise = NULL,

    #' @description Create a new `GitService` object
    #' @param rest_api_url A url of rest API.
    #' @param gql_api_url A url of GraphQL API.
    #' @param token A token.
    #' @param orgs A character vector of organisations (owners of repositories
    #'   in case of GitHub and groups of projects in case of GitLab).
    #' @return A new `GitService` object
    initialize = function(rest_api_url = NA,
                          gql_api_url = NA,
                          token = NA,
                          orgs = NA) {
      self$rest_api_url <- rest_api_url
      if (is.na(gql_api_url)) {
        private$set_gql_url()
      } else {
        self$gql_api_url <- gql_api_url
      }
      private$token <- token
      self$orgs <- orgs
      self$enterprise <- private$check_enterprise(self$rest_api_url)
    }
  ),
  private = list(
    token = NULL,


    #' @description GraphQL url handler (if not provided)
    set_gql_url = function(gql_api_url = self$gql_api_url,
                           rest_api_url = self$rest_api_url) {
      self$gql_api_url <- paste0(gsub("/v+.*", "", rest_api_url), "/graphql")
    },

    #' @description A helper to check if GitHub Client is Public or Enterprise.
    #' @param api_url A character, a url of API.
    #' @return A boolean.
    check_enterprise = function(api_url) {
      if (api_url != "https://api.github.com" && grepl("github", api_url)) {
        TRUE
      } else {
        FALSE
      }
    }
  )
)
