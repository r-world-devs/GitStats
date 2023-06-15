#' @importFrom dplyr distinct mutate relocate filter
#' @importFrom progress progress_bar
#'
#' @title A EngineGraphQL class
#' @description A class for methods wrapping GitHub's GraphQL API responses.
EngineGraphQL <- R6::R6Class("EngineGraphQL",
   public = list(

     #' @field gql_api_url A character, url of GraphQL API.
     gql_api_url = NULL,

     #' @field gql_query An environment for GraphQL queries.
     gql_query = NULL,

     #' @description Create `EngineGraphQL` object.
     #' @param gql_api_url GraphQL API url.
     #' @param token A token.
     initialize = function(gql_api_url,
                           token) {
       private$token <- token
       self$gql_api_url <- gql_api_url
     },

     #' @description Wrapper of GraphQL API request and response.
     #' @param gql_query A string with GraphQL query.
     #' @param vars A list of named variables.
     #' @return A list.
     gql_response = function(gql_query, vars = "null") {
       httr2::request(paste0(self$gql_api_url, "?")) %>%
         httr2::req_headers("Authorization" = paste0("Bearer ", private$token)) %>%
         httr2::req_body_json(list(query = gql_query, variables = vars)) %>%
         httr2::req_perform() %>%
         httr2::resp_body_json()
     }

   ),
   private = list(
     # @field token A token authorizing access to API.
     token = NULL,

     #' @description A method to pull information on user.
     #' @param username A login.
     #' @return A user response.
     pull_user = function(username) {
       response <- self$gql_response(
         gql_query = self$gql_query$user(),
         vars = list("user" = username)
       )
       return(response)
     }
   )
)
