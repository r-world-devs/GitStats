git_stats <- create_gitstats() |>
  set_github_host(
    orgs = c("r-world-devs"),
    repos = c("openpharma/DataFakR"),
    token = Sys.getenv("GITHUB_PAT"),
    .show_error = FALSE
  ) |>
  set_gitlab_host(
    orgs = c("mbtests", "makbest"),
    token = Sys.getenv("GITLAB_PAT_PUBLIC"),
    .show_error = FALSE
  )

git_stats

# Setting users instead of orgs

git_stats <- create_gitstats() |>
  set_github_host(
    orgs = c("maciekbanas"),
    token = Sys.getenv("GITHUB_PAT")
  )
