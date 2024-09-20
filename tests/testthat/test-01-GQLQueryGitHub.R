test_that("user query is built properly", {
  gh_user_query <-
    test_gqlquery_gh$user()
  expect_snapshot(
    gh_user_query
  )
  test_mocker$cache(gh_user_query)
})

test_that("releases query is built properly", {
  gh_releases_query <-
    test_gqlquery_gh$releases_from_repo()
  expect_snapshot(
    gh_releases_query
  )
})
