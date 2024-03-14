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
                          repos = NA,
                          token = NA,
                          api_url = NA) {
      private$api_url <- api_url
      private$host <- private$set_host_name()
      private$token <- token
      private$setup_test_engines()
      private$orgs <- orgs
      private$repos <- repos
    }
  ),
  private = list(
    setup_test_engines = function() {
      if (grepl("https://", private$api_url) && grepl("github", private$api_url)) {
        private$engines$rest <- TestEngineRestGitHub$new(
          token = private$token,
          rest_api_url = private$api_url
        )
        private$engines$graphql <- EngineGraphQLGitHub$new(
          token = private$token,
          gql_api_url = private$set_gql_url(private$api_url)
        )
      } else if (grepl("https://", private$api_url) && grepl("gitlab|code", private$api_url)) {
        private$engines$rest <- TestEngineRestGitLab$new(
          token = private$token,
          rest_api_url = private$api_url
        )
        private$engines$graphql <- EngineGraphQLGitLab$new(
          token = private$token,
          gql_api_url = private$set_gql_url(private$api_url)
        )
      }
    }
  )
)

#' @noRd
#' @description A wrapper over creating `TestHost`.
create_testhost <- function(api_url = NULL,
                            token = NULL,
                            orgs = NULL,
                            repos = NULL,
                            mode = "") {
  test_host <- TestHost$new(
    api_url = api_url,
    token = token,
    orgs = orgs,
    repos = repos
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
#' @description A helper class to use in tests.
TestEngineRestGitHub <- R6::R6Class("TestEngineRestGitHub",
                              inherit = EngineRestGitHub,
                              public = list(
                                initialize = function(token,
                                                      rest_api_url) {
                                  private$token <- token
                                  self$rest_api_url <- rest_api_url
                                }
                              )
)

#' @noRd
#' @description A helper class to use in tests.
TestEngineRestGitLab <- R6::R6Class("TestEngineRestGitLab",
                                    inherit = EngineRestGitLab,
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
