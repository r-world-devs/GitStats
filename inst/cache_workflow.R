test_gitstats <- create_gitstats() |>
  set_github_host(
    orgs = "openpharma"
  )

repos_urls <- get_repos_urls(test_gitstats, with_code = "pharma")
# should use cache
repos_urls <- get_repos_urls(test_gitstats, with_code = "pharma")
# should NOT use cache
repos_urls <- get_repos_urls(test_gitstats)
# should use cache
repos_urls <- get_repos_urls(test_gitstats)

# should NOT use cache
repos_urls <- get_repos_urls(test_gitstats, with_files = c("renv.lock", "DESCRIPTION"))
# should use cache
repos_urls <- get_repos_urls(test_gitstats, with_files = c("renv.lock", "DESCRIPTION"))
# should NOT use cache
repos_urls <- get_repos_urls(test_gitstats, with_files = "renv.lock")
# should use cache
repos_urls <- get_repos_urls(test_gitstats, with_files = "renv.lock")

repos <- get_repos(test_gitstats)
repos <- get_repos(test_gitstats)

repos <- get_repos(test_gitstats, with_code = "shiny", in_files = c("renv.lock", "DESCRIPTION"))
repos <- get_repos(test_gitstats, with_code = "shiny", in_files = c("renv.lock", "DESCRIPTION"))

repos <- get_repos(test_gitstats, with_code = "shiny")
repos <- get_repos(test_gitstats, with_code = "shiny")

# no cache
commits <- get_commits(test_gitstats, since = "2024-01-01")
# cache
commits <- get_commits(test_gitstats, since = "2024-01-01")

# no cache
commits <- get_commits(test_gitstats, since = "2024-01-02")
# cache
commits <- get_commits(test_gitstats, since = "2024-01-02")

# no cache
commits <- get_commits(test_gitstats, since = "2024-01-02", until = "2024-06-30")
# cache
commits <- get_commits(test_gitstats, since = "2024-01-02", until = "2024-06-30")

# no cache
users <- get_users(test_gitstats, c("kalimu", "maciekbanas"))
# cache
users <- get_users(test_gitstats, c("kalimu", "maciekbanas"))

# no cache
users <- get_users(test_gitstats, c("kalimu", "maciekbanas", "marcinkowskak"))
users <- get_users(test_gitstats, c("kalimu", "maciekbanas", "marcinkowskak"))

# no cache
files_data <- get_files(test_gitstats, file_path = "DESCRIPTION")
# cache
files_data <- get_files(test_gitstats, file_path = "DESCRIPTION")

# no cache
files_data <- get_files(test_gitstats, file_path = c("DESCRIPTION", "LICENSE"))
# cache
files_data <- get_files(test_gitstats, file_path = c("DESCRIPTION", "LICENSE"))

# no cache
files_data <- get_files(test_gitstats, file_path = "DESCRIPTION")
# cache
files_data <- get_files(test_gitstats, file_path = "DESCRIPTION")

# no cache
release_logs <- get_release_logs(test_gitstats, since = "2024-01-01")
# cache
release_logs <- get_release_logs(test_gitstats, since = "2024-01-01")

# no cache
package_usage <- get_repos_with_R_packages(test_gitstats, packages = "shiny")
# cache
package_usage <- get_repos_with_R_packages(test_gitstats, packages = "shiny")
# no cache
package_usage <- get_repos_with_R_packages(test_gitstats, packages = "shiny", cache = FALSE)

# no cache
package_usage <- get_repos_with_R_packages(test_gitstats, packages = "shiny", only_loading = TRUE)
# cache
package_usage <- get_repos_with_R_packages(test_gitstats, packages = "shiny", only_loading = TRUE)
