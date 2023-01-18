#' @importFrom R6 R6Class

GitClient <- R6::R6Class("GitClient",
  public = list(
    rest_api_url = NULL,
    gql_api_url = NULL
  ),
  private = list(
    token = NULL
  )
)
