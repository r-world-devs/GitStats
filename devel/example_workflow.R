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
    orgs = c("mbtests", "gitlab-org")
  )

git_stats

# examples for getting repos (default search parameter is 'org')
get_repos(git_stats)
add_repos_contributors(git_stats)
git_stats$show_repos()
get_repos(git_stats, add_contributors = TRUE)

get_commits(git_stats, date_from = "2022-01-01")

# setup your language you are interested in
setup(git_stats,
      language = "Python")
get_repos(git_stats)

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
      team_name = "RWD",
      language = "R")

# now pull repos by default by team
get_repos(git_stats)
get_commits(git_stats, date_from = "2020-01-01")

reset_language(git_stats)

# Change your settings to searches by phrase:
setup(git_stats,
      search_param = "phrase",
      phrase = "shiny")

# Search by phrase
get_repos(git_stats)

# you can plot repos sorted by last activity
plot_repos(git_stats)

# examples for getting and plotting commits
plot_commits(git_stats)

# get information on users
git_stats %>%
  get_users(c("maciekbanas", "kalimu", "marcinkowskak", "Cotau", "krystian8207"))
git_stats$show_users()

# SHOWCASES

# throws sometimes 502 Bad Gateway error (GraphQL one)
# should switch to REST if that is the case

create_gitstats() %>%
  set_connection(
    api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = c("insightsengineering")
  ) %>% get_repos()

# one token does not exist

git_stats <- create_gitstats() %>%
  set_connection(
    api_url = "https://api.github.com",
    token = Sys.getenv("DOES_NOT_EXIST"),
    orgs = c("r-world-devs", "openpharma")
  ) %>%
  set_connection(
    api_url = "https://gitlab.com/api/v4",
    token = Sys.getenv("GITLAB_PAT_PUBLIC"),
    orgs = c("mbtests", "erasmusmc-public-health")
  )
git_stats

# a token exists but does not grant access

git_stats <- create_gitstats() %>%
  set_connection(
    api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = c("r-world-devs", "openpharma")
  ) %>%
  set_connection(
    api_url = "https://gitlab.com/api/v4",
    token = Sys.getenv("GITLAB_PAT"),
    orgs = c("mbtests", "erasmusmc-public-health")
  )
git_stats

# wrong orgs

git_stats <- create_gitstats() %>%
  set_connection(
    api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = c("rworlddevs", "openpharma")
  ) %>%
  set_connection(
    api_url = "https://gitlab.com/api/v4",
    token = Sys.getenv("GITLAB_PAT_PUBLIC"),
    orgs = c("mbtests", "public health")
  )
git_stats
