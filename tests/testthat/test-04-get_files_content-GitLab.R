test_that("file queries for GitLab are built properly", {
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

test_that("get_file_blobs_response() works", {
  mockery::stub(
    test_graphql_gitlab_priv$get_file_blobs_response,
    "self$gql_response",
    test_fixtures$gitlab_file_repo_response
  )
  gl_file_blobs_response <- test_graphql_gitlab_priv$get_file_blobs_response(
    org = "mbtests",
    repo = "graphql_tests",
    file_path = c("project_metadata.yaml", "README.md")
  )
  expect_gitlab_files_blob_response(gl_file_blobs_response)
  test_mocker$cache(gl_file_blobs_response)
})

test_that("get_repos_data pulls data on repositories", {
  mockery::stub(
    test_graphql_gitlab_priv$get_repos_data,
    "self$get_repos_from_org",
    test_mocker$use("gl_repos_from_org")
  )
  gl_repos_data <- test_graphql_gitlab_priv$get_repos_data(
    org = "mbtests",
    repos = NULL
  )
  expect_true(
    length(gl_repos_data) > 0
  )
  test_mocker$cache(gl_repos_data)
})

test_that("GitLab GraphQL Engine pulls files from a group", {
  mockery::stub(
    test_graphql_gitlab$get_files_from_org,
    "self$get_repos_data",
    test_mocker$use("gl_repos_data")
  )
  mockery::stub(
    test_graphql_gitlab$get_files_from_org,
    "self$gql_response",
    test_fixtures$gitlab_file_org_response
  )
  gitlab_files_response <- test_graphql_gitlab$get_files_from_org(
    org = "mbtests",
    type = "organization",
    repos = NULL,
    file_paths = "meta_data.yaml",
    host_files_structure = NULL
  )
  expect_gitlab_files_from_org_response(gitlab_files_response)
  test_mocker$cache(gitlab_files_response)
})

test_that("GitLab GraphQL Engine pulls files from org by iterating over repos", {
  mockery::stub(
    test_graphql_gitlab$get_files_from_org_per_repo,
    "self$get_repos_data",
    test_mocker$use("gl_repos_data")
  )
  mockery::stub(
    test_graphql_gitlab$get_files_from_org_per_repo,
    "private$get_file_blobs_response",
    test_mocker$use("gl_file_blobs_response")
  )
  gl_files_from_org_per_repo <- test_graphql_gitlab$get_files_from_org_per_repo(
    org = "test_org",
    repos = "TestProject",
    file_paths = c("project_metadata.yaml", "README.md")
  )
  expect_gitlab_files_from_org_by_repos_response(
    response = gl_files_from_org_per_repo,
    expected_files = c("project_metadata.yaml", "README.md")
  )
  test_mocker$cache(gl_files_from_org_per_repo)
})

test_that("is query error is FALSE when response is empty (non query error)", {
  expect_false(
    test_graphql_gitlab_priv$is_query_error(list())
  )
})

test_that("Gitlab GraphQL switches to pulling files per repositories when query is too complex", {
  mockery::stub(
    test_graphql_gitlab$get_files_from_org,
    "self$get_repos_data",
    test_mocker$use("gl_repos_data")
  )
  mockery::stub(
    test_graphql_gitlab$get_files_from_org,
    "private$is_query_error",
    TRUE
  )
  mockery::stub(
    test_graphql_gitlab$get_files_from_org,
    "private$is_complexity_error",
    TRUE
  )
  mockery::stub(
    test_graphql_gitlab$get_files_from_org,
    "self$get_files_from_org_per_repo",
    test_mocker$use("gl_files_from_org_per_repo")
  )
  gitlab_files_response_by_repos <- test_graphql_gitlab$get_files_from_org(
    org = "mbtests",
    type = "organization",
    repos = NULL,
    file_paths = c("project_metadata.yaml", "README.md"),
    host_files_structure = NULL,
    verbose = FALSE,
    progress = FALSE
  )
  expect_gitlab_files_from_org_by_repos_response(
    response = gitlab_files_response_by_repos,
    expected_files = c("project_metadata.yaml", "README.md")
  )
  test_mocker$cache(gitlab_files_response_by_repos)
})

test_that("GitLab GraphQL switches to iteration when query is too complex", {
  mockery::stub(
    test_graphql_gitlab$get_files_from_org_per_repo,
    "private$get_file_blobs_response",
    test_mocker$use("gl_file_blobs_response")
  )
  mockery::stub(
    test_graphql_gitlab$get_files_from_org_per_repo,
    "private$is_complexity_error",
    TRUE
  )
  expect_snapshot(
    files_from_org_per_repo <- test_graphql_gitlab$get_files_from_org_per_repo(
      org = "mbtests",
      type = "organization",
      repos = "gitstatstesting",
      file_paths = c("project_metadata.yaml", "README.md"),
      host_files_structure = NULL,
      verbose = TRUE,
      progress = FALSE
    )
  )
})

test_that("checker properly identifies gitlab files responses", {
  expect_false(
    test_graphql_gitlab_priv$response_prepared_by_iteration(
      files_response = test_mocker$use("gitlab_files_response")
    )
  )
  expect_true(
    test_graphql_gitlab_priv$response_prepared_by_iteration(
      files_response = test_mocker$use("gitlab_files_response_by_repos")
    )
  )
})

test_that("GitLab prepares table from files response", {
  gl_files_table <- test_graphql_gitlab$prepare_files_table(
    files_response = test_mocker$use("gitlab_files_response"),
    org = "mbtests"
  )
  expect_files_table(gl_files_table)
  test_mocker$cache(gl_files_table)
})

test_that("GitLab prepares table from files response prepared in alternative way", {
  gl_files_table <- test_graphql_gitlab$prepare_files_table(
    files_response = test_mocker$use("gitlab_files_response_by_repos"),
    org = "mbtests"
  )
  expect_files_table(gl_files_table)
})

test_that("get_files_content_from_orgs for GitLab works", {
  mockery::stub(
    gitlab_testhost_priv$get_files_content_from_orgs,
    "graphql_engine$prepare_files_table",
    test_mocker$use("gl_files_table")
  )
  suppressMessages(
    gl_files_table <- gitlab_testhost_priv$get_files_content_from_orgs(
      file_path = "meta_data.yaml",
      verbose = FALSE
    )
  )
  expect_files_table(
    gl_files_table, with_cols = "api_url"
  )
  test_mocker$cache(gl_files_table)
})

test_that("get_files_content makes use of files_structure", {
  mockery::stub(
    gitlab_testhost_priv$get_files_content_from_files_structure,
    "private$add_repo_api_url",
    test_mocker$use("gl_files_table")
  )
  expect_snapshot(
    files_content <- gitlab_testhost_priv$get_files_content_from_files_structure(
      files_structure = test_mocker$use("gl_files_structure_from_orgs")
    )
  )
  expect_files_table(
    files_content,
    with_cols = "api_url"
  )
})
