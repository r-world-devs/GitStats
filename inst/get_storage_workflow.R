devtools::load_all(".")

git_stats <- create_gitstats() %>%
  set_github_host(
    orgs = c("r-world-devs", "openpharma"),
    token = Sys.getenv("GITHUB_PAT")
  )

release_logs <- get_release_logs(
  gitstats = git_stats,
  since = "2024-01-01"
)

repos_urls <- get_repos_urls(
  gitstats = git_stats,
  with_code = "shiny"
)

files_structure <- get_files_structure(
  gitstats = git_stats,
  pattern = "\\.md",
  depth = 1L
)

git_stats

get_storage(git_stats)

get_storage(git_stats, "commits")
get_storage(git_stats, "repos_urls")
get_storage(git_stats, "release_logs")
get_storage(git_stats, "files_structure")
