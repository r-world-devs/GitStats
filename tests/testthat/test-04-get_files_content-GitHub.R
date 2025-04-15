test_that("file queries for GitHub are built properly", {
  gh_file_blobs_from_repo_query <-
    test_gqlquery_gh$file_blob_from_repo()
  expect_snapshot(
    gh_file_blobs_from_repo_query
  )
  test_mocker$cache(gh_file_blobs_from_repo_query)
})

test_that("GitHub GraphQL Engine pulls file response", {
  mockery::stub(
    test_graphql_github_priv$get_file_response,
    "self$gql_response",
    test_fixtures$github_file_response
  )
  github_file_response <- test_graphql_github_priv$get_file_response(
    org         = "r-world-devs",
    repo        = "GitStats",
    def_branch  = "master",
    file_path   = "LICENSE",
    files_query = test_mocker$use("gh_file_blobs_from_repo_query")
  )
  expect_github_files_response(github_file_response)
  test_mocker$cache(github_file_response)
})

test_that("get_repositories_with_files works", {
  mockery::stub(
    test_graphql_github_priv$get_repositories_with_files,
    "private$get_file_response",
    test_mocker$use("github_file_response")
  )
  gh_repositories_with_files <- test_graphql_github_priv$get_repositories_with_files(
    repositories = c("test_repo_1", "test_repo_2", "test_repo_3", "test_repo_4", "test_repo_5"),
    def_branches = c("test_branch_1", "test_branch_2", "test_branch_3", "test_branch_4", "test_branch_5"),
    org = "test_org",
    file_paths = "test_files.txt",
    host_files_structure = NULL,
    progress = FALSE
  )
  expect_type(gh_repositories_with_files, "list")
  test_mocker$cache(gh_repositories_with_files)
})

test_that("GitHub GraphQL Engine pulls files from organization", {
  mockery::stub(
    test_graphql_github$get_files_from_org,
    "private$get_repos_data",
    test_mocker$use("gh_repos_data")
  )
  mockery::stub(
    test_graphql_github$get_files_from_org,
    "private$get_repositories_with_files",
    test_mocker$use("gh_repositories_with_files")
  )
  github_files_response <- test_graphql_github$get_files_from_org(
    org = "test_org",
    owner_type = "organization",
    repos = NULL,
    file_paths = "test_files.txt",
    host_files_structure = NULL,
    verbose = FALSE,
    progress = FALSE
  )
  expect_github_files_response(github_files_response)
  test_mocker$cache(github_files_response)
})

test_that("GitHubHost prepares table from files response", {
  gh_files_table <- test_graphql_github$prepare_files_table(
    files_response = test_mocker$use("github_files_response"),
    org = "r-world-devs"
  )
  expect_files_table(gh_files_table)
  test_mocker$cache(gh_files_table)
})

test_that("get_files_content_from_orgs for GitHub works", {
  mockery::stub(
    github_testhost_priv$get_files_content_from_orgs,
    "graphql_engine$prepare_files_table",
    test_mocker$use("gh_files_table")
  )
  github_testhost_priv$searching_scope <- "org"
  gh_files_from_orgs <- github_testhost_priv$get_files_content_from_orgs(
    file_path = "DESCRIPTION",
    verbose = FALSE
  )
  expect_files_table(
    gh_files_from_orgs,
    with_cols = "api_url"
  )
  test_mocker$cache(gh_files_from_orgs)
})

test_that("get_files_content makes use of files_structure", {
  mockery::stub(
    github_testhost_priv$get_files_content_from_files_structure,
    "private$add_repo_api_url",
    test_mocker$use("gh_files_from_orgs")
  )
  expect_snapshot(
    files_content <- github_testhost_priv$get_files_content_from_files_structure(
      files_structure = test_mocker$use("gh_files_structure_from_orgs")
    )
  )
  expect_files_table(
    files_content,
    with_cols = "api_url"
  )
})

test_that("get_files_content_from_repos for GitHub works", {
  test_org <- "test_org"
  attr(test_org, "type") <- "organization"
  mockery::stub(
    github_testhost_priv$get_files_content_from_repos,
    "graphql_engine$set_owner_type",
    test_org
  )
  mockery::stub(
    github_testhost_priv$get_files_content_from_repos,
    "graphql_engine$prepare_files_table",
    test_mocker$use("gh_files_table")
  )
  github_testhost_priv$searching_scope <- "repo"
  gh_files_from_repos <- github_testhost_priv$get_files_content_from_repos(
    file_path = "DESCRIPTION",
    verbose = FALSE
  )
  expect_files_table(
    gh_files_from_repos,
    with_cols = "api_url"
  )
  test_mocker$cache(gh_files_from_repos)
})

test_that("`get_files_content()` pulls files in the table format", {
  github_testhost <- create_github_testhost(orgs = "test_org")
  mockery::stub(
    github_testhost$get_files_content,
    "private$get_files_content_from_orgs",
    test_mocker$use("gh_files_from_orgs")
  )
  mockery::stub(
    github_testhost$get_files_content,
    "private$get_files_content_from_repos",
    test_mocker$use("gh_files_from_repos")
  )
  gh_files_table <- github_testhost$get_files_content(
    file_path = "DESCRIPTION"
  )
  expect_files_table(gh_files_table, with_cols = "api_url")
  test_mocker$cache(gh_files_table)
})
