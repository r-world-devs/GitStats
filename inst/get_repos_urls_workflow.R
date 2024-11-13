devtools::load_all(".")

test_gitstats <- create_gitstats() |>
  set_github_host(
    orgs = c("r-world-devs", "openpharma")
  )

get_repos_urls(test_gitstats, with_code = "shiny")

# should return 2 repos URLs
create_gitstats() %>%
  set_github_host(
    repos = c("r-world-devs/GitStats", "r-world-devs/shinyCohortBuilder")
  ) %>%
  get_repos_urls()

# should return 2 repos URLs
create_gitstats() %>%
  set_github_host(
    repos = c("r-world-devs/GitStats", "r-world-devs/shinyCohortBuilder")
  ) %>%
  get_repos_urls(type = "api")

create_gitstats() %>%
  set_gitlab_host(
    orgs = "mbtests"
  ) %>%
  get_repos_urls()

# should return 1 repo URL
create_gitstats() %>%
  set_gitlab_host(
    repos = "mbtests/gitstatstesting"
  ) %>%
  get_repos_urls(type = "api")
