git_stats <- create_gitstats() |>
  set_github_host(
    orgs = "r-world-devs",
    repos = "openpharma/DataFakeR"
  )

get_repos(git_stats)

get_repos_urls(git_stats,
               with_files = "project_metadata.yaml",
               progress = FALSE)

get_repos_urls(git_stats,
               with_files = "project_metadata.yaml",
               cache = FALSE,
               verbose = FALSE,
               progress = TRUE)

get_repos_urls(git_stats,
               with_code = "Shiny",
               in_files = "DESCRIPTION",
               cache = FALSE,
               verbose = FALSE)

get_repos(git_stats)

get_repos(git_stats,
          cache = FALSE,
          verbose = FALSE,
          progress = TRUE)

get_repos(git_stats,
          cache = FALSE,
          verbose = FALSE)

get_repos(git_stats,
          with_code = "Shiny")

get_repos(git_stats,
          with_code = "Shiny",
          cache = FALSE,
          verbose = FALSE)

get_repos(git_stats,
          with_code = "Shiny",
          cache = FALSE,
          verbose = FALSE,
          progress = TRUE)

get_repos(git_stats,
          with_code = "Shiny",
          in_files = "DESCRIPTION",
          cache = FALSE)

get_repos(git_stats,
          with_code = c("shiny", "purrr"),
          in_files = c("DESCRIPTION", "NAMESPACE"),
          verbose = FALSE)

get_commits(git_stats, since = "2024-06-01")

get_commits(git_stats,
            since = "2024-06-02",
            verbose = FALSE,
            progress = TRUE)

get_release_logs(
  gitstats = git_stats,
  since = "2024-06-02",
  verbose = FALSE
)

get_release_logs(
  gitstats = git_stats,
  since = "2024-06-01",
  verbose = TRUE
)
