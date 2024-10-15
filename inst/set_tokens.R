# to TEST create tokens with insufficient scopes

create_gitstats() |>
  set_github_host(
    orgs = "r-world-devs",
    token = Sys.getenv("GITHUB_PAT_INSUFFICIENT")
  ) |>
  get_repos()

create_gitstats() |>
  set_gitlab_host(
    orgs = "mbtests"
  ) |>
  get_repos()

create_gitstats() |>
  set_gitlab_host(
    orgs = "mbtests",
    token = Sys.getenv("GITLAB_PAT_PUBLIC_INSUFFICIENT")
  ) |>
  get_repos()

create_gitstats() |>
  set_github_host(
    orgs = "r-world-devs"
  )
