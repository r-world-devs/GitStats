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

test_that("get_table() returns repos table", {
  repos_table <- get_table(
    test_gitstats,
    table = "repos"
  )
  expect_repos_table(repos_table)
})

test_that("get_table() returns commits table", {
  commits_table <- get_table(test_gitstats, table = "commits")
  expect_commits_table(commits_table)
})

test_that("get_table() returns users table", {
  test_gitstats$.__enclos_env__$private$storage$users <- test_mocker$use("users_table")
  users_table <- get_table(test_gitstats, "users")
  expect_users_table(users_table)
})

test_that("get_table() returns files table", {
  test_gitstats$.__enclos_env__$private$storage$files <- test_mocker$use("files_table")
  files_table <- get_table(test_gitstats, "files")
  expect_files_table(files_table)
})
