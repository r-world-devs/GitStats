devtools::load_all(".")

gitlab_stats <- create_gitstats() |>
  set_gitlab_host(
    orgs = c("mbtests", "mbtestapps")
  )

get_repos_trees(
  gitstats = gitlab_stats
)

github_stats <- create_gitstats() |>
  set_github_host(
    orgs = c("r-world-devs")
  )

get_repos_trees(
  gitstats = github_stats
)

github_stats <- create_gitstats() |>
  set_github_host(
    repos = c("r-world-devs/GitStats", "openpharma/DataFakeR")
  )

get_repos_trees(
  gitstats = github_stats,
  pattern = "\\.md"
)
