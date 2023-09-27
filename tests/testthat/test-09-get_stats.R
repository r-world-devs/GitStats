test_gitstats <- create_test_gitstats(
  hosts = 2,
  inject_repos = "repos_table_without_contributors"
)

test_that("get_repos_stats prepares table with statistics on repository level", {
  repos_stats <- get_repos_stats(
    test_gitstats
  )
  expect_s3_class(
    repos_stats,
    "repos_stats"
  )
  expect_equal(
    colnames(repos_stats),
    c("repository", "platform", "created_at", "last_activity",
      "stars", "forks", "languages", "issues_open", "issues_closed",
      "contributors_n")
  )
  test_mocker$cache(repos_stats)
})

test_gitstats <- create_test_gitstats(
  hosts = 2,
  inject_repos = "repos_table_with_contributors"
)

test_that("get_repos_stats prepares table with statistics with contributors on repository level", {
  repos_stats_contributors <- get_repos_stats(
    test_gitstats
  )
  expect_s3_class(
    repos_stats_contributors,
    "repos_stats"
  )
  expect_equal(
    colnames(repos_stats_contributors),
    c("repository", "platform", "created_at", "last_activity",
      "stars", "forks", "languages", "issues_open", "issues_closed",
      "contributors_n")
  )
  expect_type(
    repos_stats_contributors$contributors_n,
    "integer"
  )
  expect_gt(
    length(unique(repos_stats_contributors$contributors_n)),
    1
  )
  test_mocker$cache(repos_stats_contributors)
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
