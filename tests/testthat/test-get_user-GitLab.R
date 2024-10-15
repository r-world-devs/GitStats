test_that("user query is built properly", {
  gl_user_query <-
    test_gqlquery_gl$user()
  expect_snapshot(
    gl_user_query
  )
  test_mocker$cache(gl_user_query)
})

test_that("get_user pulls GitLab user response", {
  mockery::stub(
    test_graphql_gitlab$get_user,
    "self$gql_response",
    test_fixtures$gitlab_user_response
  )
  gl_user_response <- test_graphql_gitlab$get_user(username = "testuser")
  expect_user_gql_response(
    gl_user_response
  )
  test_mocker$cache(gl_user_response)
})

test_that("GitLab prepares user table", {
  gl_user_table <- test_graphql_gitlab$prepare_user_table(
    user_response = test_mocker$use("gl_user_response")
  )
  expect_users_table(
    gl_user_table,
    one_user = TRUE
  )
  test_mocker$cache(gl_user_table)
})

test_that("get_users build users table for GitLab", {
  mockery::stub(
    gitlab_testhost$get_users,
    "graphql_engine$prepare_user_table",
    test_mocker$use("gl_user_table")
  )
  gitlab_users <- gitlab_testhost$get_users(
    users = c("testuser1", "testuser2")
  )
  expect_users_table(
    gitlab_users
  )
  test_mocker$cache(gitlab_users)
})
