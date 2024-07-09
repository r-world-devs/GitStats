test_rest <- EngineRestGitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT")
)

test_that("`pull_repos_issues()` adds issues to repos table", {

  gh_repos_by_code_table <- test_mocker$use("gh_repos_by_code_table")
  suppressMessages(
    gh_repos_by_code_table <- test_rest$pull_repos_issues(
      gh_repos_by_code_table
    )
  )
  expect_gt(
    length(gh_repos_by_code_table$issues_open),
    0
  )
  expect_gt(
    length(gh_repos_by_code_table$issues_closed),
    0
  )
  test_mocker$cache(gh_repos_by_code_table)
})

test_that("`pull_repos_contributors()` adds contributors to repos table", {
  expect_snapshot(
    gh_repos_by_code_table <- test_rest$pull_repos_contributors(
      repos_table = test_mocker$use("gh_repos_by_code_table"),
      settings = test_settings
    )
  )
  expect_repos_table(
    gh_repos_by_code_table,
    add_col = c("api_url", "contributors")
  )
  expect_gt(
    length(gh_repos_by_code_table$contributors),
    0
  )
  test_mocker$cache(gh_repos_by_code_table)
})

test_that("pull_repos_urls() works", {
  gh_repos_urls <- test_rest$pull_repos_urls(
    type = "web",
    org = "r-world-devs"
  )
  expect_gt(
    length(gh_repos_urls),
    0
  )
})
