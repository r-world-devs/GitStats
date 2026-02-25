test_that("pr_by_repo GitHub query is built properly", {
  gh_pr_from_repo_query <-
    test_gqlquery_gh$pull_requests_from_repo()
  expect_snapshot(
    gh_pr_from_repo_query
  )
})

test_that("`get_pr_page_from_repo()` pulls pr page from repository", {
  # mockery::stub(
  #   test_graphql_github_priv$get_pr_page_from_repo,
  #   "self$gql_response",
  #   test_fixtures$github_pr_response
  # )
  pr_page <- test_graphql_github_priv$get_pr_page_from_repo(
    org = "r-world-devs",
    repo = "GitStats"
  )

  expect_pr_gql_response(
    pr_page$data$repository$pullRequests$edges[[1]]
  )
  test_mocker$cache(pr_page)
})

test_that("`get_pr_from_one_repo()` prepares formatted list", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_github_priv$get_pr_from_one_repo,
      "private$get_pr_page_from_repo",
      test_mocker$use("pr_page")
    )
  }
  pr_from_repo <- test_graphql_github_priv$get_pr_from_one_repo(
    org = "r-world-devs",
    repo = "GitStats"
  )
  expect_gt(length(pr_from_repo), 100)
  expect_pr_full_list(
    pr_from_repo
  )
  test_mocker$cache(pr_from_repo)
})

test_that("`get_pr_from_repos()` pulls pr from repos", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_github$get_pr_from_repos,
      "private$get_pr_from_one_repo",
      test_mocker$use("pr_from_repo")
    )
  }
  pr_from_repos <- test_graphql_github$get_pr_from_repos(
    org = "r-world-devs",
    repo = c("GitStats", "GitAI")
  )
  expect_pr_full_list(
    pr_from_repos[[1]]
  )
  test_mocker$cache(pr_from_repos)
})

test_that("`prepare_pr_table()` prepares pr table", {
  gh_pr_table <- test_graphql_github$prepare_pr_table(
    repos_list_with_pr = test_mocker$use("pr_from_repos"),
    org = "r-world-devs"
  )
  expect_pr_table(
    gh_pr_table
  )
  test_mocker$cache(gh_pr_table)
})

