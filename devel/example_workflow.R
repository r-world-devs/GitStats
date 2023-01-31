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

# Search by phrase

get_repos(git_stats,
          by = "phrase",
          phrase = "covid",
          language = "R")

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

git_stats %>%
  get_commits(date_from = "2020-06-01") %>%
  plot_commit_lines()

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

# You can set your storage to capture API results and automate your workflow.
# Next your `get()` functions will retrieve only new data.

set_storage(gitstats_obj = git_stats,
            type = "SQLite",
            dbname = 'devel/storage/my_sqlite'
) %>%
  get_repos() %>%
  get_commits(date_from = "2020-01-01")

# set_storage(gitstats_obj = git_stats,
#             type = "Postgres",
#             dbname = 'dbname',
#             host = 'host_url',
#             port = 1111,
#             user = Sys.getenv('TEAM_USERNAME'),
#             password = Sys.getenv('TEAM_PASSWORD')
# )

# You can have quick glimpse on your storage:

show_storage(git_stats)

