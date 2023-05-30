#' @title A EngineGraphQLGitLab class
#' @description A class for methods wrapping GitLab's GraphQL API responses.
EngineGraphQLGitLab <- R6::R6Class("EngineGraphQLGitLab",
   inherit = EngineGraphQL,
   public = list(

     #' @description Create `EngineGraphQLGitLab` object.
     #' @param gql_api_url GraphQL API url.
     #' @param token A token.
     initialize = function(gql_api_url,
                           token) {
       super$initialize(gql_api_url = gql_api_url,
                        token = token)
       self$gql_query <- GQLQueryGitLab$new()
     },

     get_repos = function(org,
                          settings) {
       NULL
     },

     get_repos_supportive = function(org,
                                     settings) {
       NULL
     }
   )
)
