test_that("user query is built properly", {
  gh_user_query <-
    test_gqlquery_gh$user()
  expect_snapshot(
    gh_user_query
  )
  test_mocker$cache(gh_user_query)
})

test_that("get_user pulls GitHub user response", {
  mockery::stub(
    test_graphql_github$get_user,
    "self$gql_response",
    test_fixtures$github_user_response
  )
  gh_user_response <- test_graphql_github$get_user(username = "testuser")
  expect_user_gql_response(
    gh_user_response
  )
  test_mocker$cache(gh_user_response)
})

test_that("GitHub prepares user table", {
  gh_user_table <- test_graphql_github$prepare_user_table(
    user_response = test_mocker$use("gh_user_response")
  )
  expect_users_table(
    gh_user_table,
    one_user = TRUE
  )
  test_mocker$cache(gh_user_table)
})

test_that("GitHost gets users tables", {
  mockery::stub(
    github_testhost$get_users,
    "graphql_engine$prepare_user_table",
    test_mocker$use("gh_user_table")
  )
  github_users <- github_testhost$get_users(
    users = c("testuser1", "testuser2")
  )
  expect_users_table(github_users)
  test_mocker$cache(github_users)
})
