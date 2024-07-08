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

# public methods

test_gql_gl <- EngineGraphQLGitLab$new(
  gql_api_url = "https://gitlab.com/api/graphql",
  token = Sys.getenv("GITLAB_PAT_PUBLIC")
)

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
