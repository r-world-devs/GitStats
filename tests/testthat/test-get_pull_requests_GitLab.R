test_that("pr_by_repo GitLab query is built properly", {
  gl_pr_from_repo_query <-
    test_gqlquery_gl$pull_requests_from_repo()
  expect_snapshot(
    gl_pr_from_repo_query
  )
})

test_that("`get_pr_page_from_repo()` pulls pr page from repository", {
  # mockery::stub(
  #   test_graphql_GitLab_priv$get_pr_page_from_repo,
  #   "self$gql_response",
  #   test_fixtures$GitLab_pr_response
  # )
  pr_page <- test_graphql_gitlab_priv$get_pr_page_from_repo(
    org = "mbtests",
    repo = "gitstatstesting"
  )

  expect_pr_gql_response(
    pr_page$data$project$mergeRequests$edges[[1]]
  )
  test_mocker$cache(pr_page)
})
