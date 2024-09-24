test_mocker <- Mocker$new()

test_gitstats <- create_test_gitstats(hosts = 2)
test_gitstats_priv <- create_test_gitstats(hosts = 2, priv_mode = TRUE)

test_gqlquery_gh <- GQLQueryGitHub$new()
test_gqlquery_gl <- GQLQueryGitLab$new()

test_rest_github <- EngineRestGitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT")
)
test_rest_github_priv <- environment(test_rest_github$initialize)$private

test_graphql_github <- EngineGraphQLGitHub$new(
  gql_api_url = "https://api.github.com/graphql",
  token = Sys.getenv("GITHUB_PAT")
)
test_graphql_github_priv <- environment(test_graphql_github$initialize)$private

test_rest_gitlab <- EngineRestGitLab$new(
  rest_api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT_PUBLIC")
)
test_rest_gitlab_priv <- environment(test_rest_gitlab$initialize)$private

test_graphql_gitlab <- EngineGraphQLGitLab$new(
  gql_api_url = "https://gitlab.com/api/graphql",
  token = Sys.getenv("GITLAB_PAT_PUBLIC")
)
test_graphql_gitlab_priv <- environment(test_graphql_gitlab$initialize)$private

github_testhost <- create_github_testhost(orgs = "r-world-devs")

github_testhost_priv <- create_github_testhost(orgs = "r-world-devs", mode = "private")

github_testhost_repos <- create_github_testhost(
  repos = c("openpharma/DataFakeR", "r-world-devs/GitStats", "r-world-devs/cohortBuilder")
)

github_testhost_repos_priv <- create_github_testhost(
  repos = c("openpharma/DataFakeR", "r-world-devs/GitStats", "r-world-devs/cohortBuilder"),
  mode = "private"
)

gitlab_testhost <- create_gitlab_testhost(orgs = "mbtests")

gitlab_testhost_priv <- create_gitlab_testhost(orgs = "mbtests", mode = "private")

gitlab_testhost_repos <- create_gitlab_testhost(
  repos = c("mbtests/gitstatstesting", "mbtests/gitstats-testing-2")
)

test_settings <- list(
  verbose = TRUE,
  storage = TRUE
)

test_settings_silence <- list(
  verbose = FALSE,
  storage = TRUE
)

test_settings_repo <- list(
  searching_scope = "repo",
  verbose = TRUE,
  storage = TRUE
)

if (nchar(Sys.getenv("GITHUB_PAT")) == 0) {
  cli::cli_abort(c(
    "x" = "You did not set up your GITHUB_PAT environment variable.",
    "i" = "If you wish to run tests for GitHub - set up your GITHUB_PAT enviroment variable (as a GitHub access token on github.com)."
  ))
}
if (nchar(Sys.getenv("GITHUB_PAT")) > 0) {
  tryCatch({
    httr2::request("https://api.github.com") %>%
    httr2::req_headers("Authorization" = paste0("Bearer ", Sys.getenv("GITHUB_PAT"))) %>%
    httr2::req_perform()
    },
  error = function(e) {
    if (grepl("401", e$message)) {
      cli::cli_abort(c(
        "x" = "Your GITHUB_PAT enviroment variable does not grant access. Please setup your GITHUB_PAT before running tests.",
        "i" = "If you wish to run tests for GitHub - set up your GITHUB_PAT enviroment variable (as a GitHub access token on github.com)."
      ))
    }
  })
}
if (nchar(Sys.getenv("GITLAB_PAT_PUBLIC")) == 0) {
  cli::cli_abort(c(
    "x" = "You did not set up your GITLAB_PAT_PUBLIC environment variable.",
    "i" = "If you wish to run tests for GitLab - set up your GITLAB_PAT_PUBLIC enviroment variable (as a GitLab access token on gitlab.com)."
  ))
}
if (nchar(Sys.getenv("GITLAB_PAT_PUBLIC")) > 0) {
  tryCatch({
    httr2::request("https://gitlab.com/api/v4/projects") %>%
      httr2::req_headers("Authorization" = paste0("Bearer ", Sys.getenv("GITLAB_PAT_PUBLIC"))) %>%
      httr2::req_perform()
  },
  error = function(e) {
    if (grepl("401", e$message)) {
      cli::cli_abort(c(
        "x" = "Your GITLAB_PAT_PUBLIC enviroment variable does not grant access. Please setup your GITLAB_PAT_PUBLIC before running tests.",
        "i" = "If you wish to run tests for GitLab - set up your GITLAB_PAT_PUBLIC enviroment variable (as a GitLab access token on gitlab.com)."
      ))
    }
  })
}
