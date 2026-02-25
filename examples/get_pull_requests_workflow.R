devtools::load_all(".")

git_stats <- create_gitstats() |>
  set_github_host(
    orgs = c("r-world-devs"),
    repos = c("openpharma/DataFakeR"),
    token = Sys.getenv("GITHUB_PAT")
  ) |>
  set_gitlab_host(
    orgs = c("mbtests"),
    token = Sys.getenv("GITLAB_PAT_PUBLIC")
  )

pr <- get_pull_requests(
  gitstats = git_stats,
  since = "2024-01-01",
  verbose = TRUE
)

pr

open_pr <- get_pull_requests(
  gitstats = git_stats,
  since = "2024-01-01",
  state = "open",
  verbose = TRUE
)

closed_pr <- get_pull_requests(
  gitstats = git_stats,
  since = "2023-01-01",
  state = "closed",
  verbose = TRUE
)

merged_pr <- get_pull_requests(
  gitstats = git_stats,
  since = "2023-01-01",
  state = "merged",
  verbose = TRUE
)

# Check printing in storage
git_stats
