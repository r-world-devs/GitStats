test_that("is_query_error works", {
  expect_true(test_graphql_github_priv$is_query_error(test_error_fixtures$graphql_error_no_groups))
  expect_true(test_graphql_github_priv$is_query_error(test_error_fixtures$graphql_error_no_count_languages))
})

test_that("is_no_fields_query_error works", {
  expect_true(test_graphql_github_priv$is_no_fields_query_error(test_error_fixtures$graphql_error_no_groups))
  expect_true(test_graphql_github_priv$is_no_fields_query_error(test_error_fixtures$graphql_error_no_count_languages))
})
