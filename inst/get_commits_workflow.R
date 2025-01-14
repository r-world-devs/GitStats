devtools::load_all(".")

git_stats <- create_gitstats() %>%
  set_github_host(
    orgs = c("r-world-devs", "openpharma"),
    token = Sys.getenv("GITHUB_PAT")
  ) %>%
  set_gitlab_host(
    orgs = c("mbtests"),
    token = Sys.getenv("GITLAB_PAT_PUBLIC")
  )

release_logs <- get_release_logs(
  gitstats = git_stats,
  since = "2024-01-01",
  verbose = FALSE
)

release_logs

# Check printing in storage
git_stats

get_commits(
  gitstats = git_stats,
  since = "2024-01-01"
)

# Check printing in storage
git_stats

commits_stats <- create_gitstats() %>%
  set_github_host(
    orgs = c("r-world-devs", "openpharma"),
    token = Sys.getenv("GITHUB_PAT")
  ) %>%
  set_gitlab_host(
    orgs = c("mbtests"),
    token = Sys.getenv("GITLAB_PAT_PUBLIC")
  ) |>
  get_commits(
    since = "2024-01-01"
  ) |>
  get_commits_stats(
    time_aggregation = "year",
    group_var = author_name
  )
