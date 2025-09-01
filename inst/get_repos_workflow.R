devtools::load_all()

git_stats <- create_gitstats() |>
  set_github_host()

repos_with_gitstats <- git_stats |>
  get_repos(add_contributors = FALSE,
            with_code = "GitStats",
            language = "R")

rwd_stats <- create_gitstats() |>
  set_github_host(orgs = "r-world-devs")

get_repos(rwd_stats)

gitlab_stats <- create_gitstats() |>
  set_gitlab_host(
    host = "code.roche.com"
  )
gitlab_repos_with_gitstats <-
  gitlab_stats |>
  get_repos(add_contributors = FALSE,
            with_code = "GitStats",
            language = "R")


rwdie_stats <- create_gitstats() |>
  set_gitlab_host(
    host = "code.roche.com",
    orgs = "RWDInsightsEngineering"
  )

rwdie_repos <- rwdie_stats |>
  get_repos(add_contributors = FALSE,
            language = "R")

rwdie_stats |>
  get_repos(
    with_code = "GitStats",
    add_contributors = FALSE
  )

rwd_stats <- create_gitstats() |>
  set_github_host(orgs = c("r-world-devs", "openpharma", "pharmaverse"))

repos_with_gitstats <- rwd_stats |>
  get_repos(add_contributors = FALSE,
            with_code = "GitStats")

rwd_stats <- create_gitstats() |>
  set_github_host(orgs = c("r-world-devs", "pharmaverse"),
                  repos = "openpharma/DataFakeR")

rwdie_stats <- create_gitstats() |>
  set_gitlab_host(
    host = "code.roche.com",
    repos = "RWDInsightsEngineering/RocheMeta"
  )

pharmaverse_stats <- create_gitstats() |>
  set_github_host(
    orgs = "pharmaverse"
  )
get_repos(pharmaverse_stats, with_code = "GitStats")

rwd_stats <- create_gitstats() |>
  set_gitlab_host(
    host = "code.roche.com",
    orgs = "stage-datascience/rwd"
  )

get_repos(rwd_stats, with_code = "get_data", add_contributors = FALSE)
