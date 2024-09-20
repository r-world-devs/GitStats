### GitHub

test_gql <- EngineGraphQL$new(
  gql_api_url = "https://api.github.com/graphql",
  token = Sys.getenv("GITHUB_PAT")
)

# public methods

test_that("`gql_response()` work as expected for GitHub", {
  gh_user_gql_response <- test_gql$gql_response(
    test_mocker$use("gh_user_query"),
    vars = list(user = "maciekbanas")
  )
  expect_user_gql_response(
    gh_user_gql_response
  )
  test_mocker$cache(gh_user_gql_response)
})

test_that("pull_user pulls GitHub user response", {
  mockery::stub(
    test_gql$pull_user,
    "self$gql_response",
    test_mocker$use("gh_user_gql_response")
  )
  gh_user_response <- test_gql$pull_user(username = "maciekbanas")
  expect_user_gql_response(
    gh_user_response
  )
  test_mocker$cache(gh_user_response)
})

### GitLab

test_gql <- EngineGraphQL$new(
  gql_api_url = "https://gitlab.com/api/graphql",
  token = Sys.getenv("GITLAB_PAT_PUBLIC")
)

# public methods

test_that("`gql_response()` work as expected for GitLab", {
  gl_user_gql_response <- test_gql$gql_response(
    test_mocker$use("gl_user_query"),
    vars = list(user = "maciekbanas")
  )
  expect_user_gql_response(
    gl_user_gql_response
  )
  test_mocker$cache(gl_user_gql_response)
})


test_that("pull_user pulls GitLab user response", {
  mockery::stub(
    test_gql$pull_user,
    "self$gql_response",
    test_mocker$use("gl_user_gql_response")
  )
  gl_user_response <- test_gql$pull_user(username = "maciekbanas")
  expect_user_gql_response(
    gl_user_response
  )
  test_mocker$cache(gl_user_response)
})
