test_gql <- EngineGraphQL$new(gql_api_url = "https://api.github.com/graphql",
                              token = Sys.getenv("GITHUB_PAT"))

test_that("`gql_response()` work as expected", {
  commits_by_repo_query <- test_mock$mocker$commits_by_repo_query
  commits_by_repo_gql_response <- test_gql$gql_response(commits_by_repo_query)
  expect_snapshot(
    commits_by_repo_gql_response
  )
  test_mock$mock(commits_by_repo_gql_response)

  repos_by_org_query <- test_mock$mocker$repos_by_org_query
  repos_by_org_gql_response <- test_gql$gql_response(repos_by_org_query)
  expect_type(
    repos_by_org_gql_response,
    "list"
  )
  expect_list_contains(
    repos_by_org_gql_response,
    "data"
  )
  expect_list_contains(
    repos_by_org_gql_response$data$repositoryOwner$repositories$nodes[[1]],
    c("id", "name", "stars", "forks", "created_at", "last_push",
      "last_activity_at", "languages", "issues_open", "issues_closed",
      "contributors", "repo_url")
  )
  test_mock$mock(repos_by_org_gql_response)
})

