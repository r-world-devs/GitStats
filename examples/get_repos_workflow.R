devtools::load_all()

git_stats <- create_gitstats() |>
  set_github_host()

repos_with_gitstats <- git_stats |>
  get_repos(add_contributors = FALSE,
            with_code = "GitStats",
            language = "R")


gitlab_stats <- create_gitstats() |>
  set_gitlab_host(
    host = "your.host.com" # pass your host here
  )
gitlab_repos_with_gitstats <-
  gitlab_stats |>
  get_repos(add_contributors = FALSE,
            with_code = "GitStats",
            language = "R")
