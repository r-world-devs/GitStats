test_that("get_issues_from_hosts works", {
  mockery::stub(
    test_gitstats_priv$get_issues_from_hosts,
    "host$get_issues",
    purrr::list_rbind(list(
      test_mocker$use("gh_issues_table"),
      test_mocker$use("gl_issues_table")
    ))
  )
  issues_from_hosts <- test_gitstats_priv$get_issues_from_hosts(
    since = "2023-01-01",
    until = "2025-03-06",
    state = NULL,
    verbose = FALSE,
    progress = FALSE
  )
  expect_issues_table(
    issues_from_hosts
  )
  test_mocker$cache(issues_from_hosts)
})
