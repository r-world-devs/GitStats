test_github <- GitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = c("r-world-devs")
)

test_github_priv <- environment(test_github$initialize)$private

test_that("`GitHub` pulls commits from organization", {
  mockery::stub(
    test_github_priv$pull_commits_from_org,
    'private$pull_repos_from_org',
    readRDS("test_files/github_repos_by_org.rds")
  )
  pulled_commits <- test_github_priv$pull_commits_from_org(
    org = "r-world-devs",
    date_from = "2023-01-01"
  )
  expect_type(
    pulled_commits,
    "list"
  )
  purrr::walk(pulled_commits, ~{
    expect_list_contains(
      ., c("sha", "node_id", "commit")
    )
  })
})
