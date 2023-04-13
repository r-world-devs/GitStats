test_gql_gh <- EngineGraphQLGitHub$new(
  gql_api_url = "https://api.github.com/graphql",
  token = Sys.getenv("GITHUB_PAT")
)

test_gql_gh <- environment(test_gql_gh$initialize)$private

test_that("`get_authors_ids()` works as expected", {
  team <- list(
    "Member1" = list(
      logins = "galachad"
    ),
    "Member2" = list(
      logins = "Cotau"
    ),
    "Member3" = list(
      logins = "maciekbanas"
    )
  )
  expect_snapshot(
    test_gql_gh$get_authors_ids(team)
  )
})

test_that("`pull_commits_page_from_repo()` pulls commits page from repository", {

  mockery::stub(
    test_gql_gh$pull_commits_page_from_repo,
    'self$gql_response',
    test_mock$commits_by_repo_gql_response
  )
  commits_page <- test_gql_gh$pull_commits_page_from_repo(
    org = "r-world-devs",
    repo = "GitStats",
    date_from = "2023-01-01",
    date_until = "2023-02-28"
  )
  expect_snapshot(
    commits_page
  )
  test_mock$mock(
    commits_page = commits_page
  )
})

test_that("`pull_commits_from_repo()` prepares formatted list", {

  # ugly overcome of infinite loop in pull_commits_from_repo
  test_mock$commits_page$data$repository$defaultBranchRef$target$history$pageInfo$hasNextPage <- FALSE

  mockery::stub(
    test_gql_gh$pull_commits_from_one_repo,
    'private$pull_commits_page_from_repo',
    test_mock$commits_page
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
  test_mock$mock(
    commits_from_repo = commits_from_repo
  )
})

test_that("`pull_commits_from_repos()` pulls commits from repos", {
  mockery::stub(
    test_gql_gh$pull_commits_from_repos,
    'private$pull_commits_from_one_repo',
    test_mock$commits_from_repo
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
  test_mock$mock(
    commits_from_repos = commits_from_repos
  )
})

test_that("`prepare_commits_table()` prepares commits table", {
  expect_commits_table(
    test_gql_gh$prepare_commits_table(
      org = "r-world-devs",
      repos_list_with_commits = test_mock$commits_from_repos
    )
  )
})
