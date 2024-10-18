test_that("`set_searching_scope` does not throw error when `orgs` or `repos` are defined", {
  expect_snapshot(
    gitlab_testhost_priv$set_searching_scope(orgs = "mbtests", repos = NULL, verbose = TRUE)
  )
  expect_snapshot(
    gitlab_testhost_priv$set_searching_scope(orgs = NULL, repos = "mbtests/GitStatsTesting", verbose = TRUE)
  )
})

test_that("`extract_repos_and_orgs` extracts fullnames vector into a list of GitLab organizations with assigned repositories", {
  repos_fullnames <- c(
    "mbtests/gitstatstesting", "mbtests/gitstats-testing-2", "mbtests/subgroup/test-project-in-subgroup"
  )
  expect_equal(
    gitlab_testhost_priv$extract_repos_and_orgs(repos_fullnames),
    list(
      "mbtests" = c("gitstatstesting", "gitstats-testing-2"),
      "mbtests/subgroup" = c("test-project-in-subgroup")
    )
  )
})

test_that("`extract_repos_and_orgs` extracts fullnames vector into a list of GitHub organizations with assigned repositories", {
  repos_fullnames <- c(
    "r-world-devs/GitStats", "r-world-devs/shinyCohortBuilder",
    "openpharma/DataFakeR", "openpharma/GithubMetrics"
  )
  expect_equal(
    github_testhost_priv$extract_repos_and_orgs(repos_fullnames),
    list(
      "r-world-devs" = c("GitStats", "shinyCohortBuilder"),
      "openpharma" = c("DataFakeR", "GithubMetrics")
    )
  )
})

test_that("When token is empty throw error", {
  expect_snapshot(
    error = TRUE,
    github_testhost_priv$check_token("")
  )
})

test_that("`check_token()` prints error when token exists but does not grant access", {
  token <- "does_not_grant_access"
  expect_snapshot_error(
    github_testhost_priv$check_token(token)
  )
})

test_that("when token is proper token is passed", {
  skip_on_cran()
  github_testhost_priv <- create_github_testhost(
    orgs = "test-org",
    token = Sys.getenv("GITHUB_PAT"),
    mode = "private"
  )
  mockery::stub(
    github_testhost_priv$check_token,
    "private$test_token",
    TRUE
  )
  expect_equal(
    github_testhost_priv$check_token(Sys.getenv("GITHUB_PAT")),
    Sys.getenv("GITHUB_PAT")
  )
})

test_that("check_endpoint returns TRUE if they are correct", {
  skip_on_cran()
  github_testhost_priv <- create_github_testhost(
    org = "test-org",
    token = Sys.getenv("GITHUB_PAT"),
    mode = "private"
  )
  expect_true(
    github_testhost_priv$check_endpoint(
      endpoint = "https://api.github.com/repos/r-world-devs/GitStats",
      type = "Repository"
    )
  )
  expect_true(
    github_testhost_priv$check_endpoint(
      endpoint = "https://api.github.com/orgs/openpharma",
    )
  )
})

test_that("check_endpoint returns error if they are not correct", {
  skip_on_cran()
  github_testhost_priv <- create_github_testhost(
    orgs = "test-org",
    token = Sys.getenv("GITHUB_PAT"),
    mode = "private"
  )
  expect_snapshot_error(
    check <- github_testhost_priv$check_endpoint(
      endpoint = "https://api.github.com/repos/r-worlddevs/GitStats",
      type = "Repository"
    )
  )
})

test_that("`check_if_public` works correctly", {
  expect_true(
    github_testhost_priv$check_if_public("api.github.com")
  )
  expect_false(
    github_testhost_priv$check_if_public("github.internal.com")
  )
})

test_that("`set_default_token` sets default token for public GitHub", {
  skip_on_cran()
  expect_snapshot(
    default_token <- github_testhost_priv$set_default_token(
      verbose = TRUE
    )
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

test_that("`set_default_token` returns error if none are found", {
  mockery::stub(
    github_testhost_priv$set_default_token,
    "private$test_token",
    FALSE
  )
  expect_error({
    github_testhost_priv$set_default_token(
      verbose = FALSE
    )
  })
})

test_that("`test_token` works properly", {
  skip_on_cran()
  expect_true(
    github_testhost_priv$test_token(Sys.getenv("GITHUB_PAT"))
  )
  expect_false(
    github_testhost_priv$test_token("false_token")
  )
})

test_that("`set_default_token` sets default token for GitLab", {
  skip_on_cran()
  expect_snapshot(
    withr::with_envvar(new = c("GITLAB_PAT" = Sys.getenv("GITLAB_PAT_PUBLIC")), {
      default_token <- gitlab_testhost_priv$set_default_token(verbose = TRUE)
    })
  )
  test_rest <- create_testrest(token = default_token,
                               mode = "private")
  expect_equal(
    test_rest$perform_request(
      endpoint = "https://gitlab.com/api/v4/projects",
      token = default_token
    )$status,
    200
  )
})

test_that("`set_searching_scope` throws error when both `orgs` and `repos` are defined", {
  expect_snapshot_error(
    gitlab_testhost_priv$set_searching_scope(
      orgs    = "mbtests",
      repos   = "mbtests/GitStatsTesting",
      verbose = TRUE
    )
  )
})
