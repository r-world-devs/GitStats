test_that("issues_by_repo GitLab query is built properly", {
  gl_issues_from_repo_query <-
    test_gqlquery_gl$issues_from_repo()
  expect_snapshot(
    gl_issues_from_repo_query
  )
})

test_that("issues page is pulled from repository", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_gitlab_priv$get_issues_page_from_repo,
      "self$gql_response",
      test_fixtures$gitlab_issues_response
    )
  }
  issues_page <- test_graphql_gitlab_priv$get_issues_page_from_repo(
    org = "mbtests",
    repo = "gitstatstesting"
  )
  expect_gitlab_issues_page(issues_page)
  test_mocker$cache(issues_page)
})

test_that("`get_issues_from_one_repo()` prepares formatted list", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_gitlab_priv$get_issues_from_one_repo,
      "private$get_issues_page_from_repo",
      test_mocker$use("issues_page")
    )
  }
  issues_from_repo <- test_graphql_gitlab_priv$get_issues_from_one_repo(
    org = "mbtests",
    repo = "gitstatstesting"
  )
  expect_issues_full_list(
    issues_from_repo
  )
  test_mocker$cache(issues_from_repo)
})
