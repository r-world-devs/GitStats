test_github <- GitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = c("r-world-devs")
)
test_github_priv <- environment(test_github$initialize)$private

test_that("`GitHub` attaches stats to commits list", {
  commits_cut <- readRDS("test_files/github_commits_tailored.rds")
  result <- test_github_priv$attach_commits_stats(commits_cut)
  expect_type(result, "list")
  purrr::walk(result, ~{
    expect_list_contains(
      .,
      c("id", "commited_date", "additions", "deletions"))
  })
})
