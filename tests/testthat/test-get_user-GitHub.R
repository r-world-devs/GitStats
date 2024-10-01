test_that("user query is built properly", {
  gh_user_query <-
    test_gqlquery_gh$user()
  expect_snapshot(
    gh_user_query
  )
  test_mocker$cache(gh_user_query)
})

test_that("`gql_response()` work as expected for GitHub", {
  gh_user_gql_response <- test_graphql_github$gql_response(
    test_mocker$use("gh_user_query"),
    vars = list(user = "maciekbanas")
  )
  expect_user_gql_response(
    gh_user_gql_response
  )
  test_mocker$cache(gh_user_gql_response)
})

test_that("get_user pulls GitHub user response", {
  mockery::stub(
    test_graphql_github$get_user,
    "self$gql_response",
    test_mocker$use("gh_user_gql_response")
  )
  gh_user_response <- test_graphql_github$get_user(username = "maciekbanas")
  expect_user_gql_response(
    gh_user_response
  )
  test_mocker$cache(gh_user_response)
})

test_that("GitHub prepares user table", {
  gh_user_table <- github_testhost_priv$prepare_user_table(
    user_response = test_mocker$use("gh_user_response")
  )
  expect_users_table(
    gh_user_table,
    one_user = TRUE
  )
  test_mocker$cache(gh_user_table)
})

test_that("GitHost gets users tables", {
  users_table <- github_testhost$get_users(
    users = c("maciekbanas", "kalimu", "galachad")
  )
  expect_users_table(users_table)
  test_mocker$cache(users_table)
})
