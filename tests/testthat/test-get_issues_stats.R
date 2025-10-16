test_that("get_issues_stats method works", {
  issues_stats <- get_issues_stats(
    issues = test_mocker$use("issues_data"),
    time_aggregation = "month",
    group_var = state
  )
  expect_s3_class(issues_stats, "gitstats_issues_stats")
  expect_equal(
    colnames(issues_stats),
    c("stats_date", "githost", "state", "stats")
  )
  expect_true(
    all(c("gitlab", "github") %in% issues_stats$githost)
  )
  issues_stats_yearly <- get_issues_stats(
    issues = test_mocker$use("issues_data"),
    time_aggregation = "year"
  )
  expect_true(all(as.POSIXct(c("2023-01-01", "2024-01-01", "2025-01-01"), tz = 'UTC') %in% issues_stats_yearly$stats_date))
  expect_s3_class(issues_stats_yearly, "gitstats_issues_stats")
  expect_equal(
    colnames(issues_stats_yearly),
    c("stats_date", "githost", "stats")
  )
})

test_that("get_issues_stats returns error when issues is not issues_data object", {
  expect_snapshot_error(
    get_issues_stats(
      issues = test_mocker$use("gh_issues_table")
    )
  )
})
