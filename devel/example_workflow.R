#file with example workflow for basic package functionality - will be helpful later tu build vignettes
pkgload::load_all()

# Start by creating your GitStats object and setting connections.
git_stats <- create_gitstats() %>%
  set_connection(
    api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = c("r-world-devs", "openpharma")
  ) %>%
  set_connection(
    api_url = "https://gitlab.com/api/v4",
    token = Sys.getenv("GITLAB_PAT_PUBLIC"),
    orgs = c("mbtests", "erasmusmc-public-health")
  )

git_stats

# examples for getting repos (default search parameter is 'org')
get_repos(git_stats)
get_commits(git_stats, date_from = "2022-01-01")

# set your team members
git_stats %>%
  add_team_member("Adam Foryś", "galachad") %>%
  add_team_member("Kamil Wais", "kalimu") %>%
  add_team_member("Krystian Igras", "krystian8207") %>%
  add_team_member("Karolina Marcinkowska", "marcinkowskak") %>%
  add_team_member("Kamil Koziej", "Cotau") %>%
  add_team_member("Maciej Banaś", "maciekbanas")

# You can set your search preferences
setup(git_stats,
      search_param = "team",
      team_name = "RWD")

# now pull repos by default by team
get_repos(git_stats)
get_commits(git_stats, date_from = "2020-01-01")

# Change your settings to searches by phrase:
setup(git_stats,
      search_param = "phrase",
      phrase = "shiny")

# Search by phrase
get_repos(git_stats)

# you can plot repos sorted by last activity
plot_repos(git_stats)

# examples for getting and plotting commits
plot_commits(git_stats, stats_by = "month")

