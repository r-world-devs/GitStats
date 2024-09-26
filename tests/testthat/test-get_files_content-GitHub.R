test_that("file queries for GitHub are built properly", {
  gh_file_blobs_from_repo_query <-
    test_gqlquery_gh$file_blob_from_repo()
  expect_snapshot(
    gh_file_blobs_from_repo_query
  )
  test_mocker$cache(gh_file_blobs_from_repo_query)
})

test_that("get_repos_data pulls data on repos and branches", {
  repos_data <- test_graphql_github_priv$get_repos_data(
    org = "r-world-devs",
    repos = NULL
  )
  expect_equal(
    names(repos_data),
    c("repositories", "def_branches")
  )
  expect_true(
    length(repos_data$repositories) > 0
  )
  expect_true(
    length(repos_data$def_branches) > 0
  )
})

test_that("GitHub GraphQL Engine pulls files from organization", {
  github_files_response <- test_graphql_github$get_files_from_org(
    org                  = "r-world-devs",
    repos                = NULL,
    file_paths           = "LICENSE",
    only_text_files      = TRUE,
    host_files_structure = NULL,
    verbose              = FALSE,
    progress             = FALSE
  )
  expect_github_files_response(github_files_response)
  test_mocker$cache(github_files_response)
})

test_that("GitHub GraphQL Engine pulls .png files from organization", {
  github_png_files_response <- test_graphql_github$get_files_from_org(
    org                  = "r-world-devs",
    repos                = NULL,
    file_paths           = "man/figures/logo.png",
    only_text_files      = FALSE,
    host_files_structure = NULL,
    verbose              = FALSE,
    progress             = FALSE
  )
  expect_github_files_response(github_png_files_response)
  test_mocker$cache(github_png_files_response)
})

test_that("GitHub GraphQL Engine pulls files from defined repositories", {
  github_files_response <- test_graphql_github$get_files_from_org(
    org                  = "openpharma",
    repos                = c("DataFakeR", "visR"),
    file_paths           = "README.md",
    host_files_structure = NULL,
    only_text_files      = TRUE,
    verbose              = FALSE,
    progress             = FALSE
  )
  expect_github_files_response(github_files_response)
  expect_equal(length(github_files_response), 2)
})

test_that("GitHub GraphQL Engine pulls two files from a group", {
  github_files_response <- test_graphql_github$get_files_from_org(
    org                  = "r-world-devs",
    repos                = NULL,
    file_paths           = c("DESCRIPTION", "NAMESPACE"),
    host_files_structure = NULL,
    only_text_files      = TRUE,
    verbose              = FALSE,
    progress             = FALSE
  )
  expect_github_files_response(github_files_response)
  purrr::walk(github_files_response, ~ {expect_true(
    all(
      c("DESCRIPTION", "NAMESPACE") %in%
        names(.)
    )
  )
  })
})

test_that("GitHubHost prepares table from files response", {
  gh_files_table <- github_testhost_priv$prepare_files_table(
    files_response = test_mocker$use("github_files_response"),
    org = "r-world-devs",
    file_path = "LICENSE"
  )
  expect_files_table(gh_files_table)
  test_mocker$cache(gh_files_table)
})

test_that("GitHubHost prepares table from png files (with no content) response", {
  gh_png_files_table <- github_testhost_priv$prepare_files_table(
    files_response = test_mocker$use("github_png_files_response"),
    org = "r-world-devs",
    file_path = "man/figures/logo.png"
  )
  expect_files_table(gh_png_files_table)
  expect_true(all(is.na(gh_png_files_table$file_content)))
  test_mocker$cache(gh_png_files_table)
})

test_that("get_files_content_from_orgs for GitHub works", {
  mockery::stub(
    github_testhost_priv$get_files_content_from_orgs,
    "private$prepare_files_table",
    test_mocker$use("gh_files_table")
  )
  gh_files_table <- github_testhost_priv$get_files_content_from_orgs(
    file_path = "DESCRIPTION",
    verbose = FALSE
  )
  expect_files_table(
    gh_files_table,
    with_cols = "api_url"
  )
  test_mocker$cache(gh_files_table)
})

test_that("`get_files_content()` pulls files in the table format", {
  mockery::stub(
    github_testhost$get_files_content,
    "private$get_files_content_from_orgs",
    test_mocker$use("gh_files_table")
  )
  gh_files_table <- github_testhost$get_files_content(
    file_path = "LICENSE"
  )
  expect_files_table(gh_files_table, with_cols = "api_url")
  test_mocker$cache(gh_files_table)
})

test_that("`get_files_content()` pulls files only for the repositories specified", {
  github_testhost <- create_github_testhost(
    repos = c("r-world-devs/GitStats", "openpharma/visR", "openpharma/DataFakeR"),
  )
  expect_snapshot(
    gh_files_table <- github_testhost$get_files_content(
      file_path = "renv.lock"
    )
  )
  expect_files_table(gh_files_table, with_cols = "api_url")
  expect_equal(nrow(gh_files_table), 2) # visR does not have renv.lock
})
