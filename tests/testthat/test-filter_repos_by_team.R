test_github <- GitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = "r-world-devs"
)
test_github_priv <- environment(test_github$initialize)$private

test_that("`GitService` filters repositories' list by team members", {
  repo_list <- readRDS("test_files/github_repos_by_org.rds")
  result <- test_github_priv$filter_repos_by_team(
    repo_list,
    team = c("kalimu",
             "maciekbanas")
  )
  expect_type(
    result,
    "list"
  )
  expect_true(
    any(result[[1]]$contributors %in% c("maciekbanas", "kalimu"))
  )
})
