test_that("is_query_error works", {
  expect_true(test_graphql_github_priv$is_query_error(test_error_fixtures$graphql_error_no_groups))
  expect_true(test_graphql_github_priv$is_query_error(test_error_fixtures$graphql_error_no_count_languages))
})

test_that("is_no_fields_query_error works", {
  expect_true(test_graphql_github_priv$is_no_fields_query_error(test_error_fixtures$graphql_error_no_groups))
  expect_true(test_graphql_github_priv$is_no_fields_query_error(test_error_fixtures$graphql_error_no_count_languages))
  expect_false(test_graphql_github_priv$is_no_fields_query_error(test_error_fixtures$graphql_server_error))
})

test_that("is_server_error works", {
  expect_true(test_graphql_github_priv$is_server_error(test_error_fixtures$graphql_server_error))
  expect_false(test_graphql_github_priv$is_server_error(test_error_fixtures$graphql_error_no_count_languages))
})

test_that("is_complexity_error works", {
  expect_true(test_graphql_github_priv$is_complexity_error(test_error_fixtures$graphql_complexity_error))
  expect_false(test_graphql_github_priv$is_complexity_error(test_error_fixtures$graphql_error_no_groups))
})

test_that("set_graphql_error_class works", {
  error_class_object <- test_graphql_github_priv$set_graphql_error_class(
    test_error_fixtures$graphql_error_no_groups
  )
  expect_true(
    all(c("graphql_error", "graphql_no_fields_error") %in% class(error_class_object))
  )
})
