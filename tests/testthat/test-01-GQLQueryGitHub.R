test_gqlquery_gh <- GQLQueryGitHub$new()

test_that("commits_by_repo query is built properly", {
  gh_commits_by_repo_query <-
    test_gqlquery_gh$commits_by_repo(
      org = "r-world-devs",
      repo = "GitStats",
      since = "2023-01-01T00:00:00Z",
      until = "2023-02-28T00:00:00Z"
    )
  expect_snapshot(
    gh_commits_by_repo_query
  )
  test_mocker$cache(gh_commits_by_repo_query)
})

test_that("repos_by_org query is built properly", {
  gh_repos_by_org_query <-
    test_gqlquery_gh$repos_by_org()
  expect_snapshot(
    gh_repos_by_org_query
  )
  test_mocker$cache(gh_repos_by_org_query)
})

test_that("user query is built properly", {
  gh_user_query <-
    test_gqlquery_gh$user()
  expect_snapshot(
    gh_user_query
  )
  test_mocker$cache(gh_user_query)
})

test_that("files tree query is built properly", {
  gh_files_tree_query <-
    test_gqlquery_gh$files_tree_from_repo()
  expect_snapshot(
    gh_files_tree_query
  )
  test_mocker$cache(gh_files_tree_query)
})

test_that("releases query is built properly", {
  gh_releases_query <-
    test_gqlquery_gh$releases_from_repo()
  expect_snapshot(
    gh_releases_query
  )
})
