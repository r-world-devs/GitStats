test_gitstats <- create_gitstats()

test_that("GitStats object is created", {
  expect_s3_class(test_gitstats, "GitStats")
})

# print method

test_that("GitStats prints empty fields.", {
  expect_snapshot(test_gitstats)
})

suppressMessages({
  test_gitstats$add_host(
    api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = c("r-world-devs", "openpharma")
  )

  test_gitstats$add_host(
    api_url = "https://gitlab.com/api/v4",
    token = Sys.getenv("GITLAB_PAT_PUBLIC"),
    orgs = "mbtests"
  )
})

test_that("GitStats prints the proper info when connections are added.", {
  expect_snapshot(test_gitstats)
})

suppressMessages({
  setup(
    test_gitstats,
    search_param = "team",
    team_name = "RWD-IE"
  )
})

test_that("GitStats prints team name when team is added.", {
  expect_snapshot(test_gitstats)
})

# private methods
test_gitstats <- create_gitstats()
test_gitstats_priv <- environment(test_gitstats$setup)$private

test_that("Language handler works properly", {
  expect_equal(test_gitstats_priv$language_handler("r"), "R")
  expect_equal(test_gitstats_priv$language_handler("python"), "Python")
  expect_equal(test_gitstats_priv$language_handler("javascript"), "Javascript")
})

test_that("check_for_host works", {
  expect_snapshot_error(
    test_gitstats_priv$check_for_host()
  )
})

# public methods

test_that("GitStats get users info", {
  suppressMessages({
    test_gitstats$add_host(
      api_url = "https://api.github.com",
      token = Sys.getenv("GITHUB_PAT"),
      orgs = c("r-world-devs", "openpharma")
    )

    test_gitstats$add_host(
      api_url = "https://gitlab.com/api/v4",
      token = Sys.getenv("GITLAB_PAT_PUBLIC"),
      orgs = "mbtests"
    )
  })
  users_result <- test_gitstats$get_users(
    c("maciekbanas", "kalimu", "marcinkowskak")
  )
  expect_users_table(
    users_result
  )
})
