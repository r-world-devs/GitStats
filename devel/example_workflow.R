#file with example workflow for basic package functionality - will be helpful later tu build vignettes

# Start by creating your GitStats object and setting connections.

git_stats <- create_gitstats() %>%
  set_connection(
    api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"), # You can set up your own token as an environment variable in .Renviron file (based in home directory)
    orgs = c("openpharma", "r-world-devs")
  ) %>%
  set_connection(
    api_url = "https://gitlab.com/api/v4",
    token = Sys.getenv("GITLAB_PAT"),
    orgs = c("erasmusmc-public-health")
  )

# examples for getting repos (default argument for parameter 'by' is 'org')

get_repos(git_stats)

# set your team members

git_stats %>%
  set_team(team_name = "RWD-IE",
           "galachad",
           "krystian8207",
           "kalimu",
           "marcinkowskak",
           "Cotau",
           "maciekbanas") %>%
  get_repos(by = "team")

# you can plot repos sorted by last activity

plot_repos(git_stats)

# reset your repos and plot it once more

git_stats %>%
  get_repos(by = "org") %>%
  plot_repos(repos_n = 15)

# examples for getting and plotting commits

git_stats %>%
  get_commits(date_from = "2022-01-01",
              by = "team") %>%
  plot_commits(stats_by = "day")

git_stats %>%
  get_commits(date_from = "2020-01-01",
              by = "team") %>%
  plot_commits(stats_by = "month")

# you can change your organizations also

git_stats %>%
  set_organizations(api_url = "https://api.github.com",
                    orgs = c("pharmaverse", "openpharma"))

# You do not need to enter `orgs` when setting connection for the private Git
# Hosting Service, but if there are more than specified in your `set_org_limit`
# (default to 300) it will pull only up to that limit. It may be really useful
# for enterprise Git Services, where you have limited number of repo
# owners/project groups and want to pull stats from all of them.

# git_stats <- create_gitstats() %>%
#   set_connection(
#     api_url = "your_api",
#     token = Sys.getenv("YOUR_TOKEN")
#   )
