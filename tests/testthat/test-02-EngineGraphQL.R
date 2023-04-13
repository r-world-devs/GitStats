test_gql <- EngineGraphQL$new(gql_api_url = "https://api.github.com/graphql",
                              token = Sys.getenv("GITHUB_PAT"))

test_that("gql response work as expected", {
  commits_by_repo_query <- test_mock$commits_by_repo_query
  commits_by_repo_gql_response <- test_gql$gql_response(commits_by_repo_query)
  expect_snapshot(
    commits_by_repo_gql_response
  )
  test_mock$mock(
    commits_by_repo_gql_response = commits_by_repo_gql_response
  )
})

