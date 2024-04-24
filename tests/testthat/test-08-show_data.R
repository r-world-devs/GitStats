test_gitstats <- create_test_gitstats(
  hosts = 2,
  inject_repos = "repos_table",
  inject_commits = "commits_table"
)

test_that("show_orgs() returns orgs", {
  expect_equal(
    show_orgs(test_gitstats),
    c("r-world-devs", "mbtests")
  )
})

test_that("show_data() returns repos table", {
  repos_table <- show_data(
    test_gitstats,
    storage = "repos"
  )
  expect_repos_table(repos_table, repo_cols = repo_gitstats_colnames)
})

test_that("show_data() returns commits table", {
  commits_table <- show_data(test_gitstats, storage = "commits")
  expect_commits_table(commits_table)
})

test_that("show_data() returns users table", {
  test_gitstats$.__enclos_env__$private$storage$users <- test_mocker$use("users_table")
  users_table <- show_data(test_gitstats, "users")
  expect_users_table(users_table)
})

test_that("show_data() returns files table", {
  test_gitstats$.__enclos_env__$private$storage$files <- test_mocker$use("files_table")
  files_table <- show_data(test_gitstats, "files")
  expect_files_table(files_table)
})

test_that("show_data() returns release_log table", {
  test_gitstats$.__enclos_env__$private$storage$release_logs <- test_mocker$use("releases_table")
  releases <- show_data(test_gitstats, "releases")
  expect_releases_table(releases)
  releases_logs <- show_data(test_gitstats, "release_logs")
  expect_releases_table(releases_logs)
})
