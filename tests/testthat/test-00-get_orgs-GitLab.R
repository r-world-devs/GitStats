test_that("groups GitLab query is built properly", {
  gl_orgs_query <-
    test_gqlquery_gl$groups()
  expect_snapshot(
    gl_orgs_query
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

test_that("get_orgs works on GitHost level", {
  mockery::stub(
    gitlab_testhost$get_orgs,
    "graphql_engine$get_orgs",
    test_mocker$use("gl_orgs_full_response")
  )
  gitlab_orgs_table <- gitlab_testhost$get_orgs(
    output = "full_table",
    verbose = FALSE
  )
  expect_orgs_table(
    gitlab_orgs_table,
    add_cols = c("host_url", "host_name")
  )
  test_mocker$cache(gitlab_orgs_table)
})

test_that("get_orgs prints message", {
  mockery::stub(
    gitlab_testhost$get_orgs,
    "graphql_engine$get_orgs",
    test_mocker$use("gl_orgs_full_response")
  )
  expect_snapshot(
    gitlab_orgs_table <- gitlab_testhost$get_orgs(
      output = "full_table",
      verbose = TRUE
    )
  )
})
