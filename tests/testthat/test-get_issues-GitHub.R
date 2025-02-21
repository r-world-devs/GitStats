test_that("issues_by_repo GitHub query is built properly", {
  gh_issues_from_repo_query <-
    test_gqlquery_gh$issues_from_repo()
  expect_snapshot(
    gh_issues_from_repo_query
  )
})

test_that("issues page is pulled from repository", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_github_priv$get_issues_page_from_repo,
      "self$gql_response",
      test_fixtures$github_issues_response
    )
  }
  issues_page <- test_graphql_github_priv$get_issues_page_from_repo(
    org = "r-world-devs",
    repo = "GitStats",
    since = "2024-01-01",
    until = "2025-01-01"
  )
browser()
  test_mocker$cache(issues_page)
})
