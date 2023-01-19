#file with example workflow for basic package functionality - will be helpful later tu build vignettes

git_stats <- GitStats$new()

git_stats$set_connection(
  api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"), # You can set up your own token as an environment variable in .Renviron file (based in home directory)
  orgs = c("openpharma", "r-world-devs")
)

git_stats

# you can add new connection, e.g. from GitLab

git_stats$set_connection(
  api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT"),
  orgs = c("erasmusmc-public-health")
)

git_stats

# examples for getting repos (default argument for parameter 'by' is 'org')

git_stats$get_repos()

# set your team members

git_stats$set_team(team_name = "RWD-IE",
                   "galachad",
                   "krystian8207",
                   "kalimu",
                   "marcinkowskak",
                   "Cotau",
                   "maciekbanas")

git_stats$get_repos(by = "team")

# you can plot repos sorted by last activity

git_stats$plot_repos()

# choose more repos to show

git_stats$plot_repos(repos_n = 20)

# and reset your repos show and plot it once more

git_stats$get_repos(by = "org")$plot_repos(repos_n = 15)

# examples for getting commits

git_stats$get_commits(date_from = "2022-01-01")

git_stats$plot_commits(stats_by = "day")

git_stats$get_commits(date_from = "2022-01-01",
                      by = "team")$plot_commits(stats_by = "day")

git_stats$get_commits(date_from = "2020-01-01",
                      by = "team")$plot_commits(stats_by = "month")


