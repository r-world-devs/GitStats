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

test_that("get_repos_data pulls data on repositories", {
  repositories <- test_gql_gl$get_repos_data(
    org = "mbtests",
    repos = NULL
  )
  expect_true(
    length(repositories) > 0
  )
})

test_that("is query error is FALSE when response is empty (non query error)", {
  expect_false(
    test_gql_gl$is_query_error(list())
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
