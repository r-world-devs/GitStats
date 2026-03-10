# ---- Integration test utils ----

skip_integration_tests <- function() {
  Sys.setenv(GITSTATS_INTEGRATION_TEST_SKIPPED = "true")
}

unskip_integration_tests <- function() {
  Sys.setenv(GITSTATS_INTEGRATION_TEST_SKIPPED = "false")
}

are_integrations_tests_skipped <- function() {
  as.logical(Sys.getenv("GITSTATS_INTEGRATION_TEST_SKIPPED"))
}

# ---- Mocker ----

Mocker <- R6::R6Class("Mocker",
  public = list(

    storage = list(),

    cache = function(object = NULL) {
      object_name <- deparse(substitute(object))
      self$storage[[paste0(object_name)]] <- object
    },

    use = function(object_name) {
      self$storage[[paste0(object_name)]]
    }
  )
)

# ---- Test host classes and factories ----

GitHostGitHubTest <- R6::R6Class(
  classname = "GitHostGitHubTest",
  inherit = GitHostGitHub,
  public = list(
    initialize = function(orgs = NA,
                          repos = NA,
                          token = NA,
                          host = NA) {
      private$set_api_url(host)
      private$set_web_url(host)
      private$set_endpoints()
      private$is_public <- FALSE
      private$token <- token
      private$set_graphql_url()
      private$set_orgs_and_repos_mocked(orgs, repos)
      private$setup_test_engines()
      private$set_searching_scope(orgs, repos, verbose = FALSE)
    }
  ),
  private = list(
    set_orgs_and_repos_mocked = function(orgs, repos) {
      if (is.null(orgs) && is.null(repos)) {
        private$scan_all <- TRUE
      } else {
        private$orgs <- orgs
      }
      if (!is.null(repos)) {
        private$repos <- repos
        orgs_repos <- private$extract_repos_and_orgs(repos)
        private$orgs <- names(orgs_repos)
      }
    },
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

GitHostGitLabTest <- R6::R6Class(
  classname = "GitHostGitLabTest",
  inherit = GitHostGitLab,
  public = list(
    initialize = function(orgs = NA,
                          repos = NA,
                          token = NA,
                          host = NA) {
      private$set_api_url(host)
      private$set_web_url(host)
      private$set_endpoints()
      private$check_if_public(host)
      private$token <- token
      private$set_graphql_url()
      private$set_orgs_and_repos_mocked(orgs, repos)
      private$setup_test_engines()
      private$set_searching_scope(orgs, repos, verbose = FALSE)
    }
  ),
  private = list(
    set_orgs_and_repos_mocked = function(orgs, repos) {
      private$orgs <- orgs
      if (!is.null(repos)) {
        private$repos <- repos
        orgs_repos <- private$extract_repos_and_orgs(repos)
        private$orgs <- names(orgs_repos)
      }
    },
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

create_github_testhost <- function(host  = NULL,
                                   orgs  = NULL,
                                   repos = NULL,
                                   token = NULL,
                                   mode = "") {
  suppressMessages(
    test_host <- GitHostGitHubTest$new(
      host  = host,
      token = token,
      orgs  = orgs,
      repos = repos
    )
  )
  if (mode == "private") {
    test_host <- environment(test_host$initialize)$private
  }
  return(test_host)
}

create_github_testhost_all <- function(host  = NULL,
                                       orgs  = NULL,
                                       repos = NULL,
                                       token = NULL,
                                       mode = "") {
  suppressMessages(
    test_host <- GitHostGitHubTest$new(
      host  = NULL,
      token = token,
      orgs  = orgs,
      repos = repos
    )
  )
  test_host$.__enclos_env__$private$orgs <- NULL
  test_host$.__enclos_env__$private$scan_all <- TRUE
  if (mode == "private") {
    test_host <- environment(test_host$initialize)$private
  }
  return(test_host)
}

create_gitlab_testhost <- function(host  = NULL,
                                   orgs  = NULL,
                                   repos = NULL,
                                   token = NULL,
                                   mode = "") {
  suppressMessages(
    test_host <- GitHostGitLabTest$new(
      host  = NULL,
      token = token,
      orgs  = orgs,
      repos = repos
    )
  )
  if (mode == "private") {
    test_host <- environment(test_host$initialize)$private
  }
  return(test_host)
}

# ---- Test engine classes and factories ----

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

# ---- Random data generators ----

generate_random_timestamps <- function(n, start_year, end_year) {
  start_date <- as.POSIXct(paste0(start_year, "-01-01 00:00:00"), tz = "UTC")
  end_date <- as.POSIXct(paste0(end_year, "-12-31 23:59:59"), tz = "UTC")

  random_times <- runif(n, min = as.numeric(start_date), max = as.numeric(end_date))
  random_datetimes <- as.POSIXct(random_times, origin = "1970-01-01", tz = "UTC")

  formatted_dates <- format(random_datetimes, "%Y-%m-%dT%H:%M:%SZ")

  return(formatted_dates)
}

generate_random_names <- function(n, names) {
  random_names <- sample(names, size = n, replace = TRUE)
  return(random_names)
}
