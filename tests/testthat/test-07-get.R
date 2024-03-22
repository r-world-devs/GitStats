test_that("get_repos pulls repos in the table format", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  repos_table <- get_repos(test_gitstats)
  expect_repos_table(repos_table, repo_cols = repo_gitstats_colnames,
                     add_col = c("contributors", "contributors_n"))
  test_mocker$cache(repos_table)
})

test_that("get_commits works", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  commits_table <- get_commits(
    gitstats_obj = test_gitstats,
    since = "2023-06-01",
    until = "2023-06-15"
  )
  expect_commits_table(commits_table)
})

test_that("get_users shows error when no hosts are defined", {
  test_gitstats <- create_gitstats()
  expect_snapshot_error(
    get_users(test_gitstats,
              c("maciekbanas", "kalimu"))
  )
})

test_that("get_users works as expected", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  users_table <- get_users(test_gitstats,
                           c("maciekbanas", "kalimu"))
  expect_users_table(
    users_table
  )
})

test_that("get_files works as expected", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  files_table <- get_files(
    test_gitstats,
    "meta_data.yaml"
  )
  expect_files_table(
    files_table
  )
})

test_that("get_release_logs works as expected", {
  test_gitstats <- create_test_gitstats(hosts = 1)
  releases_table <- get_release_logs(
    test_gitstats,
    since = "2023-05-01",
    until = "2023-09-30"
  )
  expect_releases_table(
    releases_table
  )
})
