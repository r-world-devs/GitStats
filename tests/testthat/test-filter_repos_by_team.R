test_github <- GitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = "r-world-devs"
)
test_github_priv <- environment(test_github$initialize)$private

test_that("`GitService` filters repositories' list by team members", {
  repos_table <- readRDS("test_files/github_repos_table.rds")
  expect_snapshot(
    result <- test_github_priv$filter_repos_by_team(
      repos_table,
      team = list(
        "Member1" = list(
          logins = "kalimu"
        ),
        "Member2" = list(
          logins = "epijim"
        )
      )
    )
  )
  expect_type(
    result,
    "list"
  )
  expect_length(
    result,
    length(repos_table)
  )
  expect_true(
    all(result$contributors %in% c("epijim", "kalimu"))
  )
})
