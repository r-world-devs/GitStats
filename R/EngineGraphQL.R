#' @noRd
#' @importFrom dplyr distinct mutate relocate filter
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
     #' @param scan_all A boolean.
     initialize = function(gql_api_url = NA,
                           token = NA,
                           scan_all = FALSE) {
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

     #' @description Get information on users in the form of table
     #' @param users A character vector of users
     #' @return A table
     pull_users = function(users) {
       purrr::map(users, function(user) {
         private$pull_user(username = user) %>%
           private$prepare_user_table()
       }) %>%
         purrr::list_rbind()
     },

     #' @description A method to retrieve given files from all repositories for
     #'   an organization in a table format.
     #' @param org An organization.
     #' @param file_path A file path.
     #' @param pulled_repos Optional parameter to pass repository output object.
     #' @param settings A list of  `GitStats` settings.
     #' @return A table.
     pull_files = function(org, file_path, pulled_repos = NULL, settings) {
       if (!private$scan_all && settings$verbose) {
         cli::cli_alert_info("[Engine:{cli::col_yellow('GraphQL')}][org:{org}] Pulling {file_path} files...")
       }
       files_table <- private$pull_file_from_org(
         org = org,
         file_path = file_path,
         pulled_repos = pulled_repos
       ) %>%
         private$prepare_files_table(
           org = org,
           file_path = file_path
         )
       return(files_table)
     },

     #' @description Method to get releases.
     #' @param org An organization.
     #' @param repos A vector of repositories.
     #' @param date_from A starting date of releases.
     #' @param date_until An end date for releases.
     #' @param settings A list of  `GitStats` settings.
     #' @param storage A storage of `GitStats` object.
     #' @return A table of commits.
     pull_release_logs = function(org,
                                  repos = NULL,
                                  date_from,
                                  date_until = Sys.date(),
                                  settings,
                                  storage = NULL) {
       if (!private$scan_all && settings$verbose) {
         cli::cli_alert_info("[Engine:{cli::col_yellow('GraphQL')}][org:{org}] Pulling releases...")
       }
       if (is.null(repos)) {
         if (is.null(storage$repositories)) {
           repos_table <- self$pull_repos(
             org = org,
             settings = settings
           )
         } else {
           repos_table <- storage$repositories %>%
             dplyr::filter(
               organization == org
             )
         }
         repos_names <- repos_table$repo_name
       } else {
         repos_names <- repos
       }
       releases_table <- private$pull_releases_from_org(
         repos_names = repos_names,
         org = org
       ) %>%
         private$prepare_releases_table(org, date_from, date_until)

       return(releases_table)
     }

   ),
   private = list(
     # @field token A token authorizing access to API.
     token = NULL,

     # @field A boolean.
     scan_all = FALSE,

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
     },

     # @description A method to pull information on user.
     # @param username A login.
     # @return A user response.
     pull_user = function(username) {
       response <- NULL
       try(
         response <- self$gql_response(
           gql_query = self$gql_query$user(),
           vars = list("user" = username)
         )
       )
       return(response)
     }
   )
)
