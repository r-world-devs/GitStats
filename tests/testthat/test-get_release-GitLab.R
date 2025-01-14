test_that("releases query is built properly", {
  gl_releases_query <-
    test_gqlquery_gl$releases_from_repo()
  expect_snapshot(
    gl_releases_query
  )
})

test_that("`get_releases_from_org()` pulls releases from the repositories", {
  mockery::stub(
    test_graphql_gitlab$get_release_logs_from_org,
    "self$gql_response",
    test_fixtures$gitlab_releases_from_repo
  )
  releases_from_repos <- test_graphql_gitlab$get_release_logs_from_org(
    repos_names = c("TestProject1", "TestProject2"),
    org = "test_org"
  )
  expect_gitlab_releases_response(releases_from_repos)
  test_mocker$cache(releases_from_repos)
})


test_that("`prepare_releases_table()` prepares releases table", {
  releases_table <- test_graphql_gitlab$prepare_releases_table(
    releases_response = test_mocker$use("releases_from_repos"),
    org = "test_org",
    since = "2023-08-01",
    until = "2024-06-30"
  )
  expect_releases_table(releases_table)
  expect_gt(min(releases_table$published_at), as.POSIXct("2023-08-01"))
  expect_lt(max(releases_table$published_at), as.POSIXct("2024-06-30"))
  test_mocker$cache(releases_table)
})

test_that("`get_repos_names` works", {
  mockery::stub(
    gitlab_testhost_priv$get_repos_names,
    "graphql_engine$get_repos_from_org",
    test_mocker$use("gl_repos_from_org")
  )
  gitlab_testhost_priv$orgs_repos <- list("test_org" = "TestRepo")
  gitlab_testhost_priv$searching_scope <- "org"
  repos_names <- gitlab_testhost_priv$get_repos_names(
    org = "test_org"
  )
  expect_type(repos_names, "character")
  expect_gt(length(repos_names), 0)
  test_mocker$cache(repos_names)
})

test_that("`get_release_logs_from_orgs()` works", {
  mockery::stub(
    gitlab_testhost_priv$get_release_logs_from_orgs,
    "graphql_engine$prepare_releases_table",
    test_mocker$use("releases_table")
  )
  mockery::stub(
    gitlab_testhost_priv$get_release_logs_from_orgs,
    "private$get_repos_names",
    test_mocker$use("repos_names")
  )
  gitlab_testhost_priv$searching_scope <- "org"
  releases_from_orgs <- gitlab_testhost_priv$get_release_logs_from_orgs(
    since    = "2023-05-01",
    until    = "2023-09-30",
    verbose  = FALSE,
    progress = FALSE
  )
  expect_releases_table(releases_from_orgs)
  test_mocker$cache(releases_from_orgs)
})

test_that("`get_release_logs_from_orgs()` prints proper message", {
  mockery::stub(
    gitlab_testhost_priv$get_release_logs_from_orgs,
    "graphql_engine$prepare_releases_table",
    test_mocker$use("releases_table")
  )
  mockery::stub(
    gitlab_testhost_priv$get_release_logs_from_orgs,
    "private$get_repos_names",
    test_mocker$use("repos_names")
  )
  gitlab_testhost_priv$searching_scope <- "org"
  expect_snapshot(
    releases_from_orgs <- gitlab_testhost_priv$get_release_logs_from_orgs(
      since    = "2023-05-01",
      until    = "2023-09-30",
      verbose  = TRUE,
      progress = FALSE
    )
  )
})

test_that("`get_release_logs_from_repos()` works", {
  gitlab_testhost_priv <- create_gitlab_testhost(
    repos = "test_org/TestRepo",
    mode = "private"
  )
  mockery::stub(
    gitlab_testhost_priv$get_release_logs_from_repos,
    "graphql_engine$prepare_releases_table",
    test_mocker$use("releases_table")
  )
  gitlab_testhost_priv$orgs_repos <- list("test_org" = "TestRepo")
  expect_snapshot(
    releases_from_repos <- gitlab_testhost_priv$get_release_logs_from_repos(
      since    = "2023-05-01",
      until    = "2023-09-30",
      verbose  = TRUE,
      progress = FALSE
    )
  )
})

test_that("`get_release_logs_from_repos()` works", {
  gitlab_testhost_priv <- create_gitlab_testhost(
    repos = "test_org/TestRepo",
    mode = "private"
  )
  mockery::stub(
    gitlab_testhost_priv$get_release_logs_from_repos,
    "graphql_engine$prepare_releases_table",
    test_mocker$use("releases_table")
  )
  gitlab_testhost_priv$orgs_repos <- list("test_org" = "TestRepo")
  releases_from_repos <- gitlab_testhost_priv$get_release_logs_from_repos(
    since    = "2023-05-01",
    until    = "2023-09-30",
    verbose  = FALSE,
    progress = FALSE
  )
  expect_releases_table(releases_from_repos)
  test_mocker$cache(releases_from_repos)
})

test_that("`get_release_logs()` pulls release logs in the table format", {
  mockery::stub(
    gitlab_testhost$get_release_logs,
    "private$get_release_logs_from_repos",
    test_mocker$use("releases_from_repos")
  )
  mockery::stub(
    gitlab_testhost$get_release_logs,
    "private$get_release_logs_from_orgs",
    test_mocker$use("releases_from_orgs")
  )
  releases_table <- gitlab_testhost$get_release_logs(
    since    = "2023-08-01",
    until    = "2024-06-30",
    verbose  = FALSE,
    progress = FALSE
  )
  expect_releases_table(releases_table)
  expect_gt(min(releases_table$published_at), as.POSIXct("2023-08-01"))
  expect_lt(max(releases_table$published_at), as.POSIXct("2024-06-30"))
  test_mocker$cache(releases_table)
})
