devtools::load_all(".")

test_gitstats <- create_gitstats() %>%
  set_github_host(
    orgs = "openpharma"
  )

get_R_package_usage(test_gitstats, packages = "no_such_package")

get_R_package_usage(
  test_gitstats,
  packages = c("purrr", "shiny")
)

get_R_package_usage(
  test_gitstats,
  packages = c("dplyr", "shiny"),
  split_output = TRUE
)
