commits_table_from_hosts <- purrr::list_rbind(
  list(
    test_mocker$use("gh_commits_table"),
    test_mocker$use("gl_commits_table")
  )
)

test_that("set_object_class works for commits", {
  commits_table<- test_gitstats_priv$set_object_class(
    object = commits_table_from_hosts,
    class = "commits_data",
    attr_list = list(
      "date_range" = c("2023-06-15", "2023-06-30")
    )
  )
  expect_s3_class(
    commits_table,
    "commits_data"
  )
  expect_equal(
    attr(commits_table, "date_range"),
    c("2023-06-15", "2023-06-30")
  )
})

test_that("get_commits works properly", {
  mockery::stub(
    test_gitstats$get_commits,
    "private$get_commits_from_hosts",
    commits_table_from_hosts
  )
  suppressMessages(
    commits_table <- test_gitstats$get_commits(
      since = "2023-06-15",
      until = "2023-06-30",
      verbose = FALSE
    )
  )
  expect_commits_table(
    commits_table
  )
  test_mocker$cache(commits_table)
})

test_that("get_commits() works", {
  mockery::stub(
    get_commits,
    "gitstats_object$get_commits",
    test_mocker$use("commits_table")
  )
  commits_table <- get_commits(
    test_gitstats,
    since = "2023-06-15",
    until = "2023-06-30",
    verbose = FALSE
  )
  expect_s3_class(
    commits_table,
    "commits_data"
  )
})

test_that("get_commits() returns error when since is not defined", {
  mockery::stub(
    get_commits,
    "gitstats_object$get_commits",
    test_mocker$use("commits_table")
  )
  expect_snapshot_error(
    get_commits(
      test_gitstats,
      verbose = FALSE
    )
  )
})

test_that("prepare_commits_stats prepares commits statistics", {
  commits_stats <- test_gitstats_priv$prepare_commits_stats(
    commits = test_mocker$use("commits_table"),
    time_aggregation = "week",
    author,
    stats = dplyr::n()
  )
  expect_equal(
    colnames(commits_stats),
    c("stats_date", "githost", "author", "stats")
  )
})

test_gitstats <- create_test_gitstats(
  hosts = 2,
  inject_commits = "commits_table"
)

test_that("get_commits_stats method works", {
  commits_stats <- test_gitstats$get_commits_stats(
    time_aggregation = "month",
    organization,
    stats = dplyr::n()
  )
  expect_s3_class(commits_stats, "commits_stats")
  expect_equal(
    colnames(commits_stats),
    c("stats_date", "githost", "organization", "stats")
  )
  expect_true(
    all(c("gitlab", "github") %in% commits_stats$githost)
  )
  test_mocker$cache(commits_stats)
})

test_that("get_commits_stats returns error when no commits", {
  test_gitstats <- create_test_gitstats()
  expect_snapshot_error(
    get_commits_stats(test_gitstats)
  )
})

test_that("get_commits_stats prepares table with statistics on commits", {
  commits_stats_daily <- get_commits_stats(
    gitstats_obj = test_gitstats,
    time_aggregation = "day",
    organization,
  )
  expect_s3_class(commits_stats_daily, "commits_stats")
  expect_equal(
    colnames(commits_stats_daily),
    c("stats_date", "githost", "organization", "stats")
  )

  commits_stats_yearly <- get_commits_stats(
    gitstats_obj = test_gitstats,
    time_aggregation = "year"
  )
  expect_equal(commits_stats_yearly$stats_date,
               as.POSIXct(c(rep("2023-01-01", 2), "2024-01-01"), tz = 'UTC'))
  expect_s3_class(commits_stats_yearly, "commits_stats")
  expect_equal(
    colnames(commits_stats_yearly),
    c("stats_date", "githost", "stats")
  )
})
