TestMock <- R6::R6Class("TestMock",
   public = list(

     commits_by_repo_query = NA,

     commits_by_repo_gql_response = NA,

     commits_page = NA,

     commits_from_repo = NA,

     commits_from_repos = NA,

     mock = function(commits_by_repo_query = NULL,
                     commits_by_repo_gql_response = NULL,
                     commits_page = NULL,
                     commits_from_repo = NULL,
                     commits_from_repos = NULL) {
       if (!is.null(commits_by_repo_query)) {
         self$commits_by_repo_query <- commits_by_repo_query
       }
       if (!is.null(commits_by_repo_gql_response)) {
         self$commits_by_repo_gql_response <- commits_by_repo_gql_response
       }
       if (!is.null(commits_page)) {
         self$commits_page <- commits_page
       }
       if (!is.null(commits_from_repo)) {
         self$commits_from_repo <- commits_from_repo
       }
       if (!is.null(commits_from_repos)) {
         self$commits_from_repos <- commits_from_repos
       }
     }
   )
)

