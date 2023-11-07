test_gqlquery_gl <- GQLQueryGitLab$new()

test_that("repos queries are built properly", {
  gl_repos_by_org_query <-
    test_gqlquery_gl$repos_by_org()
  expect_snapshot(
    gl_repos_by_org_query
  )
  test_mocker$cache(gl_repos_by_org_query)
})

test_that("user query is built properly", {
  gl_user_query <-
    test_gqlquery_gl$user()
  expect_snapshot(
    gl_user_query
  )
  test_mocker$cache(gl_user_query)
})

test_that("file query is built properly", {
  gl_files_query <-
    test_gqlquery_gl$files_by_org()
  expect_snapshot(
    gl_files_query
  )
})
