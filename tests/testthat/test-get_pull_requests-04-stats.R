test_that("get_pull_requests_stats method works", {

  pr_stats <- get_pull_requests_stats(
    pull_requests = test_mocker$use("pr_data"),
    time_aggregation = "month",
    group_var = author
  )
  expect_s3_class(pr_stats, "gitstats_pr_stats")
  expect_equal(
    colnames(pr_stats),
    c("state", "created_at", "author", "stats")
  )
  pr_stats_yearly <- get_pull_requests_stats(
    pull_requests = test_mocker$use("pr_data"),
    time_aggregation = "year"
  )
  expect_in(as.POSIXct(c("2024-01-01", "2025-01-01", "2026-01-01"), tz = 'UTC'), pr_stats_yearly$created_at)
  expect_s3_class(pr_stats_yearly, "gitstats_pr_stats")
  expect_equal(
    colnames(pr_stats_yearly),
    c("state", "created_at", "stats")
  )
})

test_that("get_pull_requests_stats returns error when issues is not pr_data object", {
  expect_snapshot_error(
    get_pull_requests_stats(
      pull_requests = test_mocker$use("gh_prs_table")
    )
  )
})
