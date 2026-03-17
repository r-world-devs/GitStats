devtools::load_all()

git_stats <- create_gitstats() |>
  set_github_host(
    orgs = c("r-world-devs", "openpharma"),
    token = Sys.getenv("GITHUB_PAT")
  )

set_parallel()

git_stats |> 
  get_commits(since = "2024-01-01", cache = FALSE)

set_parallel(FALSE)

git_stats |> 
  get_commits(since = "2024-01-01", cache = FALSE)
