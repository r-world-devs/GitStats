test_that("orgs GitHub query is built properly", {
  gh_orgs_query <-
    test_gqlquery_gh$orgs(
      end_cursor = ""
    )
  expect_snapshot(
    gh_orgs_query
  )
})

test_that("get_orgs pulls responses from GraphQL", {
  mockery::stub(
    test_graphql_github$get_orgs,
    "self$gql_response",
    test_fixtures$graphql_gh_orgs_response
  )
  gh_orgs_raw_response <- test_graphql_github$get_orgs(
    output = "only_names"
  )
  expect_type(
    gh_orgs_raw_response,
    "character"
  )
  test_mocker$cache(gh_orgs_raw_response)
  gh_orgs_full_response <- test_graphql_github$get_orgs(
    output = "full_table"
  )
  expect_type(
    gh_orgs_full_response,
    "list"
  )
  expect_github_orgs_full_list(gh_orgs_full_response)
  test_mocker$cache(gh_orgs_full_response)
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

test_that("get_orgs works on GitHost level", {
  mockery::stub(
    github_testhost$get_orgs,
    "graphql_engine$get_orgs",
    test_mocker$use("gh_orgs_full_response")
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

test_that("get_orgs prints message", {
  mockery::stub(
    github_testhost$get_orgs,
    "graphql_engine$get_orgs",
    test_mocker$use("gh_orgs_full_response")
  )
  expect_snapshot(
    github_orgs_table <- github_testhost$get_orgs(
      output = "full_table",
      verbose = TRUE
    )
  )
})
