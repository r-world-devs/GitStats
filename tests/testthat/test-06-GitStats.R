test_gitstats <- create_gitstats()

test_that("GitStats object is created", {
  expect_s3_class(test_gitstats, "GitStats")
})

# print method

test_that("GitStats prints empty fields.", {
  expect_snapshot(test_gitstats)
})

test_gitstats <- create_test_gitstats(hosts = 2)

test_that("GitStats prints the proper info when connections are added.", {
  expect_snapshot(test_gitstats)
})

suppressMessages({
  set_params(
    test_gitstats,
    search_param = "team",
    team_name = "RWD-IE"
  )
})

test_that("GitStats prints team name when team is added.", {
  expect_snapshot(test_gitstats)
})

# private methods
test_gitstats_priv <- create_test_gitstats(priv_mode = TRUE)

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
  test_gitstats <- create_test_gitstats(hosts = 2)
  test_gitstats$pull_users(
    c("maciekbanas", "kalimu", "marcinkowskak")
  )
  users_result <- get_users(test_gitstats)
  expect_users_table(
    users_result
  )
})

test_gitstats <- create_test_gitstats(hosts = 2)

test_that("GitStats throws error when pull_repos_contributors is run with empty repos field", {

  expect_snapshot_error(
    test_gitstats$pull_repos_contributors()
  )
})

test_that("Add_repos_contributors adds repos contributors to repos table", {
  suppressMessages({
    test_gitstats$pull_repos()
  })
  repos_without_contributors <- test_gitstats$get_repos()
  expect_snapshot(
    test_gitstats$pull_repos_contributors()
  )
  repos_with_contributors <- test_gitstats$get_repos()
  expect_repos_table_with_contributors(repos_with_contributors)
  expect_equal(nrow(repos_without_contributors), nrow(repos_with_contributors))
})

test_that("get_orgs print orgs properly", {
  expect_equal(
    test_gitstats$get_orgs(),
    c("r-world-devs", "openpharma", "mbtests")
  )
})

suppressMessages(
  test_gitstats <- create_gitstats() %>%
    set_host(
      api_url = "https://gitlab.com/api/v4",
      token = Sys.getenv("GITLAB_PAT_PUBLIC"),
      orgs = "mbtests/subgroup"
    )
)

test_that("get_orgs print subgroups properly", {
  expect_equal(
    test_gitstats$get_orgs(),
    "mbtests/subgroup"
  )
})

test_that("subgroups are cleanly printed in GitStats", {
  expect_snapshot(
    test_gitstats
  )
})
