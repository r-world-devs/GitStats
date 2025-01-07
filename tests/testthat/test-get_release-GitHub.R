test_that("releases query is built properly", {
  gh_releases_query <-
    test_gqlquery_gh$releases_from_repo()
  expect_snapshot(
    gh_releases_query
  )
})

test_that("`get_releases_from_org()` pulls releases from the repositories", {
  mockery::stub(
    test_graphql_github$get_release_logs_from_org,
    "self$gql_response",
    test_fixtures$github_releases_from_repo
  )
  releases_from_repos <- test_graphql_github$get_release_logs_from_org(
    repos_names = c("TestProject1", "TestProject2"),
    org = "test_org"
  )
  expect_github_releases_response(releases_from_repos)
  test_mocker$cache(releases_from_repos)
})

test_that("`prepare_releases_table()` prepares releases table", {
  releases_table <- test_graphql_github$prepare_releases_table(
    releases_response = test_mocker$use("releases_from_repos"),
    org = "r-world-devs",
    since = "2023-05-01",
    until = "2023-09-30"
  )
  expect_releases_table(releases_table)
  expect_gt(min(releases_table$published_at), as.POSIXct("2023-05-01"))
  expect_lt(max(releases_table$published_at), as.POSIXct("2023-09-30"))
  test_mocker$cache(releases_table)
})

test_that("`get_release_logs_from_orgs()` works", {
  mockery::stub(
    github_testhost_priv$get_release_logs_from_orgs,
    "graphql_engine$prepare_releases_table",
    test_mocker$use("releases_table")
  )
  mockery::stub(
    github_testhost_priv$get_release_logs_from_orgs,
    "private$get_repos_names",
    test_mocker$use("gh_repos_names")
  )
  github_testhost_priv$searching_scope <- "org"
  releases_from_orgs <- github_testhost_priv$get_release_logs_from_orgs(
    since    = "2023-05-01",
    until    = "2023-09-30",
    verbose  = FALSE,
    progress = FALSE
  )
  expect_releases_table(releases_from_orgs)
  test_mocker$cache(releases_from_orgs)
})

test_that("`get_release_logs_from_repos()` works", {
  mockery::stub(
    github_testhost_priv$get_release_logs_from_repos,
    "graphql_engine$prepare_releases_table",
    test_mocker$use("releases_table")
  )
  test_org <- "test_org"
  attr(test_org, "type") <- "organization"
  mockery::stub(
    github_testhost_priv$get_release_logs_from_repos,
    "graphql_engine$set_owner_type",
    test_org
  )
  github_testhost_priv$searching_scope <- "repo"
  github_testhost_priv$orgs_repos <- list("test_org" = "TestRepo")
  releases_from_repos <- github_testhost_priv$get_release_logs_from_repos(
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
    github_testhost$get_release_logs,
    "private$get_release_logs_from_repos",
    test_mocker$use("releases_from_repos")
  )
  mockery::stub(
    github_testhost$get_release_logs,
    "private$get_release_logs_from_orgs",
    test_mocker$use("releases_from_orgs")
  )
  releases_table <- github_testhost$get_release_logs(
    since    = "2023-05-01",
    until    = "2023-09-30",
    verbose  = FALSE,
    progress = FALSE
  )
  expect_releases_table(releases_table)
  expect_gt(min(releases_table$published_at), as.POSIXct("2023-05-01"))
  expect_lt(max(releases_table$published_at), as.POSIXct("2023-09-30"))
  test_mocker$cache(releases_table)
})

test_that("`get_release_logs()` is set to scan whole git host", {
  github_testhost_all <- create_github_testhost_all(orgs = "test_org")
  mockery::stub(
    github_testhost_all$get_release_logs,
    "graphql_engine$get_orgs",
    "test_org"
  )
  mockery::stub(
    github_testhost_all$get_release_logs,
    "private$get_release_logs_from_repos",
    test_mocker$use("releases_from_repos")
  )
  mockery::stub(
    github_testhost_all$get_release_logs,
    "private$get_release_logs_from_orgs",
    test_mocker$use("releases_from_orgs")
  )
  expect_snapshot(
    gh_releases_table <- github_testhost_all$get_release_logs(
      since    = "2023-01-01",
      until    = "2023-02-28",
      verbose  = TRUE,
      progress = FALSE
    )
  )
})
