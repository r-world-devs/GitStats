#file with example workflow for basic package functionality - will be helpful later tu build vignettes
pkgload::load_all()

# Start by creating your GitStats object and setting connections.
git_stats <- create_gitstats() %>%
  set_host(
    api_url = "https://api.github.com",
    orgs = c("r-world-devs", "openpharma")
  ) %>%
  set_host(
    api_url = "https://gitlab.com/api/v4",
    orgs = c("mbtests", "gitlab-org")
  )

git_stats

# examples for getting repos (default search parameter is 'org')
pull_repos(git_stats)
pull_repos_contributors(git_stats)
dplyr::glimpse(show_repos(git_stats))

pull_repos(git_stats, add_contributors = TRUE)

pull_commits(git_stats, date_from = "2022-01-01")

# setup your language you are interested in
set_params(
  git_stats,
  language = "Python"
)
pull_repos(git_stats)

# set your team members
git_stats %>%
  set_team_member("Adam Foryś", "galachad") %>%
  set_team_member("Kamil Wais", "kalimu") %>%
  set_team_member("Krystian Igras", "krystian8207") %>%
  set_team_member("Karolina Marcinkowska", "marcinkowskak") %>%
  set_team_member("Kamil Koziej", "Cotau") %>%
  set_team_member("Maciej Banaś", "maciekbanas")

# You can set your search preferences
set_params(
  git_stats,
  search_param = "team",
  team_name = "RWD",
  language = "R"
)

# now pull repos by default by team
pull_repos(git_stats)
show_repos(git_stats)
pull_commits(git_stats, date_from = "2020-01-01")

reset_language(git_stats)

# Change your settings to searches by phrase:
set_params(
  git_stats,
  search_param = "phrase",
  phrase = "shiny"
)

# Search by phrase
pull_repos(git_stats)

# you can plot repos sorted by last activity
plot_repos(git_stats)

# error should pop out when search param set to 'phrase':
pull_commits(git_stats, date_from = "2020-01-01")

reset(git_stats)

# now it should work
pull_commits(git_stats, date_from = "2020-01-01")

# examples for plotting commits
plot_commits(git_stats)

# get information on users
git_stats %>%
  pull_users(c("maciekbanas", "kalimu", "marcinkowskak", "Cotau", "krystian8207"))
git_stats$show_users()

# SHOWCASES

# throws sometimes 502 Bad Gateway error (GraphQL one)
# should switch to REST if that is the case

create_gitstats() %>%
  set_host(
    api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = c("insightsengineering")
  ) %>% get_repos()

# one token does not exist

git_stats <- create_gitstats() %>%
  set_host(
    api_url = "https://api.github.com",
    token = Sys.getenv("DOES_NOT_EXIST"),
    orgs = c("r-world-devs", "openpharma")
  ) %>%
  set_host(
    api_url = "https://gitlab.com/api/v4",
    token = Sys.getenv("GITLAB_PAT_PUBLIC"),
    orgs = c("mbtests", "erasmusmc-public-health")
  )
git_stats

# a token exists but does not grant access

git_stats <- create_gitstats() %>%
  set_host(
    api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = c("r-world-devs", "openpharma")
  ) %>%
  set_host(
    api_url = "https://gitlab.com/api/v4",
    token = Sys.getenv("GITLAB_PAT"),
    orgs = c("mbtests", "erasmusmc-public-health")
  )
git_stats

# wrong orgs

git_stats <- create_gitstats() %>%
  set_host(
    api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = c("rworlddevs", "openpharma")
  ) %>%
  set_host(
    api_url = "https://gitlab.com/api/v4",
    token = Sys.getenv("GITLAB_PAT_PUBLIC"),
    orgs = c("mbtests", "public health")
  )
git_stats

## add gitlab subgroups

git_stats <- create_gitstats() %>%
  set_host(
    api_url = "https://gitlab.com/api/v4",
    token = Sys.getenv("GITLAB_PAT_PUBLIC"),
    orgs = "mbtests/subgroup"
  )
git_stats
