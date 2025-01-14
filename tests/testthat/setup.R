test_mocker <- Mocker$new()

test_gitstats <- create_test_gitstats(hosts = 2)
test_gitstats_priv <- create_test_gitstats(hosts = 2, priv_mode = TRUE)

test_gqlquery_gh <- GQLQueryGitHub$new()
test_gqlquery_gl <- GQLQueryGitLab$new()

test_rest_github <- TestEngineRestGitHub$new(
  rest_api_url = "https://api.github.com",
  token = NULL
)
test_rest_github_priv <- environment(test_rest_github$initialize)$private

test_graphql_github <- EngineGraphQLGitHub$new(
  gql_api_url = "https://api.github.com/graphql",
  token = NULL
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

github_testhost <- create_github_testhost(orgs = "test_org")

github_testhost_priv <- create_github_testhost(orgs = "test_org", mode = "private")

gitlab_testhost <- create_gitlab_testhost(orgs = "test_group")

gitlab_testhost_priv <- create_gitlab_testhost(orgs = "test_group", mode = "private")
