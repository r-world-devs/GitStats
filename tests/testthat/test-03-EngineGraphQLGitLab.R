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
    from = "org",
    org = "mbtests"
  )
  expect_gl_repos_gql_response(
    gl_repos_page
  )
  test_mocker$cache(gl_repos_page)
})

test_that("`pull_repos()` prepares formatted list", {
  mockery::stub(
    test_gql_gl$pull_repos,
    "private$pull_repos_page",
    test_mocker$use("gl_repos_page")
  )
  gl_repos_from_org <- test_gql_gl$pull_repos(
    from = "org",
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
  expect_user_table(
    gl_user_table
  )
  test_mocker$cache(gl_user_table)
})

# public methods

test_gql_gl <- EngineGraphQLGitLab$new(
  gql_api_url = "https://gitlab.com/api/graphql",
  token = Sys.getenv("GITLAB_PAT_PUBLIC")
)

test_that("`get_repos()` works as expected", {
  mockery::stub(
    test_gql_gl$get_repos,
    "private$pull_repos",
    test_mocker$use("gl_repos_from_org")
  )
  settings <- list(search_param = "org")
  expect_snapshot(
    gl_repos_org <- test_gql_gl$get_repos(
      org = "mbtests",
      settings = settings
    )
  )
  expect_repos_table(
    gl_repos_org
  )
})
