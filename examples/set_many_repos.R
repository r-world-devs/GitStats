pharma_stats <- create_gitstats() |>
  set_github_host(
    orgs = "pharmaverse"
  )

pharma_repos <- pharma_stats |>
  get_repos(
    add_contributors = FALSE
  )

pharma_stats <- create_gitstats() |>
  set_github_host(
    repos = pharma_repos$fullname
  )

pharma_stats

pharma_stats |>
  get_release_logs(
    since = "2020-01-01",
    cache = FALSE
  )

pharma_stats |>
  get_commits(
    since = "2020-01-01",
    cache = FALSE
  )

pharma_stats |>
  get_repos(
    cache = FALSE
  )

# very slow, better to run it when whole orgs are set
pharma_stats |>
  get_repos(
    with_code = "shiny",
    cache = FALSE
  )

pharma_stats |>
  get_repos_urls(
    cache = FALSE
  )

pharma_stats |>
  get_files(
    pattern = "\\.md",
    depth = 1L
  )
