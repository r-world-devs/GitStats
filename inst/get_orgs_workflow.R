git_stats <- create_gitstats() |>
  set_github_host(
    orgs = c("r-world-devs", "maciekbanas", "openpharma", "pharmaverse", "insightsengineering")
  )

get_orgs(git_stats)

git_stats <- create_gitstats() |>
  set_github_host(
    orgs = c("r-world-devs"),
    repos = "openpharma/DataFakeR"
  )

get_orgs(git_stats)
