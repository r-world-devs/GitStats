test_that("releases query is built properly", {
  gl_releases_query <-
    test_gqlquery_gl$releases_from_repo()
  expect_snapshot(
    gl_releases_query
  )
})

test_that("`get_releases_from_org()` pulls releases from the repositories", {
  mockery::stub(
    test_graphql_gitlab$get_release_logs_from_org,
    "self$gql_response",
    test_fixtures$gitlab_releases_from_repo
  )
  releases_from_repos <- test_graphql_gitlab$get_release_logs_from_org(
    repos_names = c("TestProject1", "TestProject2"),
    org = "test_org"
  )
  expect_gitlab_releases_response(releases_from_repos)
  test_mocker$cache(releases_from_repos)
})


test_that("`prepare_releases_table()` prepares releases table", {
  releases_table <- test_graphql_gitlab$prepare_releases_table(
    releases_response = test_mocker$use("releases_from_repos"),
    org        = "test_org",
    date_from  = "2023-08-01",
    date_until = "2024-06-30"
  )
  expect_releases_table(releases_table)
  expect_gt(min(releases_table$published_at), as.POSIXct("2023-08-01"))
  expect_lt(max(releases_table$published_at), as.POSIXct("2024-06-30"))
  test_mocker$cache(releases_table)
})

test_that("`get_release_logs()` pulls release logs in the table format", {
  mockery::stub(
    gitlab_testhost$get_release_logs,
    "graphql_engine$prepare_releases_table",
    test_mocker$use("releases_table")
  )
  releases_table <- gitlab_testhost$get_release_logs(
    since    = "2023-08-01",
    until    = "2024-06-30",
    verbose  = FALSE,
    progress = FALSE
  )
  expect_releases_table(releases_table)
  expect_gt(min(releases_table$published_at), as.POSIXct("2023-08-01"))
  expect_lt(max(releases_table$published_at), as.POSIXct("2024-06-30"))
  test_mocker$cache(releases_table)
})
