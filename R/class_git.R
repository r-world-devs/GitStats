#' @importFrom R6 R6Class

GitService <- R6::R6Class("GitService",
  public = list(
    rest_api_url = NULL,
    gql_api_url = NULL
  ),
  private = list(
    token = NULL
  )
)
