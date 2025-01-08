devtools::load_all()

git_stats <- create_gitstats() |>
  set_github_host(
    orgs = c("r-world-devs", "openparma"),
    repos = c("openpharma/DataFakR", "r-world-devs/GitAI"),
    token = Sys.getenv("GITHUB_PAT"),
    .error = FALSE
  ) |>
  set_gitlab_host(
    orgs = c("mbtests", "makbest"),
    repos = c("makbest/something", "mbtests/gitstatstesting", "krystianigras/gitlab-test"),
    token = Sys.getenv("GITLAB_PAT_PUBLIC"),
    .error = FALSE
  )

git_stats

# Setting users instead of orgs

git_stats <- create_gitstats() |>
  set_github_host(
    orgs = c("maciekbanas", "ddsjoberg", "mattsecrest"),
    token = Sys.getenv("GITHUB_PAT")
  )
get_repos(git_stats)
get_repos_urls(git_stats)

git_stats <- create_gitstats() |>
  set_gitlab_host(
    orgs = c("krystianigras"),
    token = Sys.getenv("GITLAB_PAT_PUBLIC")
  )

get_repos(git_stats, add_contributors = FALSE)
get_repos_urls(git_stats)
