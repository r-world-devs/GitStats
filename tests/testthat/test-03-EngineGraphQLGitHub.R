test_gql_gh <- EngineGraphQLGitHub$new(
  gql_api_url = "https://api.github.com/graphql",
  token = Sys.getenv("GITHUB_PAT")
)

# private methods

test_gql_gh <- environment(test_gql_gh$initialize)$private

test_that("`get_authors_ids()` works as expected", {
  expect_snapshot(
    test_gql_gh$get_authors_ids(test_team)
  )
})

test_that("`pull_commits_page_from_repo()` pulls commits page from repository", {
  mockery::stub(
    test_gql_gh$pull_commits_page_from_repo,
    "self$gql_response",
    test_mocker$use("gh_commits_by_repo_gql_response")
  )
  commits_page <- test_gql_gh$pull_commits_page_from_repo(
    org = "r-world-devs",
    repo = "GitStats",
    date_from = "2023-01-01",
    date_until = "2023-02-28"
  )
  expect_gh_commit(
    commits_page
  )
  test_mocker$cache(commits_page)
})

test_that("`pull_repos_page_from_org()` pulls repos page from GitHub organization", {
  mockery::stub(
    test_gql_gh$pull_repos_page,
    "self$gql_response",
    test_mocker$use("gh_repos_by_org_gql_response")
  )
  gh_repos_page <- test_gql_gh$pull_repos_page(
    from = "org",
    org = "r-world-devs"
  )
  expect_gh_repos(
    gh_repos_page
  )
  test_mocker$cache(gh_repos_page)
})

test_that("`pull_repos()` prepares formatted list", {
  mockery::stub(
    test_gql_gh$pull_repos,
    "private$pull_repos_page",
    test_mocker$use("gh_repos_page")
  )
  gh_repos_from_org <- test_gql_gh$pull_repos(
    from = "org",
    org = "r-world-devs"
  )
  expect_list_contains(
    gh_repos_from_org[[1]],
    c(
      "id", "name", "stars", "forks", "created_at",
      "last_activity_at", "languages", "issues_open", "issues_closed",
      "contributors", "repo_url"
    )
  )
  test_mocker$cache(gh_repos_from_org)
})

test_that("`pull_repos_page()` pulls repos page from GitHub user", {
  mockery::stub(
    test_gql_gh$pull_repos_page,
    "self$gql_response",
    test_mocker$use("gh_repos_by_user_gql_response")
  )
  gh_repos_user_page <- test_gql_gh$pull_repos_page(
    from = "user",
    user = "maciekbanas"
  )
  expect_gh_user_repos(
    gh_repos_user_page
  )
  test_mocker$cache(gh_repos_user_page)
})

test_that("`pull_repos()` from user prepares formatted list", {
  mockery::stub(
    test_gql_gh$pull_repos,
    "private$pull_repos_page",
    test_mocker$use("gh_repos_user_page")
  )
  gh_repos_from_user <- test_gql_gh$pull_repos(
    from = "user",
    user = "maciekbanas"
  )
  expect_list_contains(
    gh_repos_from_user[[1]],
    c(
      "id", "name", "stars", "forks", "created_at",
      "last_activity_at", "languages", "issues_open", "issues_closed",
      "repo_url"
    )
  )
  expect_gt(
    length(gh_repos_from_user[[1]][["languages"]]$nodes),
    0
  )
  test_mocker$cache(gh_repos_from_user)
})

test_that("`pull_repos_from_team()` works smoothly", {
  gh_repos_from_team <- test_gql_gh$pull_repos_from_team(
    team = test_team
  )
  expect_list_contains(
    gh_repos_from_team[[1]],
    c(
      "id", "name", "stars", "forks", "created_at",
      "last_activity_at", "languages", "issues_open", "issues_closed",
      "contributors", "repo_url"
    )
  )
  expect_gt(
    length(gh_repos_from_team[[1]][["languages"]]$nodes),
    0
  )
  test_mocker$cache(gh_repos_from_team)
})

test_that("`pull_commits_from_one_repo()` prepares formatted list", {
  # overcome of infinite loop in pull_commits_from_repo
  commits_page <- test_mocker$use("commits_page")
  commits_page$data$repository$defaultBranchRef$target$history$pageInfo$hasNextPage <- FALSE

  mockery::stub(
    test_gql_gh$pull_commits_from_one_repo,
    "private$pull_commits_page_from_repo",
    commits_page
  )
  commits_from_repo <- test_gql_gh$pull_commits_from_one_repo(
    org = "r-world-devs",
    repo = "GitStats",
    date_from = "2023-01-01",
    date_until = "2023-02-28"
  )
  expect_snapshot(
    commits_from_repo
  )
  test_mocker$cache(commits_from_repo)
})

test_that("`pull_commits_from_repos()` pulls commits from repos", {
  mockery::stub(
    test_gql_gh$pull_commits_from_repos,
    "private$pull_commits_from_one_repo",
    test_mocker$use("commits_from_repo")
  )
  commits_from_repos <- test_gql_gh$pull_commits_from_repos(
    org = "r-world-devs",
    repo = "GitStats",
    date_from = "2023-01-01",
    date_until = "2023-02-28"
  )
  expect_snapshot(
    commits_from_repos
  )
  test_mocker$cache(commits_from_repos)
})

test_that("`prepare_repos_table()` prepares repos table", {
  gh_repos_table <- test_gql_gh$prepare_repos_table(
    repos_list = test_mocker$use("gh_repos_from_org")
  )
  expect_repos_table(
    gh_repos_table
  )
  test_mocker$cache(gh_repos_table)
  gh_repos_table_team <- test_gql_gh$prepare_repos_table(
    repos_list = test_mocker$use("gh_repos_from_team")
  )
  expect_repos_table(
    gh_repos_table_team
  )
})

test_that("`prepare_commits_table()` prepares commits table", {
  commits_table <- test_gql_gh$prepare_commits_table(
    repos_list_with_commits = test_mocker$use("commits_from_repos"),
    org = "r-world-devs"
  )
  expect_commits_table(
    commits_table
  )
  test_mocker$cache(commits_table)
})

# public methods

test_gql_gh <- EngineGraphQLGitHub$new(
  gql_api_url = "https://api.github.com/graphql",
  token = Sys.getenv("GITHUB_PAT")
)

test_that("`get_repos()` works as expected", {
  mockery::stub(
    test_gql_gh$get_repos,
    "private$pull_repos",
    test_mocker$use("gh_repos_from_org")
  )
  settings <- list(search_param = "org")
  expect_snapshot(
    gh_repos_org <- test_gql_gh$get_repos(
      org = "r-world-devs",
      settings = settings
    )
  )
  expect_repos_table(
    gh_repos_org
  )

  mockery::stub(
    test_gql_gh$get_repos,
    "private$pull_repos_from_team",
    test_mocker$use("gh_repos_from_team")
  )
  settings <- list(
    search_param = "team",
    team = test_team
  )
  expect_snapshot(
    gh_repos_team <- test_gql_gh$get_repos(
      org = "r-world-devs",
      settings = settings
    )
  )
  expect_repos_table(
    gh_repos_team
  )
})

test_that("`get_commits()` retrieves commits in the table format", {
  mockery::stub(
    test_gql_gh$get_commits,
    "private$pull_commits_from_repos",
    test_mocker$use("commits_from_repos")
  )

  mockery::stub(
    test_gql_gh$get_commits,
    "private$prepare_commits_table",
    test_mocker$use("commits_table")
  )

  repos_table <- test_mocker$use("gh_repos_table") %>%
    dplyr::filter(name == "GitStats")

  mockery::stub(
    test_gql_gh$get_commits,
    "self$get_repos",
    repos_table
  )

  settings <- list(search_param = "org")

  expect_snapshot(
    commits_table <- test_gql_gh$get_commits(
      org = "r-world-devs",
      date_from = "2023-01-01",
      date_until = "2023-02-28",
      settings = settings
    )
  )

  expect_commits_table(
    commits_table
  )
})
