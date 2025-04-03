test_that("get_release_logs_from_hosts works as expected", {
  test_gitstats_priv <- create_test_gitstats(hosts = 2, priv_mode = TRUE)
  mockery::stub(
    test_gitstats_priv$get_release_logs_from_hosts,
    "host$get_release_logs",
    test_mocker$use("releases_table")
  )
  release_logs_table <- test_gitstats_priv$get_release_logs_from_hosts(
    since = "2023-08-01",
    until = "2023-09-30",
    verbose = FALSE
  )
  expect_releases_table(release_logs_table)
  test_mocker$cache(release_logs_table)
})

test_that("get_release_logs works as expected", {
  mockery::stub(
    test_gitstats$get_release_logs,
    "private$get_release_logs_from_hosts",
    test_mocker$use("release_logs_table")
  )
  release_logs_table <- test_gitstats$get_release_logs(
    since = "2023-08-01",
    until = "2023-09-30",
    verbose = FALSE
  )
  expect_releases_table(release_logs_table)
  test_mocker$cache(release_logs_table)
})

test_that("get_release_logs works as expected", {
  mockery::stub(
    get_release_logs,
    "gitstats$get_release_logs",
    test_mocker$use("release_logs_table")
  )
  release_logs_table <- get_release_logs(
    gitstats = test_gitstats,
    since = "2023-08-01",
    until = "2023-09-30",
    verbose = FALSE
  )
  expect_releases_table(release_logs_table)
})

test_that("get_release_logs prints time used to pull data", {
  mockery::stub(
    get_release_logs,
    "gitstats$get_release_logs",
    test_mocker$use("release_logs_table")
  )
  expect_snapshot(
    release_logs_table <- get_release_logs(
      gitstats = test_gitstats,
      since = "2023-08-01",
      until = "2023-09-30",
      verbose = TRUE
    )
  )
})
