test_that("releases query is built properly", {
  gh_releases_query <-
    test_gqlquery_gh$releases_from_repo()
  expect_snapshot(
    gh_releases_query
  )
})

test_that("`get_releases_from_org()` pulls releases from the repositories", {
  releases_from_repos <- test_graphql_github$get_release_logs_from_org(
    repos_names = c("GitStats", "shinyCohortBuilder"),
    org = "r-world-devs"
  )
  expect_github_releases_response(releases_from_repos)
  test_mocker$cache(releases_from_repos)
})

test_that("`prepare_releases_table()` prepares releases table", {
  releases_table <- github_testhost_priv$prepare_releases_table(
    releases_response = test_mocker$use("releases_from_repos"),
    org = "r-world-devs",
    date_from = "2023-05-01",
    date_until = "2023-09-30"
  )
  expect_releases_table(releases_table)
  expect_gt(min(releases_table$published_at), as.POSIXct("2023-05-01"))
  expect_lt(max(releases_table$published_at), as.POSIXct("2023-09-30"))
  test_mocker$cache(releases_table)
})

test_that("`get_release_logs()` pulls release logs in the table format", {
  mockery::stub(
    github_testhost$get_release_logs,
    "private$prepare_releases_table",
    test_mocker$use("releases_table")
  )
  releases_table <- github_testhost$get_release_logs(
    since = "2023-05-01",
    until = "2023-09-30",
    verbose = FALSE,
    settings = test_settings
  )
  expect_releases_table(releases_table)
  expect_gt(min(releases_table$published_at), as.POSIXct("2023-05-01"))
  expect_lt(max(releases_table$published_at), as.POSIXct("2023-09-30"))
  test_mocker$cache(releases_table)
})
