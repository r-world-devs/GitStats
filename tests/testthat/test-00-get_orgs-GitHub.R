test_that("orgs GitHub query is built properly", {
  gh_orgs_query <-
    test_gqlquery_gh$orgs(
      end_cursor = ""
    )
  expect_snapshot(
    gh_orgs_query
  )
})

test_that("org GitHub query is built properly", {
  gh_org_query <-
    test_gqlquery_gh$org()
  expect_snapshot(
    gh_org_query
  )
})

test_that("get_orgs pulls responses from GraphQL", {
  mockery::stub(
    test_graphql_github$get_orgs,
    "self$gql_response",
    test_fixtures$graphql_gh_orgs_response
  )
  gh_orgs_raw_response <- test_graphql_github$get_orgs(
    output = "only_names",
    verbose = FALSE
  )
  expect_type(
    gh_orgs_raw_response,
    "character"
  )
  test_mocker$cache(gh_orgs_raw_response)
  gh_orgs_full_response <- test_graphql_github$get_orgs(
    output = "full_table",
    verbose = FALSE
  )
  expect_type(
    gh_orgs_full_response,
    "list"
  )
  expect_github_orgs_full_list(gh_orgs_full_response)
  test_mocker$cache(gh_orgs_full_response)
})


test_that("get_orgs breaks when meet GraphQL error", {
  graphql_error <- ""
  class(graphql_error) <- "graphql_error"
  mockery::stub(
    test_graphql_github$get_orgs,
    "self$gql_response",
    graphql_error
  )
  gh_orgs_raw_response <- test_graphql_github$get_orgs(
    output = "only_names",
    verbose = FALSE
  )
  expect_s3_class(
    gh_orgs_raw_response,
    "graphql_error"
  )
})

test_that("get_orgs prints message", {
  mockery::stub(
    test_graphql_github$get_orgs,
    "self$gql_response",
    test_fixtures$graphql_gh_orgs_response
  )
  expect_snapshot(
    gh_orgs_full_response <- test_graphql_github$get_orgs(
      output = "full_table",
      verbose = TRUE
    )
  )
})

test_that("prepare_orgs_table works", {
  github_orgs_table <- test_graphql_github$prepare_orgs_table(
    full_orgs_list = test_mocker$use("gh_orgs_full_response")
  )
  expect_orgs_table(
    github_orgs_table
  )
  test_mocker$cache(github_orgs_table)
})

test_that("get_org pulls response for one org from GraphQL", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_github$get_org,
      "self$gql_response",
      test_fixtures$graphql_gh_org_response
    )
    org <- "test_org"
  } else {
    org <- "r-world-devs"
  }
  gh_org_response <- test_graphql_github$get_org(
    org = org
  )
  expect_type(gh_org_response, "list")
  test_mocker$cache(gh_org_response)
})

test_that("get_orgs_from_host returns error when GitHost is public", {
  github_testhost_priv$is_public <- TRUE
  expect_snapshot_error(
    github_testhost_priv$get_orgs_from_host(
      output = "full_table",
      verbose = FALSE
    )
  )
})

test_that("get_orgs_from_host works on GitHost level", {
  github_testhost_priv$is_public <- FALSE
  mockery::stub(
    github_testhost_priv$get_orgs_from_host,
    "graphql_engine$get_orgs",
    test_mocker$use("gh_orgs_full_response")
  )
  github_orgs_table <- github_testhost_priv$get_orgs_from_host(
    output = "full_table",
    verbose = FALSE
  )
  expect_orgs_table(
    github_orgs_table
  )
  test_mocker$cache(github_orgs_table)
})

test_that("get_orgs_from_orgs_and_repos works on GitHost level", {
  mockery::stub(
    github_testhost_priv$get_orgs_from_orgs_and_repos,
    "graphql_engine$get_org",
    test_mocker$use("gh_org_response")
  )
  github_orgs_from_orgs_table <- github_testhost_priv$get_orgs_from_orgs_and_repos(
    verbose = FALSE
  )
  expect_orgs_table(
    github_orgs_from_orgs_table
  )
  test_mocker$cache(github_orgs_from_orgs_table)
})

test_that("get_orgs works on GitHost level", {
  mockery::stub(
    github_testhost$get_orgs,
    "private$get_orgs_from_hosts",
    test_mocker$use("github_orgs_table")
  )
  mockery::stub(
    github_testhost$get_orgs,
    "private$get_orgs_from_orgs_and_repos",
    test_mocker$use("github_orgs_from_orgs_table")
  )
  github_orgs_table <- github_testhost$get_orgs(
    output = "full_table",
    verbose = FALSE
  )
  expect_orgs_table(
    github_orgs_table,
    add_cols = c("host_url", "host_name")
  )
  test_mocker$cache(github_orgs_table)
})
