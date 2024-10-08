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
GitHostGitHubTest <- R6::R6Class(
  classname = "GitHostGitHubTest",
  inherit = GitHostGitHub,
  public = list(
    initialize = function(orgs = NA,
                          repos = NA,
                          token = NA,
                          host = NA) {
      private$set_api_url(host)
      private$set_endpoints()
      private$check_if_public(host)
      private$set_token(token, verbose = FALSE)
      private$set_graphql_url()
      private$set_orgs_and_repos(orgs, repos, verbose = FALSE)
      private$setup_test_engines()
      private$set_searching_scope(orgs, repos, verbose = FALSE)
    }
  ),
  private = list(
    setup_test_engines = function() {
      private$engines$rest <- TestEngineRestGitHub$new(
        token = private$token,
        rest_api_url = private$api_url
      )
      private$engines$graphql <- EngineGraphQLGitHub$new(
        token = private$token,
        gql_api_url = private$set_graphql_url()
      )
    }
  )
)

#' @noRd
#' @description A helper class for use in tests - it does not throw superfluous
#'   messages and does exactly what is needed for in tests.
GitHostGitLabTest <- R6::R6Class(
  classname = "GitHostGitLabTest",
  inherit = GitHostGitLab,
  public = list(
    initialize = function(orgs = NA,
                          repos = NA,
                          token = NA,
                          host = NA) {
      private$set_api_url(host)
      private$set_endpoints()
      private$check_if_public(host)
      private$set_token(token, verbose = FALSE)
      private$set_graphql_url()
      private$set_orgs_and_repos(orgs, repos, verbose = FALSE)
      private$setup_test_engines()
      private$set_searching_scope(orgs, repos, verbose = FALSE)
    }
  ),
  private = list(
    setup_test_engines = function() {
      private$engines$rest <- TestEngineRestGitLab$new(
        token = private$token,
        rest_api_url = private$api_url
      )
      private$engines$graphql <- EngineGraphQLGitLab$new(
        token = private$token,
        gql_api_url = private$set_graphql_url()
      )
    }
  )
)

#' @noRd
create_github_testhost <- function(host = NULL,
                                   orgs = NULL,
                                   repos = NULL,
                                   mode = "") {
  suppressMessages(
    test_host <- GitHostGitHubTest$new(
      host = NULL,
      token = Sys.getenv("GITHUB_PAT"),
      orgs = orgs,
      repos = repos
    )
  )
  if (mode == "private") {
    test_host <- environment(test_host$initialize)$private
  }
  return(test_host)
}

#' @noRd
create_gitlab_testhost <- function(host = NULL,
                                   orgs = NULL,
                                   repos = NULL,
                                   mode = "") {
  suppressMessages(
    test_host <- GitHostGitLabTest$new(
      host = NULL,
      token = Sys.getenv("GITLAB_PAT_PUBLIC"),
      orgs = orgs,
      repos = repos
    )
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
      private$set_endpoints()
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
      private$set_endpoints()
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
