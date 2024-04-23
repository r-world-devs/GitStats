#' @noRd
#' @description A class for methods wrapping GitHub's GraphQL API responses.
EngineGraphQL <- R6::R6Class("EngineGraphQL",
   inherit = Engine,

   public = list(

     #' @field gql_api_url A character, url of GraphQL API.
     gql_api_url = NULL,

     #' @field gql_query An environment for GraphQL queries.
     gql_query = NULL,

     #' @description Create `EngineGraphQL` object.
     #' @param gql_api_url GraphQL API url.
     #' @param token A token.
     #' @param scan_all A boolean.
     initialize = function(gql_api_url = NA,
                           token = NA,
                           scan_all = FALSE) {
       private$engine <- "graphql"
       self$gql_api_url <- gql_api_url
       private$token <- token
       private$scan_all <- scan_all
     },

     #' @description Wrapper of GraphQL API request and response.
     #' @param gql_query A string with GraphQL query.
     #' @param vars A list of named variables.
     #' @return A list.
     gql_response = function(gql_query, vars = "null") {
       response <- private$perform_request(
         gql_query = gql_query,
         vars = vars
       )
       response_list <- httr2::resp_body_json(response)
       return(response_list)
     },

     # A method to pull information on user.
     pull_user = function(username) {
       response <- tryCatch({
         self$gql_response(
           gql_query = self$gql_query$user(),
           vars = list("user" = username)
         )
       }, error = function(e) {
         NULL
       })
       return(response)
     }
   ),
   private = list(

     # GraphQL method for pulling response from API
     perform_request = function(gql_query, vars) {
       response <- httr2::request(paste0(self$gql_api_url, "?")) %>%
         httr2::req_headers("Authorization" = paste0("Bearer ", private$token)) %>%
         httr2::req_body_json(list(query = gql_query, variables = vars)) %>%
         httr2::req_retry(
           is_transient = ~ httr2::resp_status(.x) == "400|502",
           max_seconds = 60
         ) %>%
         httr2::req_perform()
       return(response)
     }
   )
)
