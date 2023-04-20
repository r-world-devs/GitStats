#' @importFrom httr2 request req_headers req_perform resp_body_json
#' @importFrom purrr keep
#'
#' @title A EngineGraphQL class
#' @description A superclass for methods wraping GraphQL API responses.

EngineGraphQL <- R6::R6Class("EngineGraphQL",
  inherit = Engine,
  public = list(

    #' @field git_service A character specifying whether GitHub or GitLab.
    git_service = NULL,

    #' @field gql_api_url A character, url of GraphQL API.
    gql_api_url = NULL,

    #' @field gql_query An environment for GraphQL queries.
    gql_query = NULL,

    #' @description Create a new `GraphQL` object
    #' @param token A token.
    #' @param gql_api_url A character, url of GraphQL API.
    #' @return A `GraphQL` object.
    initialize = function(token = NA,
                          gql_api_url = NA) {
      super$initialize(token = token)
      self$gql_api_url <- gql_api_url
    },

    #' @description Wrapper of GraphQL API request and response.
    #' @param gql_query A string with GraphQL query.
    #' @return A list.
    gql_response = function(gql_query) {
      httr2::request(paste0(self$gql_api_url, "?")) %>%
        httr2::req_headers("Authorization" = paste0("Bearer ", private$token)) %>%
        httr2::req_body_json(list(query = gql_query, variables = "null")) %>%
        httr2::req_perform() %>%
        httr2::resp_body_json()
    }

  ),
  private = list(

    #' @description Wrapper over building GraphQL query and response.
    #' @param org An organization.
    #' @param repo_cursor An end cursor for repos page.
    #' @return A list of repositories.
    pull_repos_page_from_org = function(org,
                                        repo_cursor = "") {
      repos_by_org_query <- self$gql_query$repos_by_org(
        org,
        repo_cursor = repo_cursor
      )
      response <- self$gql_response(
        gql_query = repos_by_org_query
      )
      return(response)
    }
  )
)
