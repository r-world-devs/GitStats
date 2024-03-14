test_gitstats <- create_test_gitstats(
  hosts = 2,
  inject_repos = "gh_repos_table",
  inject_commits = "commits_table"
)

test_that("get_orgs() returns orgs", {
  expect_equal(
    get_orgs(test_gitstats),
    c("r-world-devs", "openpharma", "mbtests")
  )
})

test_that("get_repos() returns repos table", {
  repos_table <- get_repos(test_gitstats)
  expect_repos_table(repos_table)
})

test_that("get_commits() returns commits table", {
  commits_table <- get_commits(test_gitstats)
  expect_commits_table(commits_table)
})

test_that("get_users() returns users table", {
  test_gitstats$.__enclos_env__$private$users <- test_mocker$use("users_table")
  users_table <- get_users(test_gitstats)
  expect_users_table(users_table)
})

test_that("get_files() returns users table", {
  test_gitstats$.__enclos_env__$private$files <- test_mocker$use("files_table")
  files_table <- get_files(test_gitstats)
  expect_files_table(files_table)
})
