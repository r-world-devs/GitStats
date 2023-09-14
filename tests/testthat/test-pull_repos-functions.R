test_gitstats <- create_test_gitstats(hosts = 2)

test_that("pull_repos pulls repos in the table format", {
  expect_snapshot(
    pull_repos(test_gitstats)
  )
  repos_table <- test_gitstats$get_repos()
  expect_repos_table(repos_table)
})

test_that("pull_repos_contributors adds contributors column to repos table", {
  expect_snapshot(
    pull_repos_contributors(
      test_gitstats
    )
  )
  repos_table <- test_gitstats$get_repos()
  expect_repos_table_with_contributors(repos_table)
})
