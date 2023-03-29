test_github <- GitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = c("r-world-devs")
)

test_github_priv <- environment(test_github$initialize)$private

test_that("`GitHub` pulls commits from organization in a form of table", {
  mockery::stub(
    test_github_priv$pull_commits_from_org,
    'private$pull_repos_from_org',
    data.frame("organizations" = "r-world-devs",
               "name" = "GitStats")
  )
  mockery::stub(
    test_github_priv$pull_commits_from_org,
    'private$pull_commits_from_repo',
    readRDS("test_files/github_commits_list_from_repo.rds")
  )
  expect_snapshot(
    result <- test_github_priv$pull_commits_from_org(
      org = "r-world-devs",
      date_from = "2023-01-01",
      date_until = "2023-02-28",
      team = NULL
    )
  )

  expect_commits_table(
    result
  )
})

test_that("`GitHub` pulls commits from repository", {

  commits <- test_github_priv$pull_commits_from_repo(
    org = "r-world-devs",
    repo = "GitStats",
    date_from = "2023-01-01",
    date_until = "2023-02-28"
  )
  expect_type(
    commits,
    "list"
  )

})
