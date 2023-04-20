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
  test_mock$mock(commits_by_repo_query)
})

test_that("repos_by_org query is built properly", {
  repos_by_org_query <-
    test_gqlquery_gh$repos_by_org(
      org = "r-world-devs"
    )
  expect_snapshot(
    repos_by_org_query
  )
  test_mock$mock(repos_by_org_query)
})
