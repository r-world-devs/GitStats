git_stats <- create_gitstats() |>
  set_github_host(
    repos = c("openpharma/DataFakeR", "openpharma/visR")
  ) |>
  set_gitlab_host(
    orgs = c("mbtests")
  )

get_commits(git_stats, since = "2023-01-01", verbose = FALSE)
