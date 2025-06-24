test_that("groups GitLab query is built properly", {
  gl_orgs_query <-
    test_gqlquery_gl$groups()
  expect_snapshot(
    gl_orgs_query
  )
})

test_that("group GitLab query is built properly", {
  gl_org_query <-
    test_gqlquery_gl$group()
  expect_snapshot(
    gl_org_query
  )
})

test_that("get_orgs_count works", {
  mockery::stub(
    test_rest_gitlab$get_orgs_count,
    "private$perform_request",
    test_fixtures$rest_gl_orgs_response
  )
  orgs_count <- test_rest_gitlab$get_orgs_count(verbose = FALSE)
  expect_type(
    orgs_count,
    "character"
  )
  expect_type(
    as.integer(orgs_count),
    "integer"
  )
})

test_that("get_orgs_count prints message", {
  mockery::stub(
    test_rest_gitlab$get_orgs_count,
    "private$perform_request",
    test_fixtures$rest_gl_orgs_response
  )
  expect_snapshot(
    orgs_count <- test_rest_gitlab$get_orgs_count(verbose = TRUE)
  )
})

test_that("get_orgs pulls responses from GraphQL", {
  mockery::stub(
    test_graphql_gitlab$get_orgs,
    "self$gql_response",
    test_fixtures$graphql_gl_orgs_response
  )
  gl_orgs_raw_response <- test_graphql_gitlab$get_orgs(
    orgs_count = 3L,
    output = "only_names",
    verbose = FALSE
  )
  expect_type(
    gl_orgs_raw_response,
    "character"
  )
  test_mocker$cache(gl_orgs_raw_response)
  gl_orgs_full_response <- test_graphql_gitlab$get_orgs(
    orgs_count = 3L,
    output = "full_table",
    verbose = FALSE
  )
  expect_type(
    gl_orgs_full_response,
    "list"
  )
  expect_gitlab_orgs_full_list(gl_orgs_full_response)
  test_mocker$cache(gl_orgs_full_response)
})

test_that("get_orgs prints message", {
  mockery::stub(
    test_graphql_gitlab$get_orgs,
    "self$gql_response",
    test_fixtures$graphql_gl_orgs_response
  )
  expect_snapshot(
    gl_orgs_full_response <- test_graphql_gitlab$get_orgs(
      orgs_count = 3L,
      output = "full_table",
      verbose = TRUE,
      progress = FALSE
    )
  )
})

test_that("if get_orgs runs into GraphQL error, it returns object of graphql_error class", {
  mockery::stub(
    test_graphql_gitlab$get_orgs,
    "self$gql_response",
    test_fixtures$graphql_error_no_fields
  )
  gl_orgs_error_response <- test_graphql_gitlab$get_orgs(
    orgs_count = 3L,
    output = "full_table",
    verbose = FALSE,
    progress = FALSE
  )
  expect_s3_class(gl_orgs_error_response, "graphql_error")
  test_mocker$cache(gl_orgs_error_response)
})

test_that("if get_orgs runs into GraphQL error, it prints warning", {
  mockery::stub(
    test_graphql_gitlab$get_orgs,
    "self$gql_response",
    test_fixtures$graphql_error_no_fields
  )
  expect_snapshot(
    gl_orgs_error_response <- test_graphql_gitlab$get_orgs(
      orgs_count = 3L,
      output = "full_table",
      verbose = TRUE,
      progress = FALSE
    )
  )
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
    org = org,
    verbose = FALSE
  )
  expect_type(gl_org_response, "list")
  test_mocker$cache(gl_org_response)
})

test_that("get_org prints proper message", {
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
  expect_snapshot(
    gl_org_response <- test_graphql_gitlab$get_org(
      org = org,
      verbose = TRUE
    )
  )
})

test_that("get_org sets error class to response", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_gitlab$get_org,
      "self$gql_response",
      list()
    )
    org <- "test_org"
  } else {
    org <- "mbtests"
  }
  gl_org_error_response <- test_graphql_gitlab$get_org(
    org = org,
    verbose = FALSE
  )
  expect_type(gl_org_error_response, "list")
  expect_s3_class(gl_org_error_response, "graphql_error")
  test_mocker$cache(gl_org_error_response)
})

test_that("get_org pulls response for one org from REST", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_rest_gitlab$get_org,
      "self$response",
      test_fixtures$rest_gl_org_response
    )
    org <- "test_org"
  } else {
    org <- "mbtests"
  }
  gl_org_rest_response <- test_rest_gitlab$get_org(
    org = "mbtests",
    verbose = FALSE
  )
  expect_type(gl_org_rest_response, "list")
  expect_true(
    all(c("id", "web_url", "name", "path", "description") %in% names(gl_org_rest_response))
  )
  test_mocker$cache(gl_org_rest_response)
})

test_that("get_org prints proper message", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_rest_gitlab$get_org,
      "self$response",
      test_fixtures$rest_gl_org_response
    )
    org <- "test_org"
  } else {
    org <- "mbtests"
  }
  expect_snapshot(
    gl_org_response <- test_rest_gitlab$get_org(
      org = org,
      verbose = TRUE
    )
  )
})

test_that("REST method get_orgs works", {
  gl_orgs_rest_list <- test_rest_gitlab$get_orgs(
    orgs_count = 300L,
    verbose = FALSE
  )
  expect_type(gl_orgs_rest_list, "list")
  expect_length(gl_orgs_rest_list, 300L)
  expect_true(all(c("name", "id", "web_url", "path") %in% names(gl_orgs_rest_list[[1]])))
  test_mocker$cache(gl_orgs_rest_list)
})

test_that("REST method prints message", {
  expect_snapshot(
    gl_orgs_rest_list <- test_rest_gitlab$get_orgs(
      orgs_count = 300L,
      verbose = TRUE,
      progress = FALSE
    )
  )
})

test_that("table is prepared from REST orgs response", {
  gitlab_org_rest_table <- test_rest_gitlab$prepare_orgs_table(
    orgs_list = test_mocker$use("gl_orgs_rest_list")
  )
  expect_s3_class(gitlab_org_rest_table, "data.frame")
  test_mocker$cache(gitlab_org_rest_table)
})

test_that("if get_orgs_from_host runs into GraphQL error, it switches to REST API", {
  gitlab_test_host_priv_2 <- create_gitlab_testhost(
    orgs = "mbtests",
    mode = "private"
  )
  mockery::stub(
    gitlab_test_host_priv_2$get_orgs_from_host,
    "graphql_engine$get_orgs",
    test_mocker$use("gl_orgs_error_response")
  )
  mockery::stub(
    gitlab_test_host_priv_2$get_orgs_from_host,
    "rest_engine$get_orgs",
    test_mocker$use("gl_orgs_rest_list")
  )
  gitlab_test_host_priv_2$is_public <- FALSE
  expect_snapshot(
    gitlab_orgs_vec <- gitlab_test_host_priv_2$get_orgs_from_host(
      output = "only_names",
      verbose = TRUE
    )
  )
  expect_type(gitlab_orgs_vec, "character")
  expect_length(gitlab_orgs_vec, 300L)
})

test_that("if get_orgs_from_host runs into GraphQL error, it switches to REST API", {
  gitlab_test_host_priv_2 <- create_gitlab_testhost(
    orgs = "mbtests",
    mode = "private"
  )
  gitlab_test_host_priv_2$is_public <- FALSE
  mockery::stub(
    gitlab_test_host_priv_2$get_orgs_from_host,
    "graphql_engine$get_orgs",
    test_mocker$use("gl_orgs_error_response")
  )
  mockery::stub(
    gitlab_test_host_priv_2$get_orgs_from_host,
    "rest_engine$get_orgs",
    test_mocker$use("gl_orgs_rest_list")
  )
  mockery::stub(
    gitlab_test_host_priv_2$get_orgs_from_host,
    "rest_engine$prepare_orgs_table",
    test_mocker$use("gitlab_org_rest_table")
  )
  expect_snapshot(
    gitlab_orgs_table <- gitlab_test_host_priv_2$get_orgs_from_host(
      output = "full_table",
      verbose = TRUE
    )
  )
  expect_s3_class(gitlab_orgs_table, "data.frame")
  expect_equal(nrow(gitlab_orgs_table), 300L)
})

test_that("get_orgs_from_host works on GitHost level", {
  mockery::stub(
    gitlab_testhost_priv$get_orgs_from_host,
    "graphql_engine$get_orgs",
    test_mocker$use("gl_orgs_full_response")
  )
  gitlab_testhost_priv$is_public <- FALSE
  gitlab_orgs_table <- gitlab_testhost_priv$get_orgs_from_host(
    output = "full_table",
    verbose = FALSE
  )
  expect_orgs_table(
    gitlab_orgs_table
  )
  test_mocker$cache(gitlab_orgs_table)
})

test_that("get_orgs_from_host prints message on number of organizations", {
  mockery::stub(
    gitlab_testhost_priv$get_orgs_from_host,
    "rest_engine$get_orgs_count",
    3L
  )
  gitlab_testhost_priv$is_public <- FALSE
  mockery::stub(
    gitlab_testhost_priv$get_orgs_from_host,
    "graphql_engine$get_orgs",
    test_mocker$use("gl_orgs_full_response")
  )
  expect_snapshot(
    gitlab_orgs_table <- gitlab_testhost_priv$get_orgs_from_host(
      output = "full_table",
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

test_that("get_orgs_from_orgs_and_repos works on GitHost level", {
  mockery::stub(
    gitlab_testhost_priv$get_orgs_from_orgs_and_repos,
    "graphql_engine$get_org",
    test_mocker$use("gl_org_response")
  )
  test_org <- "test_org"
  attr(test_org, "type") <- "organization"
  mockery::stub(
    gitlab_testhost_priv$get_orgs_from_orgs_and_repos,
    "graphql_engine$set_owner_type",
    test_org
  )
  gitlab_orgs_from_orgs_table <- gitlab_testhost_priv$get_orgs_from_orgs_and_repos(
    verbose = FALSE
  )
  expect_orgs_table(
    gitlab_orgs_from_orgs_table
  )
  test_mocker$cache(gitlab_orgs_from_orgs_table)
})

test_that("get_orgs_from_orgs_and_repos turns to REST if GraphQL fails", {
  mockery::stub(
    gitlab_testhost_priv$get_orgs_from_orgs_and_repos,
    "graphql_engine$get_org",
    test_mocker$use("gl_org_error_response")
  )
  test_org <- "test_org"
  attr(test_org, "type") <- "organization"
  mockery::stub(
    gitlab_testhost_priv$get_orgs_from_orgs_and_repos,
    "graphql_engine$set_owner_type",
    test_org
  )
  mockery::stub(
    gitlab_testhost_priv$get_orgs_from_orgs_and_repos,
    "rest_engine$get_org",
    test_mocker$use("gl_org_rest_response")
  )
  mockery::stub(
    gitlab_testhost_priv$get_orgs_from_orgs_and_repos,
    "default_engine$prepare_orgs_table",
    test_mocker$use("gitlab_org_rest_table")
  )
  gitlab_orgs_from_orgs_table <- gitlab_testhost_priv$get_orgs_from_orgs_and_repos(
    verbose = FALSE
  )
  expect_orgs_table(
    gitlab_orgs_from_orgs_table
  )
  test_mocker$cache(gitlab_orgs_from_orgs_table)
})

test_that("get_orgs_from_orgs_and_repos prints message when turning to REST engine", {
  mockery::stub(
    gitlab_testhost_priv$get_orgs_from_orgs_and_repos,
    "graphql_engine$get_org",
    test_mocker$use("gl_org_error_response")
  )
  test_org <- "test_org"
  attr(test_org, "type") <- "organization"
  mockery::stub(
    gitlab_testhost_priv$get_orgs_from_orgs_and_repos,
    "graphql_engine$set_owner_type",
    test_org
  )
  mockery::stub(
    gitlab_testhost_priv$get_orgs_from_orgs_and_repos,
    "rest_engine$get_org",
    test_mocker$use("gl_org_rest_response")
  )
  mockery::stub(
    gitlab_testhost_priv$get_orgs_from_orgs_and_repos,
    "default_engine$prepare_orgs_table",
    test_mocker$use("gitlab_org_rest_table")
  )
  expect_snapshot(
    gitlab_orgs_from_orgs_table <- gitlab_testhost_priv$get_orgs_from_orgs_and_repos(
      verbose = TRUE
    )
  )
})

test_that("get_orgs_from_host returns error when GitHost is public", {
  gitlab_testhost_priv$is_public <- TRUE
  expect_snapshot_error(
    gitlab_testhost_priv$get_orgs_from_host(
      output = "full_table",
      verbose = FALSE
    )
  )
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
    output = "full_table",
    verbose = FALSE
  )
  expect_orgs_table(
    gitlab_orgs_table,
    add_cols = c("host_url", "host_name")
  )
  test_mocker$cache(gitlab_orgs_table)
})
