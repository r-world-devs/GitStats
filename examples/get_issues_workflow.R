devtools::load_all(".")

git_stats <- create_gitstats() %>%
  set_github_host(
    orgs = c("r-world-devs"),
    repos = c("openpharma/DataFakeR"),
    token = Sys.getenv("GITHUB_PAT")
  ) %>%
  set_gitlab_host(
    orgs = c("mbtests"),
    token = Sys.getenv("GITLAB_PAT_PUBLIC")
  )

issues <- get_issues(
  gitstats = git_stats,
  since = "2024-01-01",
  verbose = TRUE
)

issues

open_issues <- get_issues(
  gitstats = git_stats,
  since = "2024-01-01",
  state = "open",
  verbose = TRUE
)

closed_issues <- get_issues(
  gitstats = git_stats,
  since = "2023-01-01",
  state = "closed",
  verbose = TRUE
)

# Check printing in storage
git_stats

issues_stats <- create_gitstats() %>%
  set_github_host(
    orgs = c("r-world-devs", "openpharma"),
    token = Sys.getenv("GITHUB_PAT")
  ) %>%
  set_gitlab_host(
    orgs = c("mbtests"),
    token = Sys.getenv("GITLAB_PAT_PUBLIC")
  ) |>
  get_issues(
    since = "2024-01-01"
  ) |>
  get_issues_stats(
    time_aggregation = "month",
    group_var = author
  )
