test_that("files tree query for GitLab are built properly", {
  gl_files_tree_query <-
    test_gqlquery_gl$files_tree_from_repo()
  expect_snapshot(
    gl_files_tree_query
  )
  test_mocker$cache(gl_files_tree_query)
})

test_that("get_files_tree_response() works", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_gitlab_priv$get_files_tree_response,
      "self$gql_response",
      test_fixtures$gitlab_files_tree_response
    )
  }
  gl_files_tree_response <- test_graphql_gitlab_priv$get_files_tree_response(
    org = "mbtests",
    repo = "graphql_tests",
    file_path = ""
  )
  expect_gitlab_files_tree_response(gl_files_tree_response)
  test_mocker$cache(gl_files_tree_response)
})

test_that("get_dirs_and_files() returns list with directories and files", {
  gl_files_and_dirs_list <- test_graphql_gitlab_priv$get_files_and_dirs(
    files_tree_response = test_mocker$use("gl_files_tree_response")
  )
  expect_type(
    gl_files_and_dirs_list,
    "list"
  )
  expect_list_contains(
    gl_files_and_dirs_list,
    c("files", "dirs")
  )
  expect_true(
    length(gl_files_and_dirs_list$files) > 0
  )
  expect_true(
    length(gl_files_and_dirs_list$dirs) > 0
  )
  test_mocker$cache(gl_files_and_dirs_list)
})

test_that("get_files_structure_from_repo() pulls files structure from repo", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_gitlab_priv$get_files_structure_from_repo,
      "private$get_files_tree_response",
      test_mocker$use("gl_files_tree_response")
    )
    files_and_dirs <- test_mocker$use("gl_files_and_dirs_list")
    files_and_dirs$dirs <- character()
    mockery::stub(
      test_graphql_gitlab_priv$get_files_structure_from_repo,
      "private$get_files_and_dirs",
      files_and_dirs
    )
  }
  gl_files_structure <- test_graphql_gitlab_priv$get_files_structure_from_repo(
    org = "mbtests",
    repo = "graphql_tests"
  )
  expect_type(
    gl_files_structure,
    "character"
  )
  test_mocker$cache(gl_files_structure)
})

test_that("only files with certain pattern are retrieved", {
  md_files_structure <- test_graphql_gitlab_priv$filter_files_by_pattern(
    files_structure = test_mocker$use("gl_files_structure"),
    pattern = "\\.md"
  )
  files_structure <- test_mocker$use("gl_files_structure")
  expect_true(
    length(md_files_structure) < length(files_structure)
  )
  r_files_structure <- test_graphql_gitlab_priv$filter_files_by_pattern(
    files_structure = test_mocker$use("gl_files_structure"),
    pattern = "\\.R$"
  )
  expect_true(
    length(r_files_structure) < length(files_structure)
  )
  test_mocker$cache(md_files_structure)
})

test_that("get_files_structure_from_repo() pulls files structure (files matching pattern) from repo", {
  mockery::stub(
    test_graphql_gitlab_priv$get_files_structure_from_repo,
    "private$get_files_tree_response",
    test_mocker$use("gl_files_tree_response")
  )
  files_and_dirs <- test_mocker$use("gl_files_and_dirs_list")
  files_and_dirs$dirs <- character()
  mockery::stub(
    test_graphql_gitlab_priv$get_files_structure_from_repo,
    "private$get_files_and_dirs",
    files_and_dirs
  )
  mockery::stub(
    test_graphql_gitlab_priv$get_files_structure_from_repo,
    "private$filter_files_by_pattern",
    test_mocker$use("md_files_structure")
  )
  gl_md_files_structure <- test_graphql_gitlab_priv$get_files_structure_from_repo(
    org = "mbtests",
    repo = "graphql_tests",
    pattern = "\\.md"
  )
  expect_type(
    gl_md_files_structure,
    "character"
  )
  test_mocker$cache(gl_md_files_structure)
})

if (integration_tests_skipped) {
  gl_repos <- c("tests_repo_1", "tests_repo_2")
} else {
  gl_repos <- c("graphql_tests", "gitstatstesting")
}

test_that("GitLab GraphQL Engine pulls files structure from repositories", {
  if (integration_tests_skipped) {
    gl_repos_data <- list(
      "repositories" = gl_repos
    )
    mockery::stub(
      test_graphql_gitlab$get_files_structure_from_org,
      "private$get_repos_data",
      gl_repos_data
    )
    mockery::stub(
      test_graphql_gitlab$get_files_structure_from_org,
      "private$get_files_structure_from_repo",
      test_mocker$use("gl_files_structure")
    )
  }
  gl_files_structure <- test_graphql_gitlab$get_files_structure_from_org(
    org = "mbtests",
    repos = gl_repos,
    owner_type = "organization",
    verbose  = FALSE,
    progress = FALSE
  )
  purrr::walk(gl_files_structure, ~ expect_true(length(.) > 0))
  expect_equal(
    names(gl_files_structure),
    gl_repos
  )
  purrr::walk(gl_files_structure, ~ expect_false(all(grepl("/$", .)))) # no empty dirs
})

test_that("GitLab GraphQL Engine pulls files structure from repositories when repos are not set", {
  if (integration_tests_skipped) {
    gl_repos_data <- list(
      "repositories" = gl_repos
    )
    mockery::stub(
      test_graphql_gitlab$get_files_structure_from_org,
      "private$get_repos_data",
      gl_repos_data
    )
    mockery::stub(
      test_graphql_gitlab$get_files_structure_from_org,
      "private$get_files_structure_from_repo",
      test_mocker$use("gl_md_files_structure")
    )
  }
  gl_files_structure_shallow <- test_graphql_gitlab$get_files_structure_from_org(
    org = "mbtests",
    repos =  NULL,
    pattern = "\\.md",
    owner_type = "organization",
    depth = 1L,
    verbose = FALSE,
    progress = FALSE
  )
  purrr::walk(gl_files_structure_shallow, ~ expect_true(length(.) > 0))
  expect_equal(
    names(gl_files_structure_shallow),
    gl_repos
  )
  purrr::walk(gl_files_structure_shallow, ~ expect_false(all(grepl("/", .)))) # no dirs
  test_mocker$cache(gl_files_structure_shallow)
})

gl_group <- if (integration_tests_skipped) {
  "test_group"
} else {
  "mbtests"
}

test_that("get_files_structure_from_orgs pulls files structure for repositories in orgs", {
  mockery::stub(
    gitlab_testhost_priv$get_files_structure_from_orgs,
    "graphql_engine$get_files_structure_from_org",
    test_mocker$use("gl_files_structure_shallow")
  )
  gl_files_structure_from_orgs <- gitlab_testhost_priv$get_files_structure_from_orgs(
    pattern  = "\\.md",
    depth    = 1L,
    verbose  = FALSE,
    progress = FALSE
  )
  expect_equal(
    names(gl_files_structure_from_orgs),
    c(gl_group)
  )
  purrr::walk(gl_files_structure_from_orgs[[1]], function(repo_files) {
    expect_true(all(grepl("\\.md", repo_files)))
  })
  test_mocker$cache(gl_files_structure_from_orgs)
})

test_that("get_path_from_files_structure gets file path from files structure", {
  test_graphql_gitlab <- EngineGraphQLGitLab$new(
    gql_api_url = "https://gitlab.com/api/v4/graphql",
    token = Sys.getenv("GITHLAB_PAT_PUBLIC")
  )
  test_graphql_gitlab <- environment(test_graphql_gitlab$initialize)$private
  file_path <- test_graphql_gitlab$get_path_from_files_structure(
    host_files_structure = test_mocker$use("gl_files_structure_from_orgs"),
    org = gl_group # this will need fixing and repo parameter must come back
  )
  expect_equal(typeof(file_path), "character")
  expect_true(length(file_path) > 0)
})

test_that("get_files_structure pulls files structure for repositories in orgs", {
  mockery::stub(
    gitlab_testhost$get_files_structure,
    "private$get_files_structure_from_orgs",
    test_mocker$use("gl_files_structure_from_orgs")
  )
  gl_files_structure_from_orgs <- gitlab_testhost$get_files_structure(
    pattern  = "\\.md",
    depth    = 1L,
    verbose  = FALSE,
    progress = FALSE
  )
  expect_equal(
    names(gl_files_structure_from_orgs),
    gl_group
  )
  purrr::walk(gl_files_structure_from_orgs[[1]], function(repo_files) {
    expect_true(all(grepl("\\.md", repo_files)))
  })
  test_mocker$cache(gl_files_structure_from_orgs)
})
