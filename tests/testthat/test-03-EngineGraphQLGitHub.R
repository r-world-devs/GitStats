test_gql_gh <- EngineGraphQLGitHub$new(
  gql_api_url = "https://api.github.com/graphql",
  token = Sys.getenv("GITHUB_PAT")
)

# private methods

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

test_that("`pull_repos_page_from_org()` pulls repos page from organization", {

  mockery::stub(
    test_gql_gh$pull_repos_page_from_org,
    'self$gql_response',
    test_mock$mocker$repos_by_org_gql_response
  )
  repos_page <- test_gql_gh$pull_repos_page_from_org(
    org = "r-world-devs"
  )
  expect_snapshot(
    repos_page
  )
  test_mock$mock(repos_page)
})


test_that("`pull_commits_page_from_repo()` pulls commits page from repository", {

  mockery::stub(
    test_gql_gh$pull_commits_page_from_repo,
    'self$gql_response',
    test_mock$mocker$commits_by_repo_gql_response
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
  test_mock$mock(commits_page)
})

test_that("`pull_repos_from_org()` prepares formatted list", {

  mockery::stub(
    test_gql_gh$pull_repos_from_org,
    'private$pull_repos_page_from_org',
    test_mock$mocker$repos_page
  )
  repos_from_org <- test_gql_gh$pull_repos_from_org(
    org = "r-world-devs"
  )
  expect_list_contains(
    repos_from_org[[1]],
    c("id", "name", "stars", "forks", "created_at", "last_push",
      "last_activity_at", "languages", "issues_open", "issues_closed",
      "contributors", "repo_url")
  )
  test_mock$mock(repos_from_org)
})

test_that("`pull_commits_from_one_repo()` prepares formatted list", {

  # overcome of infinite loop in pull_commits_from_repo
  test_mock$mocker$commits_page$data$repository$defaultBranchRef$target$history$pageInfo$hasNextPage <- FALSE

  mockery::stub(
    test_gql_gh$pull_commits_from_one_repo,
    'private$pull_commits_page_from_repo',
    test_mock$mocker$commits_page
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
  test_mock$mock(commits_from_repo)
})

test_that("`pull_commits_from_repos()` pulls commits from repos", {
  mockery::stub(
    test_gql_gh$pull_commits_from_repos,
    'private$pull_commits_from_one_repo',
    test_mock$mocker$commits_from_repo
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
  test_mock$mock(commits_from_repos)
})

test_that("`prepare_repos_table()` prepares repos table", {
  repos_table <- test_gql_gh$prepare_repos_table(
    repos_list = test_mock$mocker$repos_from_org,
    org = "r-world-devs"
  )
  expect_repos_table(
    repos_table
  )
  test_mock$mock(repos_table)
})

test_that("`prepare_commits_table()` prepares commits table", {
  commits_table <- test_gql_gh$prepare_commits_table(
    repos_list_with_commits = test_mock$mocker$commits_from_repos,
    org = "r-world-devs"
  )
  expect_commits_table(
    commits_table
  )
  test_mock$mock(commits_table)
})

# public methods

test_gql_gh <- EngineGraphQLGitHub$new(
  gql_api_url = "https://api.github.com/graphql",
  token = Sys.getenv("GITHUB_PAT")
)

test_that("`get_commits_from_org()` gets commits in the table format", {

  mockery::stub(
    test_gql_gh$get_commits_from_org,
    'private$pull_commits_from_repos',
    test_mock$mocker$commits_from_repos
  )

  mockery::stub(
    test_gql_gh$get_commits_from_org,
    'private$prepare_commits_table',
    test_mock$mocker$commits_table
  )

  repos_table <- test_mock$mocker$repos_table %>%
    dplyr::filter(name == "GitStats")

  expect_snapshot(
    commits_table <- test_gql_gh$get_commits_from_org(
      org = "r-world-devs",
      repos_table = repos_table,
      date_from = "2023-01-01",
      date_until = "2023-02-28",
      by = "orgs"
    )
  )

  expect_commits_table(
    commits_table
  )
})
