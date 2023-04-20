#' @noRd
#' @description A helper class for use in tests - it does not throw superfluous
#'   messages and does exactly what is needed for in tests.
TestHost <- R6::R6Class("TestHost",
  inherit = GitPlatform,
  public = list(
    rest_engine = NULL,
    orgs = NULL,
    initialize = function(rest_api_url = NA,
                          token = NA,
                          orgs = NA) {
      self$rest_engine <- EngineRest$new(
        rest_api_url = rest_api_url,
        token = token
      )
      self$orgs <- orgs
    }
  )
)

#' @noRd
#' @description A wrapper over creating `TestHost`.
create_testhost <- function(rest_api_url = NULL,
                            token = NULL,
                            orgs = NULL,
                            mode = "") {
  test_host <- TestHost$new(
    rest_api_url = rest_api_url,
    token = token,
    orgs = orgs
  )
  if (!is.null(rest_api_url)) {
    if (grepl("github", rest_api_url)) {
      class(test_host) <- "GitHub"
    } else if (grepl("gitlab", rest_api_url)) {
      class(test_host) <- "GitLab"
    }
  }
  if (mode == "private") {
    test_host <- environment(test_host$initialize)$private
  }
  return(test_host)
}

#' @noRd
#' @description A helper class for use in tests - it does not throw superfluous
#'   messages and does exactly what is needed for in tests.
TestGitHub <- R6::R6Class("TestGitHub",
  inherit = GitHub,
  public = list(
    rest_engine = NULL,
    orgs = NULL,
    initialize = function(rest_api_url = NA,
                          gql_api_url = NA,
                          token = NA,
                          orgs = NA) {
      self$rest_engine <- EngineRestGitHub$new(
        rest_api_url = rest_api_url,
        token = token
      )
      self$graphql_engine <- EngineGraphQLGitHub$new(
        gql_api_url = gql_api_url,
        token = token
      )
      self$git_service <- "GitHub"
      self$orgs <- orgs
    }
  )
)

#' @noRd
#' @description A wrapper over creating `TestGitHub`.
create_testgh <- function(rest_api_url = NULL,
                          gql_api_url = NULL,
                          token = NULL,
                          orgs = NULL,
                          mode = "") {
  test_gh <- TestGitHub$new(
    rest_api_url = rest_api_url,
    gql_api_url = gql_api_url,
    token = token,
    orgs = orgs
  )
  if (mode == "private") {
    test_gh <- environment(test_gh$initialize)$private
  }
  return(test_gh)
}

#' @noRd
#' @description A helper class for use in tests - it does not throw superfluous
#'   messages and does exactly what is needed for in tests.
TestGitLab <- R6::R6Class("TestGitLab",
  inherit = GitLab,
  public = list(
    rest_engine = NULL,
    orgs = NULL,
    initialize = function(rest_api_url = NA,
                          gql_api_url = NA,
                          token = NA,
                          orgs = NA) {
      self$rest_engine <- EngineRestGitLab$new(
        rest_api_url = rest_api_url,
        token = token
      )
      self$graphql_engine <- EngineGraphQLGitLab$new(
        gql_api_url = gql_api_url,
        token = token
      )
      self$git_service <- "GitLab"
      self$orgs <- orgs
    }
  )
)

#' @noRd
#' @description A wrapper over creating `TestGitLab`.
create_testgl <- function(rest_api_url = NULL,
                          gql_api_url = NULL,
                          token = NULL,
                          orgs = NULL,
                          mode = "") {
  test_gl <- TestGitLab$new(
    rest_api_url = rest_api_url,
    gql_api_url = gql_api_url,
    token = token,
    orgs = orgs
  )
  if (mode == "private") {
    test_gl <- environment(test_gl$initialize)$private
  }
  return(test_gl)
}
