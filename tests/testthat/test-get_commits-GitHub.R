test_that("commits_by_repo GitHub query is built properly", {
  gh_commits_from_repo_query <-
    test_gqlquery_gh$commits_from_repo()
  expect_snapshot(
    gh_commits_from_repo_query
  )
})

test_that("`get_commits_page_from_repo()` pulls commits page from repository", {
  mockery::stub(
    test_graphql_github_priv$get_commits_page_from_repo,
    "self$gql_response",
    test_fixtures$github_commits_response
  )
  commits_page <- test_graphql_github_priv$get_commits_page_from_repo(
    org = "r-world-devs",
    repo = "GitStats",
    since = "2023-01-01",
    until = "2023-02-28"
  )
  expect_gh_commit_gql_response(
    commits_page$data$repository$defaultBranchRef$target$history$edges[[1]]
  )
  test_mocker$cache(commits_page)
})

test_that("`get_commits_from_one_repo()` prepares formatted list", {
  mockery::stub(
    test_graphql_github_priv$get_commits_from_one_repo,
    "private$get_commits_page_from_repo",
    test_mocker$use("commits_page")
  )
  commits_from_repo <- test_graphql_github_priv$get_commits_from_one_repo(
    org = "r-world-devs",
    repo = "GitStats",
    since = "2023-01-01",
    until = "2023-02-28"
  )
  expect_gh_commit_gql_response(
    commits_from_repo[[1]]
  )
  test_mocker$cache(commits_from_repo)
})

test_that("`get_commits_from_repos()` pulls commits from repos", {
  mockery::stub(
    test_graphql_github$get_commits_from_repos,
    "private$get_commits_from_one_repo",
    test_mocker$use("commits_from_repo")
  )
  commits_from_repos <- test_graphql_github$get_commits_from_repos(
    org      = "r-world-devs",
    repo     = "GitStats",
    since    = "2023-01-01",
    until    = "2023-02-28",
    progress = FALSE
  )
  expect_gh_commit_gql_response(
    commits_from_repos[[1]][[1]]
  )
  test_mocker$cache(commits_from_repos)
})

test_that("`prepare_commits_table()` prepares commits table", {
  gh_commits_table <- test_graphql_github$prepare_commits_table(
    repos_list_with_commits = test_mocker$use("commits_from_repos"),
    org = "r-world-devs"
  )
  expect_commits_table(
    gh_commits_table
  )
  test_mocker$cache(gh_commits_table)
})

test_that("get_commits_from_orgs for GitHub works", {
  mockery::stub(
    github_testhost_repos_priv$get_commits_from_orgs,
    "graphql_engine$prepare_commits_table",
    test_mocker$use("gh_commits_table")
  )
  suppressMessages(
    gh_commits_table <- github_testhost_repos_priv$get_commits_from_orgs(
      since    = "2023-03-01",
      until    = "2023-04-01",
      verbose  = FALSE,
      progress = FALSE
    )
  )
  expect_commits_table(
    gh_commits_table
  )
  test_mocker$cache(gh_commits_table)
})

test_that("`get_commits()` retrieves commits in the table format", {
  mockery::stub(
    github_testhost$get_commits,
    "private$get_commits_from_orgs",
    test_mocker$use("gh_commits_table")
  )
  suppressMessages(
    commits_table <- github_testhost$get_commits(
      since    = "2023-01-01",
      until    = "2023-02-28",
      verbose  = FALSE,
      progress = FALSE
    )
  )
  expect_commits_table(
    commits_table
  )
})

test_that("get_commits for GitHub repositories works", {
  mockery::stub(
    github_testhost_repos$get_commits,
    "private$get_commits_from_orgs",
    test_mocker$use("gh_commits_table")
  )
  suppressMessages(
    gh_commits_table <- github_testhost_repos$get_commits(
      since    = "2023-03-01",
      until    = "2023-04-01",
      verbose  = FALSE,
      progress = FALSE
    )
  )
  expect_commits_table(
    gh_commits_table
  )
})
