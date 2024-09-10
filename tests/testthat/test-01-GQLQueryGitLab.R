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

test_that("file queries are built properly", {
  gl_files_query <-
    test_gqlquery_gl$files_by_org()
  expect_snapshot(
    gl_files_query
  )
  gl_file_blobs_from_repo_query <-
    test_gqlquery_gl$file_blob_from_repo()
  expect_snapshot(
    gl_file_blobs_from_repo_query
  )
  test_mocker$cache(gl_file_blobs_from_repo_query)
})

test_that("releases query is built properly", {
  gl_releases_query <-
    test_gqlquery_gl$releases_from_repo()
  expect_snapshot(
    gl_releases_query
  )
})

test_that("files_tree query is built properly", {
  gl_files_tree_query <-
    test_gqlquery_gl$files_tree_from_repo()
  expect_snapshot(
    gl_files_tree_query
  )
  test_mocker$cache(gl_files_tree_query)
})
