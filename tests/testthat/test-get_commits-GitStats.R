# GitStats

test_that("get_commits works properly", {
  mockery::stub(
    test_gitstats$get_commits,
    "private$get_commits_from_hosts",
    purrr::list_rbind(
      list(
        test_mocker$use("gh_commits_table"),
        test_mocker$use("gl_commits_table")
      )
    )
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

test_gitstats <- create_test_gitstats(
  hosts = 2,
  inject_commits = "commits_table"
)

test_that("get_commits_stats prepares table with statistics on commits", {
  commits_stats <- get_commits_stats(test_gitstats)
  expect_s3_class(commits_stats, "commits_stats")
  expect_equal(
    colnames(commits_stats),
    c("stats_date", "platform", "organization", "commits_n")
  )
  expect_true(
    "github" %in% commits_stats$platform
  )
  test_mocker$cache(commits_stats)

  commits_stats_daily <- get_commits_stats(
    gitstats_obj = test_gitstats,
    time_interval = "day")
  expect_s3_class(commits_stats_daily, "commits_stats")
  expect_equal(
    colnames(commits_stats_daily),
    c("stats_date", "platform", "organization", "commits_n")
  )
})
