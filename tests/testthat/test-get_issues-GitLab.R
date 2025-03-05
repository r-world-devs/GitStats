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

test_that("`get_issues_from_repos()` pulls issues from repos", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_gitlab$get_issues_from_repos,
      "private$get_issues_from_one_repo",
      test_mocker$use("issues_from_repo")
    )
  }
  issues_from_repos <- test_graphql_gitlab$get_issues_from_repos(
    org = "mbtests",
    repo = c("gitstatstesting", "graphql_tests"),
    progress = FALSE
  )
  expect_issues_full_list(
    issues_from_repos[[1]]
  )
  test_mocker$cache(issues_from_repos)
})

test_that("`prepare_issues_table()` prepares issues table", {
  gl_issues_table <- test_graphql_gitlab$prepare_issues_table(
    repos_list_with_issues = test_mocker$use("issues_from_repos"),
    org = "r-world-devs"
  )
  expect_issues_table(
    gl_issues_table
  )
  test_mocker$cache(gl_issues_table)
})
