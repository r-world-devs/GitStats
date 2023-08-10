#' @noRd
#' @description A helper class to cache and mock results.
Mocker <- R6::R6Class("Mocker",
  public = list(

    #' @field storage A list to store objects.
    storage = list(),

    #' @description Method to cache objects.
    cache = function(object = NULL) {
      object_name <- deparse(substitute(object))
      self$storage[[paste0(object_name)]] <- object
    },

    #' @description Method to retrieve objects.
    use = function(object_name) {
      self$storage[[paste0(object_name)]]
    }
  )
)

#' @noRd
#' @description A helper class for use in tests - it does not throw superfluous
#'   messages and does exactly what is needed for in tests.
TestHost <- R6::R6Class("TestHost",
  inherit = GitHost,
  public = list(
    initialize = function(orgs = NA,
                          token = NA,
                          api_url = NA) {
      private$api_url <- api_url
      if (grepl("https://", api_url) && grepl("github", api_url)) {
        private$engines$rest <- EngineRestGitHub$new(
          token = token,
          rest_api_url = api_url
        )
        private$engines$graphql <- EngineGraphQLGitHub$new(
          token = token,
          gql_api_url = private$set_gql_url(api_url)
        )
      } else if (grepl("https://", api_url) && grepl("gitlab|code", api_url)) {
        private$engines$rest <- EngineRestGitLab$new(
          token = token,
          rest_api_url = api_url
        )
        private$engines$graphql <- EngineGraphQLGitLab$new(
          token = token,
          gql_api_url = private$set_gql_url(api_url)
        )
      }
      private$orgs <- orgs
    }
  )
)

#' @noRd
#' @description A wrapper over creating `TestHost`.
create_testhost <- function(api_url = NULL,
                            token = NULL,
                            orgs = NULL,
                            mode = "") {
  test_host <- TestHost$new(
    api_url = api_url,
    token = token,
    orgs = orgs
  )
  if (mode == "private") {
    test_host <- environment(test_host$initialize)$private
  }
  return(test_host)
}

#' @noRd
#' @description A helper class to use in tests.
TestEngineRest <- R6::R6Class("TestEngineRest",
  inherit = EngineRest,
  public = list(
    initialize = function(token,
                          rest_api_url) {
      private$token <- token
      self$rest_api_url <- rest_api_url
    }
  )
)

#' @noRd
create_testrest <- function(rest_api_url = "https://api.github.com",
                            token,
                            mode = "") {
  test_rest <- TestEngineRest$new(
    token = token,
    rest_api_url = rest_api_url
  )
  if (mode == "private") {
    test_rest <- environment(test_rest$initialize)$private
  }
  return(test_rest)
}
