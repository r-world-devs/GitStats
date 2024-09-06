test_gql_gl <- EngineGraphQLGitLab$new(
  gql_api_url = "https://gitlab.com/api/graphql",
  token = Sys.getenv("GITLAB_PAT_PUBLIC")
)

# private methods

test_gql_gl <- environment(test_gql_gl$initialize)$private

test_that("`pull_repos_page()` pulls repos page from GitLab group", {
  mockery::stub(
    test_gql_gl$pull_repos_page,
    "self$gql_response",
    test_mocker$use("gl_repos_by_org_gql_response")
  )
  gl_repos_page <- test_gql_gl$pull_repos_page(
    org = "mbtests"
  )
  expect_gl_repos_gql_response(
    gl_repos_page
  )
  test_mocker$cache(gl_repos_page)
})

test_that("get_file_response()", {
  gl_files_tree_response <- test_gql_gl$get_file_response(
    org = "mbtests",
    repo = "graphql_tests",
    file_path = "",
    files_query = test_mocker$use("gl_files_tree_query")
  )
  expect_gitlab_files_raw_response(gl_files_tree_response)
  test_mocker$cache(gl_files_tree_response)
})

test_that("get_dirs_and_files returns list with directories and files", {
  gl_files_and_dirs_list <- test_gql_gl$get_files_and_dirs(
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
  gl_files_structure <- test_gql_gl$get_files_structure_from_repo(
    org = "mbtests",
    repo = "graphql_tests"
  )
  expect_type(
    gl_files_structure,
    "character"
  )
  test_mocker$cache(gl_files_structure)
})

test_that("get_files_structure_from_repo() pulls files structure (files matching pattern) from repo", {
  gl_files_structure <- test_gql_gl$get_files_structure_from_repo(
    org = "mbtests",
    repo = "graphql_tests",
    pattern = "\\.md"
  )
  expect_type(
    gl_files_structure,
    "character"
  )
  test_mocker$cache(gl_files_structure)
})

test_that("get_repos_data pulls data on repositories", {
  repositories <- test_gql_gl$get_repos_data(
    org = "mbtests",
    repos = NULL
  )
  expect_true(
    length(repositories) > 0
  )
})

# public methods

test_gql_gl <- EngineGraphQLGitLab$new(
  gql_api_url = "https://gitlab.com/api/graphql",
  token = Sys.getenv("GITLAB_PAT_PUBLIC")
)

test_that("`get_repos_from_org()` prepares formatted list", {
  mockery::stub(
    test_gql_gl$get_repos_from_org,
    "private$pull_repos_page",
    test_mocker$use("gl_repos_page")
  )
  gl_repos_from_org <- test_gql_gl$get_repos_from_org(
    org = "mbtests"
  )
  expect_equal(
    names(gl_repos_from_org[[1]]$node),
    c(
      "repo_id", "repo_name", "repo_path", "repository",
      "stars", "forks", "created_at", "last_activity_at",
      "languages", "issues", "group", "repo_url"
    )
  )
  test_mocker$cache(gl_repos_from_org)
})

test_that("`get_repos_from_org()` does not fail when GraphQL response is not complete", {
  mockery::stub(
    test_gql_gl$get_repos_from_org,
    "private$pull_repos_page",
    test_fixtures$empty_gql_response
  )
  gl_repos_from_org <- test_gql_gl$get_repos_from_org(
    org = "mbtests"
  )
  expect_type(
    gl_repos_from_org,
    "list"
  )
  expect_length(
    gl_repos_from_org,
    0
  )
  mockery::stub(
    test_gql_gl$get_repos_from_org,
    "private$pull_repos_page",
    test_fixtures$half_empty_gql_response
  )
  gl_repos_from_org <- test_gql_gl$get_repos_from_org(
    org = "mbtests"
  )
  expect_type(
    gl_repos_from_org,
    "list"
  )
  expect_length(
    gl_repos_from_org,
    0
  )
})

test_that("GitLab GraphQL Engine pulls files from a group", {
  gitlab_files_response <- test_gql_gl$pull_files_from_org(
    org = "mbtests",
    repos = NULL,
    file_path = "meta_data.yaml"
  )
  expect_gitlab_files_response(gitlab_files_response)
  test_mocker$cache(gitlab_files_response)
})

test_that("GitLab GraphQL Engine pulls files only from defined projects", {
  gitlab_files_response <- test_gql_gl$pull_files_from_org(
    org = "mbtests",
    repos = c("gitstatstesting", "gitstats-testing-2", "gitstatstesting3"),
    file_path = "README.md"
  )
  expect_gitlab_files_response(gitlab_files_response)
  expect_equal(length(gitlab_files_response), 3)
})

test_that("GitLab GraphQL Engine pulls two files from a group", {
  gitlab_files_response <- test_gql_gl$pull_files_from_org(
    org = "mbtests",
    repos = NULL,
    file_path = c("meta_data.yaml", "README.md")
  )
  expect_gitlab_files_response(gitlab_files_response)
  expect_true(
    all(
      c("meta_data.yaml", "README.md") %in%
        purrr::map_vec(gitlab_files_response, ~.$repository$blobs$nodes[[1]]$name)
    )
  )
})

test_that("GitLab GraphQL Engine pulls files structure from repositories", {
  gl_files_structure <- test_gql_gl$get_files_structure_from_org(
    org = "mbtests",
    repos = c("gitstatstesting", "graphql_tests")
  )
  purrr::walk(gl_files_structure, ~ expect_true(length(.) > 0))
  expect_equal(
    names(gl_files_structure),
    c("graphql_tests", "gitstatstesting")
  )
  purrr::walk(gl_files_structure, ~ expect_false(all(grepl("/$", .)))) # no empty dirs
  test_mocker$cache(gl_files_structure)
})

test_that("GitLab GraphQL Engine pulls files structure from repositories", {
  gl_files_structure_shallow <- test_gql_gl$get_files_structure_from_org(
    org = "mbtests",
    repos = c("gitstatstesting", "graphql_tests"),
    depth = 1L
  )
  purrr::walk(gl_files_structure_shallow, ~ expect_true(length(.) > 0))
  expect_equal(
    names(gl_files_structure_shallow),
    c("graphql_tests", "gitstatstesting")
  )
  purrr::walk(gl_files_structure_shallow, ~ expect_false(all(grepl("/", .)))) # no dirs
})
