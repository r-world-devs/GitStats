git_stats <- create_gitstats() |>
  set_github_host(
    orgs = "r-world-devs"
  ) |>
  set_sqlite_storage() # set storage to :memory:

# pull all commits from API

git_stats |>
  get_commits(since = "2025-01-01", until = "2025-03-31", verbose = TRUE)

git_stats

# pull from API only 2nd quarter of 2025

git_stats |>
  get_commits(since = "2025-01-01", until = "2025-06-30", verbose = TRUE)

# pull cached data from r-world-devs, all data from maciekbanas

git_stats <- create_gitstats() |>
  set_github_host(
    orgs = c("r-world-devs", "maciekbanas")
  ) |>
  set_sqlite_storage()

git_stats |>
  get_commits(since = "2025-01-01", until = "2025-09-30", verbose = TRUE)
