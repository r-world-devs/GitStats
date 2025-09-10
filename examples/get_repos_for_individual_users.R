create_gitstats() %>%
  set_github_host(
    repos = "ddsjoberg/gtsummary"
  ) %>%
  get_repos()

create_gitstats() %>%
  set_github_host(
    repos = "hadley/elmer"
  ) %>%
  get_repos()
