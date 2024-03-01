# `get_authors_ids()` works as expected

    Code
      test_gql_gh$get_authors_ids(test_team)
    Output
      [1] "MDQ6VXNlcjQyOTYzOTA=" "MDQ6VXNlcjE5NzI5ODQ0" "MDQ6VXNlcjc0MjEyOTMz"
      [4] "MDQ6VXNlcjMwOTMxODE5"

# GitHub GraphQL Engine pulls files from organization

    Code
      github_files_response <- test_gql_gh$pull_file_from_org("r-world-devs",
        "meta_data.yaml")

# `pull_repos()` works as expected

    Code
      gh_repos_org <- test_gql_gh$pull_repos(org = "r-world-devs", settings = test_settings)
    Message
      i [GitHub][Engine:GraphQL][org:r-world-devs] Pulling repositories...

---

    Code
      gh_repos_team <- test_gql_gh$pull_repos(org = "r-world-devs", settings = test_settings)
    Message
      i [GitHub][Engine:GraphQL][org:r-world-devs][team:] Pulling repositories...

# `pull_commits()` retrieves commits in the table format

    Code
      commits_table <- test_gql_gh$pull_commits(org = "r-world-devs", date_from = "2023-01-01",
        date_until = "2023-02-28", settings = test_settings)
    Message
      i [GitHub][Engine:GraphQL][org:r-world-devs] Pulling commits...

# `pull_files()` pulls files in the table format

    Code
      gh_files_table <- test_gql_gh$pull_files(org = "r-world-devs", file_path = "LICENSE")
    Message
      i [Engine:GraphQL][org:r-world-devs] Pulling LICENSE files...

# `pull_release_logs()` pulls release logs in the table format

    Code
      releases_table <- test_gql_gh$pull_release_logs(org = "r-world-devs",
        date_from = "2023-05-01", date_until = "2023-09-30")
    Message
      i [Engine:GraphQL][org:r-world-devs] Pulling releases...
      i [GitHub][Engine:GraphQL][org:r-world-devs] Pulling repositories...

