test_gh_gql <- EngineGraphQLGitHub$new(
  gql_api_url = "https://api.github.com/graphql",
  token = Sys.getenv("GITHUB_PAT")
)

test_gl_gql <- EngineGraphQLGitLab$new(
  gql_api_url = "https://gitlab.com/api/graphql",
  token = Sys.getenv("GITLAB_PAT_PUBLIC")
)

# public methods

test_that("`gql_response()` work as expected for GitHub", {
  gh_commits_by_repo_gql_response <- test_gh_gql$gql_response(
    test_mock$mocker$gh_commits_by_repo_query
  )
  expect_gh_commit(
    gh_commits_by_repo_gql_response
  )
  test_mock$mock(gh_commits_by_repo_gql_response)

  gh_repos_by_org_gql_response <- test_gh_gql$gql_response(
    test_mock$mocker$gh_repos_by_org_query
  )
  expect_gh_repos(
    gh_repos_by_org_gql_response
  )
  test_mock$mock(gh_repos_by_org_gql_response)
})

test_that("`gql_response()` work as expected for GitLab", {
  gl_repos_by_org_gql_response <- test_gl_gql$gql_response(
    test_mock$mocker$gl_repos_by_org_query
  )
  expect_gl_repos(
    gl_repos_by_org_gql_response
  )
  test_mock$mock(gl_repos_by_org_gql_response)
})

# private methods

test_gl_gql <- environment(test_gl_gql$initialize)$private
test_gh_gql <- environment(test_gh_gql$initialize)$private

test_that("`pull_repos_page_from_org()` pulls repos page from GitHub organization", {
  mockery::stub(
    test_gh_gql$pull_repos_page_from_org,
    "self$gql_response",
    test_mock$mocker$gh_repos_by_org_gql_response
  )
  gh_repos_page <- test_gh_gql$pull_repos_page_from_org(
    org = "r-world-devs"
  )
  expect_gh_repos(
    gh_repos_page
  )
  test_mock$mock(gh_repos_page)
})

test_that("`pull_repos_page_from_org()` pulls repos page from GitLab organization", {
  mockery::stub(
    test_gl_gql$pull_repos_page_from_org,
    "self$gql_response",
    test_mock$mocker$gl_repos_by_org_gql_response
  )
  gl_repos_page <- test_gl_gql$pull_repos_page_from_org(
    org = "mbtests"
  )
  expect_gl_repos(
    gl_repos_page
  )
  test_mock$mock(gl_repos_page)
})
