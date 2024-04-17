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

test_that("`pull_repos_from_org()` prepares formatted list", {
  mockery::stub(
    test_gql_gl$pull_repos_from_org,
    "private$pull_repos_page",
    test_mocker$use("gl_repos_page")
  )
  gl_repos_from_org <- test_gql_gl$pull_repos_from_org(
    org = "mbtests"
  )
  expect_list_contains(
    gl_repos_from_org[[1]]$node,
    c(
      "id", "name", "stars", "forks", "created_at",
      "last_activity_at", "languages", "issues",
      "repo_url"
    )
  )
  test_mocker$cache(gl_repos_from_org)
})

test_that("`pull_repos_from_org()` does not fail when GraphQL response is not complete", {
  mockery::stub(
    test_gql_gl$pull_repos_from_org,
    "private$pull_repos_page",
    test_fixtures$empty_gql_response
  )
  gl_repos_from_org <- test_gql_gl$pull_repos_from_org(
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
    test_gql_gl$pull_repos_from_org,
    "private$pull_repos_page",
    test_fixtures$half_empty_gql_response
  )
  gl_repos_from_org <- test_gql_gl$pull_repos_from_org(
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

test_that("`prepare_repos_table()` prepares repos table", {
  gl_repos_table <- test_gql_gl$prepare_repos_table(
    repos_list = test_mocker$use("gl_repos_from_org")
  )
  expect_repos_table(
    gl_repos_table
  )
  test_mocker$cache(gl_repos_table)
})

test_that("GitLab prepares user table", {
  gl_user_table <- test_gql_gl$prepare_user_table(
    user_response = test_mocker$use("gl_user_response")
  )
  expect_users_table(
    gl_user_table,
    one_user = TRUE
  )
  test_mocker$cache(gl_user_table)
})

test_that("GitLab GraphQL Engine pulls files from a group", {
  gitlab_files_response <- test_gql_gl$pull_file_from_org(
    "mbtests",
    "meta_data.yaml"
  )
  expect_gitlab_files_response(gitlab_files_response)
  test_mocker$cache(gitlab_files_response)
})

test_that("GitLab GraphQL Engine pulls two files from a group", {
  gitlab_files_response <- test_gql_gl$pull_file_from_org(
    "mbtests",
    c("meta_data.yaml", "README.md")
  )
  expect_gitlab_files_response(gitlab_files_response)
  expect_true(
    all(
      c("meta_data.yaml", "README.md") %in%
        purrr::map_vec(gitlab_files_response, ~.$repository$blobs$nodes[[1]]$name)
    )
  )
})

test_that("GitLab GraphQL Engine pulls files from a repository", {
  gitlab_files_response <- test_gql_gl$pull_file_from_repos(
    file_path = "meta_data.yaml",
    repos_table = test_mocker$use("gl_repos_table")
  )
  expect_gitlab_files_response(gitlab_files_response)
})

test_that("GitLab GraphQL Engine prepares table from files response", {
  files_table <- test_gql_gl$prepare_files_table(
    files_response = test_mocker$use("gitlab_files_response"),
    org = "mbtests",
    file_path = "meta_data.yaml"
  )
  expect_files_table(files_table)
})

# public methods

test_gql_gl <- EngineGraphQLGitLab$new(
  gql_api_url = "https://gitlab.com/api/graphql",
  token = Sys.getenv("GITLAB_PAT_PUBLIC")
)

test_that("`pull_repos()` works as expected", {
  mockery::stub(
    test_gql_gl$pull_repos,
    "private$pull_repos",
    test_mocker$use("gl_repos_from_org")
  )
  expect_snapshot(
    gl_repos_org <- test_gql_gl$pull_repos(
      org = "mbtests",
      settings = test_settings
    )
  )
  expect_repos_table(
    gl_repos_org
  )
})

test_that("`pull_files()` pulls files in the table format", {
  expect_snapshot(
    gl_files_table <- test_gql_gl$pull_files(
      org = "mbtests",
      file_path = "README.md",
      settings = test_settings
    )
  )
  expect_files_table(gl_files_table)
  test_mocker$cache(gl_files_table)
})

test_that("`pull_files()` pulls two files in the table format", {
  expect_snapshot(
    gl_files_table <- test_gql_gl$pull_files(
      org = "mbtests",
      file_path = c("meta_data.yaml", "README.md"),
      settings = test_settings
    )
  )
  expect_files_table(gl_files_table)
  expect_true(
    all(c("meta_data.yaml", "README.md") %in% gl_files_table$file_path)
  )
})
