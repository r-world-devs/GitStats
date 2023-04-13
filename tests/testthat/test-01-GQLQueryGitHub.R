test_gqlquery_gh <- GQLQueryGitHub$new()

test_that("commits_by_repo query is built properly", {
  commits_by_repo_query <-
    test_gqlquery_gh$commits_by_repo(
      org = "r-world-devs",
      repo = "GitStats",
      since = "2023-01-01T00:00:00Z",
      until = "2023-02-28T00:00:00Z"
    )
  expect_snapshot(
    commits_by_repo_query
  )
  test_mock$mock(
    commits_by_repo_query = commits_by_repo_query
  )
})

