devtools::load_all(".")

openpharma_stats <- create_gitstats() %>%
  set_github_host(
    orgs = "openpharma"
  )

get_repos_with_R_packages(openpharma_stats, packages = "no_such_package")

get_repos_with_R_packages(
  openpharma_stats,
  packages = c("purrr", "shiny")
)

get_repos_with_R_packages(
  openpharma_stats,
  packages = c("dplyr", "shiny"),
  split_output = TRUE
)

pharmaverse_stats <- create_gitstats() %>%
  set_github_host(
    orgs = "pharmaverse"
  )

get_repos_with_R_packages(
  pharmaverse_stats,
  packages = c("purrr", "shiny")
)

rwd_stats <- create_gitstats() %>%
  set_github_host(
    repos = c("openpharma/DataFakeR", "r-world-devs/GitAI"),
    orgs = "r-world-devs"
  )

get_repos_with_R_packages(rwd_stats,
                    packages = c("purrr", "shiny"))
