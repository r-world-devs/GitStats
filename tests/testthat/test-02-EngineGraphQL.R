test_gql <- EngineGraphQL$new(
  gql_api_url = "https://api.github.com/graphql",
  token = Sys.getenv("GITHUB_PAT")
)

# public methods

test_that("`gql_response()` work as expected for GitHub", {
  gh_commits_by_repo_gql_response <- test_gql$gql_response(
    test_mocker$use("gh_commits_by_repo_query")
  )
  expect_gh_commit(
    gh_commits_by_repo_gql_response
  )
  test_mocker$cache(gh_commits_by_repo_gql_response)

  gh_repos_by_org_gql_response <- test_gql$gql_response(
    test_mocker$use("gh_repos_by_org_query"),
    vars = list(org = "r-world-devs")
  )
  expect_gh_repos(
    gh_repos_by_org_gql_response
  )
  test_mocker$cache(gh_repos_by_org_gql_response)

  gh_repos_by_user_gql_response <- test_gql$gql_response(
    test_mocker$use("gh_repos_by_user_query"),
    vars = list(user = "maciekbanas")
  )
  expect_gh_user_repos(
    gh_repos_by_user_gql_response
  )
  test_mocker$cache(gh_repos_by_user_gql_response)
})

test_gql <- EngineGraphQL$new(
  gql_api_url = "https://gitlab.com/api/graphql",
  token = Sys.getenv("GITLAB_PAT_PUBLIC")
)

# public methods

test_that("`gql_response()` work as expected for GitLab", {
  gl_repos_by_org_gql_response <- test_gql$gql_response(
    gql_query = test_mocker$use("gl_repos_by_org_query"),
    vars = list(org = "mbtests")
  )
  expect_gl_repos_gql_response(
    gl_repos_by_org_gql_response
  )
  test_mocker$cache(gl_repos_by_org_gql_response)
})
