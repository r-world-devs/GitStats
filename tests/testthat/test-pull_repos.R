test_github <- GitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = "r-world-devs"
)

test_github_priv <- environment(test_github$initialize)$private

test_that("`pull_repos_from_org()` pulls correctly repositories for GitHub
          and parses response to table", {

  suppressMessages(
    result <-
      test_github_priv$pull_repos_from_org(org = "r-world-devs")
  )
  saveRDS(result, "test_files/github_repos_table.rds")
  expect_repos_table(result)
})

test_gitlab <- GitLab$new(
  rest_api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT"),
  orgs = c("mbtests")
)

test_gitlab_priv <- environment(test_gitlab$initialize)$private

test_that("`pull_repos_from_org()` pulls correctly repositories for GitLab
          and parses response to table", {

  suppressMessages(
    result <-
      test_gitlab_priv$pull_repos_from_org(org = "mbtests")
  )

  expect_repos_table(result)

})
