test_that("groups GitLab query is built properly", {
  gl_orgs_query <-
    test_gqlquery_gl$groups()
  expect_snapshot(
    gl_orgs_query
  )
})

test_that("group GitLab query is built properly", {
  gl_org_query <-
    test_gqlquery_gl$group
  expect_snapshot(
    gl_org_query
  )
})

test_that("get_orgs pulls responses from GraphQL", {
  mockery::stub(
    test_graphql_gitlab$get_orgs,
    "self$gql_response",
    test_fixtures$graphql_gl_orgs_response
  )
  gl_orgs_raw_response <- test_graphql_gitlab$get_orgs(
    output = "only_names"
  )
  expect_type(
    gl_orgs_raw_response,
    "character"
  )
  test_mocker$cache(gl_orgs_raw_response)
  gl_orgs_full_response <- test_graphql_gitlab$get_orgs(
    output = "full_table"
  )
  expect_type(
    gl_orgs_full_response,
    "list"
  )
  expect_gitlab_orgs_full_list(gl_orgs_full_response)
  test_mocker$cache(gl_orgs_full_response)
})

test_that("prepare_orgs_table works", {
  gitlab_orgs_table <- test_graphql_gitlab$prepare_orgs_table(
    full_orgs_list = test_mocker$use("gl_orgs_full_response")
  )
  expect_orgs_table(
    gitlab_orgs_table
  )
})

test_that("get_org pulls response for one org from GraphQL", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_gitlab$get_org,
      "self$gql_response",
      test_fixtures$graphql_gl_org_response
    )
    org <- "test_org"
  } else {
    org <- "mbtests"
  }
  gl_org_response <- test_graphql_gitlab$get_org(
    org = org
  )
  expect_type(gl_org_response, "list")
  test_mocker$cache(gl_org_response)
})

test_that("get_orgs works on GitHost level", {
  mockery::stub(
    gitlab_testhost_priv$get_orgs_from_host,
    "graphql_engine$get_orgs",
    test_mocker$use("gl_orgs_full_response")
  )
  gitlab_orgs_table <- gitlab_testhost_priv$get_orgs_from_host(
    verbose = FALSE
  )
  expect_orgs_table(
    gitlab_orgs_table
  )
  test_mocker$cache(gitlab_orgs_table)
})

test_that("get_orgs prints message", {
  mockery::stub(
    gitlab_testhost_priv$get_orgs_from_host,
    "graphql_engine$get_orgs",
    test_mocker$use("gl_orgs_full_response")
  )
  expect_snapshot(
    gitlab_orgs_table <- gitlab_testhost_priv$get_orgs_from_host(
      verbose = TRUE
    )
  )
})

test_that("get_orgs_from_orgs_and_repos works on GitHost level", {
  mockery::stub(
    gitlab_testhost_priv$get_orgs_from_orgs_and_repos,
    "graphql_engine$get_org",
    test_mocker$use("gl_org_response")
  )
  gitlab_orgs_from_orgs_table <- gitlab_testhost_priv$get_orgs_from_orgs_and_repos(
    verbose = FALSE
  )
  expect_orgs_table(
    gitlab_orgs_from_orgs_table
  )
  test_mocker$cache(gitlab_orgs_from_orgs_table)
})

test_that("get_orgs works on GitHost level", {
  mockery::stub(
    gitlab_testhost$get_orgs,
    "private$get_orgs_from_hosts",
    test_mocker$use("gitlab_orgs_table")
  )
  mockery::stub(
    gitlab_testhost$get_orgs,
    "private$get_orgs_from_orgs_and_repos",
    test_mocker$use("gitlab_orgs_from_orgs_table")
  )
  gitlab_orgs_table <- gitlab_testhost$get_orgs(
    verbose = FALSE
  )
  expect_orgs_table(
    gitlab_orgs_table,
    add_cols = c("host_url", "host_name")
  )
  test_mocker$cache(gitlab_orgs_table)
})
