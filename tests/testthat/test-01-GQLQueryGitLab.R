test_gqlquery_gl <- GQLQueryGitLab$new()

test_that("repos_by_org query is built properly", {
  gl_repos_by_org_query <-
    test_gqlquery_gl$repos_by_org(
      org = "mbtests"
    )
  expect_snapshot(
    gl_repos_by_org_query
  )
  test_mocker$cache(gl_repos_by_org_query)
})
