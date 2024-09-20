test_host <- create_github_testhost(orgs = "r-world-devs", mode = "private")

test_that("`set_searching_scope` does not throw error when `orgs` or `repos` are defined", {
  expect_snapshot(
    test_host$set_searching_scope(orgs = "mbtests", repos = NULL)
  )
  expect_snapshot(
    test_host$set_searching_scope(orgs = NULL, repos = "mbtests/GitStatsTesting")
  )
})

test_that("`extract_repos_and_orgs` extracts fullnames vector into a list of GitLab organizations with assigned repositories", {
  repos_fullnames <- c(
    "mbtests/gitstatstesting", "mbtests/gitstats-testing-2", "mbtests/subgroup/test-project-in-subgroup"
  )
  expect_equal(
    test_host$extract_repos_and_orgs(repos_fullnames),
    list(
      "mbtests" = c("gitstatstesting", "gitstats-testing-2"),
      "mbtests/subgroup" = c("test-project-in-subgroup")
    )
  )
})

test_that("`prepare_releases_table()` prepares releases table", {
  releases_table <- test_host$prepare_releases_table(
    releases_response = test_mocker$use("releases_from_repos"),
    org = "r-world-devs",
    date_from = "2023-05-01",
    date_until = "2023-09-30"
  )
  expect_releases_table(releases_table)
  expect_gt(min(releases_table$published_at), as.POSIXct("2023-05-01"))
  expect_lt(max(releases_table$published_at), as.POSIXct("2023-09-30"))
  test_mocker$cache(releases_table)
})



test_that("GitHub prepares user table", {
  gh_user_table <- test_host$prepare_user_table(
    user_response = test_mocker$use("gh_user_response")
  )
  expect_users_table(
    gh_user_table,
    one_user = TRUE
  )
  test_mocker$cache(gh_user_table)
})

# public methods

test_host <- create_github_testhost(orgs = "r-world-devs")

test_that("`get_release_logs()` pulls release logs in the table format", {
  mockery::stub(
    test_host$get_release_logs,
    "private$prepare_releases_table",
    test_mocker$use("releases_table")
  )
  releases_table <- test_host$get_release_logs(
    since = "2023-05-01",
    until = "2023-09-30",
    verbose = FALSE,
    settings = test_settings
  )
  expect_releases_table(releases_table)
  expect_gt(min(releases_table$published_at), as.POSIXct("2023-05-01"))
  expect_lt(max(releases_table$published_at), as.POSIXct("2023-09-30"))
  test_mocker$cache(releases_table)
})

# GitLab - private methods

test_host_gitlab <- create_gitlab_testhost(orgs = "mbtests", mode = "private")

test_that("GitLab prepares user table", {
  gl_user_table <- test_host_gitlab$prepare_user_table(
    user_response = test_mocker$use("gl_user_response")
  )
  expect_users_table(
    gl_user_table,
    one_user = TRUE
  )
  test_mocker$cache(gl_user_table)
})

# public - GitLab

test_host_gitlab <- create_gitlab_testhost(orgs = "mbtests")

test_that("get_users build users table for GitHub", {
  users_result <- test_host$get_users(
    users = c("maciekbanas", "Cotau", "marcinkowskak")
  )
  expect_users_table(
    users_result
  )
})

test_that("get_users build users table for GitLab", {
  users_result <- test_host_gitlab$get_users(
    users = c("maciekbanas", "Cotau", "marcinkowskak")
  )
  expect_users_table(
    users_result
  )
})
