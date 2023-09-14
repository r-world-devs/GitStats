test_gitstats <- create_test_gitstats(hosts = 2)

test_that("get_orgs() shows orgs", {
  expect_equal(
    get_orgs(test_gitstats),
    c("r-world-devs", "openpharma", "mbtests")
  )
})

test_that("get_repos() shows repos table", {
  test_gitstats$.__enclos_env__$private$repos <- test_mocker$use("gh_repos_table")
  repos_table <- get_repos(test_gitstats)
  expect_repos_table(repos_table)
})

test_that("get_commits() shows commits table", {
  test_gitstats$.__enclos_env__$private$commits <- test_mocker$use("commits_table")
  commits_table <- get_commits(test_gitstats)
  expect_commits_table(commits_table)
})
