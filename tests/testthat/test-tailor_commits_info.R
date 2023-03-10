test_github <- GitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = c("r-world-devs")
)

test_github_priv <- environment(test_github$initialize)$private

test_that("`GitHub` tailors commits list properly", {
  commits_raw <- readRDS("test_files/github_commits_by_org.rds")
  commits_cut <- test_github_priv$tailor_commits_info(
    commits_list = commits_raw,
    org = "r-world-devs"
    )
  expect_type(
    commits_cut,
    "list"
  )
  purrr::walk(commits_cut, ~{
    expect_list_contains_only(
      .,
      c("id", "organisation", "repository", "committed_date")
    )
  })
})
