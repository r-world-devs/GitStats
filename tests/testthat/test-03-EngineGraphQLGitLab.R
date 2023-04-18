test_gql_gl <- EngineGraphQLGitLab$new(
  gql_api_url = "https://gitlab.com/api/graphql",
  token = Sys.getenv("GITLAB_PAT_PUBLIC")
)

# private methods

test_gql_gl <- environment(test_gql_gl$initialize)$private

test_that("`pull_repos_from_org()` prepares formatted list", {
  mockery::stub(
    test_gql_gl$pull_repos_from_org,
    "private$pull_repos_page_from_org",
    test_mock$mocker$gl_repos_page
  )
  gl_repos_from_org <- test_gql_gl$pull_repos_from_org(
    org = "mbtests"
  )
  expect_list_contains(
    gl_repos_from_org[[1]]$node,
    c(
      "id", "name", "stars", "forks", "created_at", "last_push",
      "last_activity_at", "languages", "issueStatusCounts"
    )
  )
  test_mock$mock(gl_repos_from_org)
})

test_that("`prepare_repos_table()` prepares repos table", {
  gl_repos_table <- test_gql_gl$prepare_repos_table(
    repos_list = test_mock$mocker$gl_repos_from_org,
    org = "mbtests"
  )
  expect_repos_table(
    gl_repos_table
  )
  test_mock$mock(gl_repos_table)
})
