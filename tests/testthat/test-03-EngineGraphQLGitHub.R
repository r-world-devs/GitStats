test_graphql_github <- EngineGraphQLGitHub$new(
  gql_api_url = "https://api.github.com/graphql",
  token = Sys.getenv("GITHUB_PAT")
)

# private methods

test_graphql_github <- environment(test_graphql_github$initialize)$private

test_that("`pull_commits_page_from_repo()` pulls commits page from repository", {
  mockery::stub(
    test_graphql_github$pull_commits_page_from_repo,
    "self$gql_response",
    test_mocker$use("gh_commits_by_repo_gql_response")
  )
  commits_page <- test_graphql_github$pull_commits_page_from_repo(
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

test_that("`pull_repos_page_from_org()` pulls repos page from GitHub organization", {
  mockery::stub(
    test_graphql_github$pull_repos_page,
    "self$gql_response",
    test_mocker$use("gh_repos_by_org_gql_response")
  )
  gh_repos_page <- test_graphql_github$pull_repos_page(
    org = "r-world-devs"
  )
  expect_gh_repos_gql_response(
    gh_repos_page
  )
  test_mocker$cache(gh_repos_page)
})

test_that("`pull_commits_from_one_repo()` prepares formatted list", {
  # overcome of infinite loop in pull_commits_from_repo
  commits_page <- test_mocker$use("commits_page")
  commits_page$data$repository$defaultBranchRef$target$history$pageInfo$hasNextPage <- FALSE

  mockery::stub(
    test_graphql_github$pull_commits_from_one_repo,
    "private$pull_commits_page_from_repo",
    commits_page
  )
  commits_from_repo <- test_graphql_github$pull_commits_from_one_repo(
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

test_that("get_repos_data pulls data on repos and branches", {
  repos_data <- test_graphql_github$get_repos_data(
    org = "r-world-devs",
    repos = NULL
  )
  expect_equal(
    names(repos_data),
    c("repositories", "def_branches")
  )
  expect_true(
    length(repos_data$repositories) > 0
  )
  expect_true(
    length(repos_data$def_branches) > 0
  )
})

# public methods

test_graphql_github <- EngineGraphQLGitHub$new(
  gql_api_url = "https://api.github.com/graphql",
  token = Sys.getenv("GITHUB_PAT")
)

test_that("`get_repos_from_org()` prepares formatted list", {
  mockery::stub(
    test_graphql_github$get_repos_from_org,
    "private$pull_repos_page",
    test_mocker$use("gh_repos_page")
  )
  gh_repos_from_org <- test_graphql_github$get_repos_from_org(
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

test_that("`pull_releases_from_org()` pulls releases from the repositories", {
  releases_from_repos <- test_graphql_github$pull_release_logs_from_org(
    repos_names = c("GitStats", "shinyCohortBuilder"),
    org = "r-world-devs"
  )
  expect_github_releases_response(releases_from_repos)
  test_mocker$cache(releases_from_repos)
})
