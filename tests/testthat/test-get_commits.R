# GraphQL Queries

test_that("commits_by_repo GitHub query is built properly", {
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

# GraphQL Requests - GitHub

test_that("GitHub GraphQL API returns commits response", {
  gh_commits_by_repo_gql_response <- test_graphql_github$gql_response(
    test_mocker$use("gh_commits_by_repo_query")
  )
  expect_gh_commit_gql_response(
    gh_commits_by_repo_gql_response$data$repository$defaultBranchRef$target$history$edges[[1]]
  )
  test_mocker$cache(gh_commits_by_repo_gql_response)
})

test_that("`pull_commits_page_from_repo()` pulls commits page from repository", {
  mockery::stub(
    test_graphql_github_priv$pull_commits_page_from_repo,
    "self$gql_response",
    test_mocker$use("gh_commits_by_repo_gql_response")
  )
  commits_page <- test_graphql_github_priv$pull_commits_page_from_repo(
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

test_that("`pull_commits_from_one_repo()` prepares formatted list", {
  # overcome of infinite loop in pull_commits_from_repo
  commits_page <- test_mocker$use("commits_page")
  commits_page$data$repository$defaultBranchRef$target$history$pageInfo$hasNextPage <- FALSE

  mockery::stub(
    test_graphql_github_priv$pull_commits_from_one_repo,
    "private$pull_commits_page_from_repo",
    commits_page
  )
  commits_from_repo <- test_graphql_github_priv$pull_commits_from_one_repo(
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

test_that("`pull_commits_from_repos()` pulls commits from repos", {
  commits_from_repos <- test_graphql_github$pull_commits_from_repos(
    org = "r-world-devs",
    repo = "GitStats",
    since = "2023-01-01",
    until = "2023-02-28",
    verbose = FALSE
  )
  expect_gh_commit_gql_response(
    commits_from_repos[[1]][[1]]
  )
  test_mocker$cache(commits_from_repos)
})


# REST Requests - GitLab

test_that("GitLab REST API returns commits response", {
  gl_commits_rest_response_repo_1 <- test_rest_gitlab$response(
    "https://gitlab.com/api/v4/projects/44293594/repository/commits?since='2023-01-01T00:00:00'&until='2023-04-20T00:00:00'&with_stats=true"
  )
  expect_gl_commit_rest_response(
    gl_commits_rest_response_repo_1
  )
  test_mocker$cache(gl_commits_rest_response_repo_1)

  gl_commits_rest_response_repo_2 <- test_rest_gitlab$response(
    "https://gitlab.com/api/v4/projects/44346961/repository/commits?since='2023-01-01T00:00:00'&until='2023-04-20T00:00:00'&with_stats=true"
  )
  expect_gl_commit_rest_response(
    gl_commits_rest_response_repo_2
  )
  test_mocker$cache(gl_commits_rest_response_repo_2)
})

test_that("`pull_commits_from_repos()` pulls commits from repo", {
  gl_commits_repo_1 <- test_mocker$use("gl_commits_rest_response_repo_1")

  mockery::stub(
    test_rest_gitlab$pull_commits_from_repos,
    "private$pull_commits_from_one_repo",
    gl_commits_repo_1
  )
  repos_names <- c("mbtests%2Fgitstatstesting", "mbtests%2Fgitstats-testing-2")
  gl_commits_org <- test_rest_gitlab$pull_commits_from_repos(
    repos_names = repos_names,
    since = "2023-01-01",
    until = "2023-04-20",
    verbose = FALSE
  )
  purrr::walk(gl_commits_org, ~ expect_gl_commit_rest_response(.))
  test_mocker$cache(gl_commits_org)
})

# GitHub

test_that("`prepare_commits_table()` prepares commits table", {
  gh_commits_table <- github_testhost_priv$prepare_commits_table(
    repos_list_with_commits = test_mocker$use("commits_from_repos"),
    org = "r-world-devs"
  )
  expect_commits_table(
    gh_commits_table
  )
  test_mocker$cache(gh_commits_table)
})

test_that("get_commits_from_host for GitHub works", {
  mockery::stub(
    github_testhost_repos_priv$get_commits_from_host,
    "private$prepare_commits_table",
    test_mocker$use("gh_commits_table")
  )
  suppressMessages(
    gh_commits_table <- github_testhost_repos_priv$get_commits_from_host(
      since = "2023-03-01",
      until = "2023-04-01",
      settings = test_settings_repo
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
    "private$get_commits_from_host",
    test_mocker$use("gh_commits_table")
  )
  suppressMessages(
    commits_table <- github_testhost$get_commits(
      since = "2023-01-01",
      until = "2023-02-28",
      settings = test_settings
    )
  )
  expect_commits_table(
    commits_table
  )
})

test_that("get_commits for GitHub repositories works", {
  mockery::stub(
    github_testhost_repos$get_commits,
    "private$get_commits_from_host",
    test_mocker$use("gh_commits_table")
  )
  suppressMessages(
    gh_commits_table <- github_testhost_repos$get_commits(
      since = "2023-03-01",
      until = "2023-04-01",
      settings = test_settings_repo
    )
  )
  expect_commits_table(
    gh_commits_table
  )
})

## GitLab

test_that("`tailor_commits_info()` retrieves only necessary info", {
  gl_commits_list <- test_mocker$use("gl_commits_org")

  gl_commits_list_cut <- gitlab_testhost_priv$tailor_commits_info(
    gl_commits_list,
    org = "mbtests"
  )
  expect_tailored_commits_list(
    gl_commits_list_cut[[1]][[1]]
  )
  test_mocker$cache(gl_commits_list_cut)
})

test_that("`prepare_commits_table()` prepares table of commits properly", {
  gl_commits_table <- gitlab_testhost_priv$prepare_commits_table(
    commits_list = test_mocker$use("gl_commits_list_cut")
  )
  expect_commits_table(
    gl_commits_table,
    exp_auth = FALSE
  )
  test_mocker$cache(gl_commits_table)
})

test_that("get_commits_from_host works", {
  mockery::stub(
    gitlab_testhost_priv$get_commits_from_host,
    "rest_engine$pull_commits_from_repos",
    test_mocker$use("gl_commits_org")
  )
  suppressMessages(
    gl_commits_table <- gitlab_testhost_priv$get_commits_from_host(
      since = "2023-03-01",
      until = "2023-04-01",
      settings = test_settings
    )
  )
  expect_commits_table(
    gl_commits_table
  )
  test_mocker$cache(gl_commits_table)
})

test_that("get_commits for GitLab works with repos implied", {
  mockery::stub(
    gitlab_testhost_repos$get_commits,
    "private$get_commits_from_host",
    test_mocker$use("gl_commits_table")
  )
  gl_commits_table <- gitlab_testhost_repos$get_commits(
    since = "2023-01-01",
    until = "2023-06-01",
    settings = test_settings_repo
  )
  expect_commits_table(
    gl_commits_table
  )
})

test_that("`get_commits_authors_handles_and_names()` adds author logis and names to commits table", {
  expect_snapshot(
    gl_commits_table <- test_rest_gitlab$get_commits_authors_handles_and_names(
      commits_table = test_mocker$use("gl_commits_table"),
      verbose = TRUE
    )
  )
  expect_commits_table(
    gl_commits_table,
    exp_auth = TRUE
  )
  test_mocker$cache(gl_commits_table)
})

# GitStats

test_that("get_commits works properly", {
  mockery::stub(
    test_gitstats$get_commits,
    "private$get_commits_table",
    purrr::list_rbind(
      list(
        test_mocker$use("gh_commits_table"),
        test_mocker$use("gl_commits_table")
      )
    )
  )
  suppressMessages(
    commits_table <- test_gitstats$get_commits(
      since = "2023-06-15",
      until = "2023-06-30",
      verbose = FALSE
    )
  )
  expect_commits_table(
    commits_table
  )
  test_mocker$cache(commits_table)
})
