test_that("pull_repos pulls repos in the table format", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  expect_snapshot(
    pull_repos(test_gitstats)
  )
  repos_table <- test_gitstats$get_repos()
  expect_repos_table_with_api_url(repos_table)
})

test_that("pull_repos_contributors adds contributors column to repos table", {
  test_gitstats <- create_test_gitstats(
    hosts = 2,
    inject_repos = "repos_table_without_contributors"
  )
  expect_snapshot(
    pull_repos_contributors(
      test_gitstats
    )
  )
  repos_table_with_contributors <- test_gitstats$get_repos()
  expect_true("contributors" %in% names(repos_table_with_contributors))
  test_mocker$cache(repos_table_with_contributors)
})

test_that("pull_users shows error when no hosts are defined", {
  test_gitstats <- create_gitstats()
  expect_snapshot_error(
    pull_users(test_gitstats,
               c("maciekbanas", "kalimu"))
  )
})

test_that("pull_users works as expected", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  pull_users(test_gitstats,
             c("maciekbanas", "kalimu"))
  users_table <- test_gitstats$get_users()
  expect_users_table(
    users_table
  )
})