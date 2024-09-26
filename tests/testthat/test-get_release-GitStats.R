test_that("get_release_logs_from_hosts works as expected", {
  test_gitstats <- create_test_gitstats(hosts = 2, priv_mode = TRUE)
  mockery::stub(
    test_gitstats$get_release_logs_from_hosts,
    "host$get_release_logs",
    test_mocker$use("releases_table")
  )
  release_logs_table <- test_gitstats$get_release_logs_from_hosts(
    since = "2023-08-01",
    until = "2023-09-30",
    verbose = FALSE
  )
  expect_releases_table(release_logs_table)
})
