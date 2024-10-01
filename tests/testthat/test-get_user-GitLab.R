test_that("user query is built properly", {
  gl_user_query <-
    test_gqlquery_gl$user()
  expect_snapshot(
    gl_user_query
  )
  test_mocker$cache(gl_user_query)
})

test_that("`gql_response()` work as expected for GitLab", {
  gl_user_gql_response <- test_graphql_gitlab$gql_response(
    test_mocker$use("gl_user_query"),
    vars = list(user = "maciekbanas")
  )
  expect_user_gql_response(
    gl_user_gql_response
  )
  test_mocker$cache(gl_user_gql_response)
})


test_that("get_user pulls GitLab user response", {
  mockery::stub(
    test_graphql_gitlab$get_user,
    "self$gql_response",
    test_mocker$use("gl_user_gql_response")
  )
  gl_user_response <- test_graphql_gitlab$get_user(username = "maciekbanas")
  expect_user_gql_response(
    gl_user_response
  )
  test_mocker$cache(gl_user_response)
})

test_that("GitLab prepares user table", {
  gl_user_table <- gitlab_testhost_priv$prepare_user_table(
    user_response = test_mocker$use("gl_user_response")
  )
  expect_users_table(
    gl_user_table,
    one_user = TRUE
  )
  test_mocker$cache(gl_user_table)
})

test_that("get_users build users table for GitHub", {
  users_result <- gitlab_testhost$get_users(
    users = c("maciekbanas", "Cotau", "marcinkowskak")
  )
  expect_users_table(
    users_result
  )
})

test_that("get_users build users table for GitLab", {
  users_result <- gitlab_testhost$get_users(
    users = c("maciekbanas", "Cotau", "marcinkowskak")
  )
  expect_users_table(
    users_result
  )
})
