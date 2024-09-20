# public methods

test_host <- create_github_testhost(
  orgs = c("openpharma", "r-world-devs")
)

test_that("GitHost gets users tables", {
  users_table <- test_host$get_users(
    users = c("maciekbanas", "kalimu", "galachad")
  )
  expect_users_table(users_table)
  test_mocker$cache(users_table)
})

# private methods

test_host <- create_github_testhost(
  orgs = c("openpharma", "r-world-devs"),
  mode = "private"
)

test_that("When token is empty throw error", {
  expect_snapshot(
    error = TRUE,
    test_host$check_token("")
  )
})

test_that("`check_token()` prints error when token exists but does not grant access", {
  token <- "does_not_grant_access"
  expect_snapshot_error(
    test_host$check_token(token)
  )
})

test_that("when token is proper token is passed", {
  expect_equal(
    test_host$check_token(Sys.getenv("GITHUB_PAT")),
    Sys.getenv("GITHUB_PAT")
  )
})

test_that("check_endpoint returns TRUE if they are correct", {
  expect_true(
    test_host$check_endpoint(
      endpoint = "https://api.github.com/repos/r-world-devs/GitStats",
      type = "Repository"
    )
  )
  expect_true(
    test_host$check_endpoint(
      endpoint = "https://api.github.com/orgs/openpharma",
    )
  )
})

test_that("check_endpoint returns error if they are not correct", {
  expect_snapshot_error(
    check <- test_host$check_endpoint(
      endpoint = "https://api.github.com/repos/r-worlddevs/GitStats",
      type = "Repository"
    )
  )
})

test_that("`check_if_public` works correctly", {
  expect_true(
    test_host$check_if_public("api.github.com")
  )
  expect_false(
    test_host$check_if_public("github.internal.com")
  )
})

test_that("`set_default_token` sets default token for public GitHub", {
  expect_snapshot(
    default_token <- test_host$set_default_token()
  )
  test_rest <- create_testrest(token = default_token,
                               mode = "private")
  expect_equal(
    test_rest$perform_request(
      endpoint = "https://api.github.com",
      token = default_token
    )$status,
    200
  )
})

test_that("`test_token` works properly", {
  expect_true(
    test_host$test_token(Sys.getenv("GITHUB_PAT"))
  )
  expect_false(
    test_host$test_token("false_token")
  )
})

test_that("`extract_repos_and_orgs` extracts fullnames vector into a list of GitHub organizations with assigned repositories", {
  repos_fullnames <- c(
    "r-world-devs/GitStats", "r-world-devs/shinyCohortBuilder",
    "openpharma/DataFakeR", "openpharma/GithubMetrics"
  )
  expect_equal(
    test_host$extract_repos_and_orgs(repos_fullnames),
    list(
      "r-world-devs" = c("GitStats", "shinyCohortBuilder"),
      "openpharma" = c("DataFakeR", "GithubMetrics")
    )
  )
})
