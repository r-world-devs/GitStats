#file with example workflow for basic package functionality - will be helpful later tu build vignettes
pkgload::load_all()

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
    orgs = c("mbtests")
  )

# examples for getting repos (default argument for parameter 'by' is 'org')
get_repos(git_stats)

# You can set your search preferences
setup_preferences(git_stats,
                  search_param = "team",
                  team_name = "RWD")

# now getting repos will throw error as you did not define your team
get_repos(git_stats)

# set your team members
git_stats %>%
  add_team_member("Adam Foryś", "galachad") %>%
  add_team_member("Kamil Wais", "kalimu") %>%
  add_team_member("Krystian Igras", "krystian8207") %>%
  add_team_member("Karolina Marcinkowska", "marcinkowskak") %>%
  add_team_member("Kamil Koziej", "Cotau") %>%
  add_team_member("Maciej Banaś", "maciekbanas")

# check your settings
git_stats

# now pull repos by default by team
git_stats %>%
  get_repos()

# Change your settings to searches by phrase:
setup_preferences(git_stats,
                  search_param = "phrase",
                  phrase = "covid",
                  language = "R")

# Search by phrase
get_repos(git_stats)

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

########## HANDLING ORGANIZATIONS ##########

# You do not need to enter `orgs` when setting connection for the Git Hosting
# Service.

git_stats <- create_gitstats() %>%
  set_connection(
    api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT")
  )

# Still, you will have to decide on orgs when you choose to explore your
# repositories. This may make sense and be useful in case when you specify team.
# `GitStats` will automatically pull oganizations that are linkeds to your team
# members.

git_stats %>%
  set_team(team_name = "RWD-IE",
           "galachad",
           "krystian8207",
           "kalimu",
           "marcinkowskak",
           "Cotau",
           "maciekbanas") %>%
  get_repos(by = "team")

# There is also possibility to pull automatically organizations when not
# specifying team, but due to possible large number of repositories this may be
# rather tricky. Therefore if there are more than specified in your
# `set_org_limit` (default to 1000) it will pull only up to that limit.

git_stats <- create_gitstats() %>%
  set_connection(
    api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT")
  ) %>%
  get_repos()

########## SETTING STORAGE ##########

# You can set your storage to capture API results and automate your workflow.

set_storage(gitstats_obj = git_stats,
            type = "SQLite",
            dbname = 'devel/storage/my_sqlite'
) %>%
  get_repos() %>%
  get_commits(by = "team",
              date_from = "2020-01-01",
              date_until = "2022-12-31")

# Next your `get()` functions will retrieve only new data.
get_commits(gitstats_obj = git_stats,
            date_from = "2020-01-01")

# You can have quick glimpse on your storage:

show_storage(git_stats)

# Still, if you wish to save your storage, but switch off saving results to
# data.base for the time-being you can

storage_off(git_stats) %>%
  get_repos(by = "team")

# And then, if you change your mind again

storage_on(git_stats)

# A Postgres connection requires more credentials. You can also pass your schema.

# set_storage(gitstats_obj = git_stats,
#             type = "Postgres",
#             dbname = 'dbname',
#             schema = 'my_schema',
#             host = 'host_url',
#             port = 1111,
#             user = Sys.getenv('TEAM_USERNAME'),
#             password = Sys.getenv('TEAM_PASSWORD')
# )
