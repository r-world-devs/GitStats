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
    repo = "GitStats"
  )
  expect_github_issues_page(issues_page)
  test_mocker$cache(issues_page)
})

test_that("issues page with cursor is pulled from repository", {
  if (!integration_tests_skipped) {
    issues_page <- test_graphql_github_priv$get_issues_page_from_repo(
      org = "r-world-devs",
      repo = "GitStats",
      issues_cursor = "Y3Vyc29yOnYyOpK5MjAyNC0xMS0wN1QxMzowNTowOSswMTowMM6dZ-dm"
    )
    expect_github_issues_page(issues_page)
  }
})

test_that("`get_issues_from_one_repo()` prepares formatted list", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_github_priv$get_issues_from_one_repo,
      "private$get_issues_page_from_repo",
      test_mocker$use("issues_page")
    )
  }
  issues_from_repo <- test_graphql_github_priv$get_issues_from_one_repo(
    org = "r-world-devs",
    repo = "GitStats"
  )
  expect_issues_full_list(
    issues_from_repo
  )
  test_mocker$cache(issues_from_repo)
})

test_that("`get_issues_from_repos()` pulls issues from repos", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_github$get_issues_from_repos,
      "private$get_issues_from_one_repo",
      test_mocker$use("issues_from_repo")
    )
  }
  issues_from_repos <- test_graphql_github$get_issues_from_repos(
    org = "r-world-devs",
    repo = c("GitStats", "GitAI"),
    progress = FALSE
  )
  expect_issues_full_list(
    issues_from_repos[[1]]
  )
  test_mocker$cache(issues_from_repos)
})


test_that("`prepare_issues_table()` prepares issues table", {
  gh_issues_table <- test_graphql_github$prepare_issues_table(
    repos_list_with_issues = test_mocker$use("issues_from_repos"),
    org = "r-world-devs"
  )
  expect_issues_table(
    gh_issues_table
  )
  test_mocker$cache(gh_issues_table)
})
