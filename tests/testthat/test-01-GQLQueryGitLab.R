test_that("user query is built properly", {
  gl_user_query <-
    test_gqlquery_gl$user()
  expect_snapshot(
    gl_user_query
  )
  test_mocker$cache(gl_user_query)
})

test_that("releases query is built properly", {
  gl_releases_query <-
    test_gqlquery_gl$releases_from_repo()
  expect_snapshot(
    gl_releases_query
  )
})
