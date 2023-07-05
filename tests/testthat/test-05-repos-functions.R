test_gitstats <- create_test_gitstats(hosts = 2)

test_that("get_repos pulls repos in the table format", {
  expect_snapshot(
    get_repos(test_gitstats)
  )
  repos_table <- test_gitstats$show_repos()
  expect_repos_table(repos_table)
})

test_that("add_repos_contributors adds contributors column to repos table", {
  expect_snapshot(
    add_repos_contributors(
      test_gitstats
    )
  )
  repos_table <- test_gitstats$show_repos()
  expect_repos_table_with_contributors(repos_table)
})
