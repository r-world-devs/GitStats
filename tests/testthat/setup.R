integration_tests_skipped <- Sys.getenv("GITSTATS_INTEGRATION_TEST_SKIPPED", unset = "true") |>
  as.logical()

if (integration_tests_skipped) {
  github_token <- NULL
  github_org <- "test_org"
  gitlab_group <- "test_group"
} else {
  github_token <- Sys.getenv("GITHUB_PAT")
  github_org <- "r-world-devs"
  gitlab_group <- "mbtests"
}

test_mocker <- Mocker$new()

test_gitstats <- create_test_gitstats(hosts = 2)
test_gitstats_priv <- create_test_gitstats(hosts = 2, priv_mode = TRUE)

test_gqlquery_gh <- GQLQueryGitHub$new()
test_gqlquery_gl <- GQLQueryGitLab$new()

test_rest_github <- TestEngineRestGitHub$new(
  rest_api_url = "https://api.github.com",
  token = github_token
)
test_rest_github_priv <- environment(test_rest_github$initialize)$private

test_graphql_github <- EngineGraphQLGitHub$new(
  gql_api_url = "https://api.github.com/graphql",
  token = github_token
)
test_graphql_github_priv <- environment(test_graphql_github$initialize)$private

test_rest_gitlab <- TestEngineRestGitLab$new(
  rest_api_url = "https://gitlab.com/api/v4",
  token = NULL
)
test_rest_gitlab_priv <- environment(test_rest_gitlab$initialize)$private

test_graphql_gitlab <- EngineGraphQLGitLab$new(
  gql_api_url = "https://gitlab.com/api/graphql",
  token = NULL
)
test_graphql_gitlab_priv <- environment(test_graphql_gitlab$initialize)$private

github_testhost <- create_github_testhost(
  orgs = github_org,
  token = github_token
)

github_testhost_priv <- create_github_testhost(
  orgs = github_org,
  token = github_token,
  mode = "private"
)

gitlab_testhost <- create_gitlab_testhost(
  orgs = gitlab_group
)

gitlab_testhost_priv <- create_gitlab_testhost(
  orgs = gitlab_group,
  mode = "private"
)
