test_that("get_commits_stats method works", {
  commits_stats <- get_commits_stats(
    commits = test_mocker$use("commits_data"),
    time_aggregation = "month",
    group_var = organization
  )
  expect_s3_class(commits_stats, "gitstats_commits_stats")
  expect_equal(
    colnames(commits_stats),
    c("stats_date", "githost", "organization", "stats")
  )
  expect_true(
    all(c("gitlab", "github") %in% commits_stats$githost)
  )
  commits_stats_yearly <- get_commits_stats(
    commits = test_mocker$use("commits_data"),
    time_aggregation = "year"
  )
  expect_equal(commits_stats_yearly$stats_date,
               as.POSIXct(c(rep("2023-01-01", 2), "2024-01-01"), tz = 'UTC'))
  expect_s3_class(commits_stats_yearly, "gitstats_commits_stats")
  expect_equal(
    colnames(commits_stats_yearly),
    c("stats_date", "githost", "stats")
  )
})

test_that("get_commits_stats returns error when commits is not commits_data object", {
  expect_snapshot_error(
    get_commits_stats(
      commits = test_mocker$use("gh_commits_table")
    )
  )
})
