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
