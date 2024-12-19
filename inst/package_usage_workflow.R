devtools::load_all(".")

openpharma_stats <- create_gitstats() %>%
  set_github_host(
    orgs = "openpharma"
  )

get_R_package_usage(openpharma_stats, packages = "no_such_package")

get_R_package_usage(
  openpharma_stats,
  packages = c("purrr", "shiny")
)

get_R_package_usage(
  openpharma_stats,
  packages = c("dplyr", "shiny"),
  split_output = TRUE
)

pharmaverse_stats <- create_gitstats() %>%
  set_github_host(
    orgs = "pharmaverse"
  )

get_R_package_usage(pharmaverse_stats,
                    packages = c("purrr", "shiny"))

rwd_stats <- create_gitstats() %>%
  set_github_host(
    repos = "openpharma/DataFakeR",
    orgs = "r-world-devs"
  )

get_R_package_usage(rwd_stats,
                    packages = c("purrr", "shiny"))
