# GitHub GraphQL Engine pulls files from organization

    Code
      github_files_response <- test_gql_gh$pull_file_from_org("r-world-devs",
        "meta_data.yaml")

# `pull_repos()` works as expected

    Code
      gh_repos_table <- test_gql_gh$pull_repos(org = "r-world-devs", settings = test_settings)
    Message
      i [GitHub][Engine:GraphQL][org:r-world-devs] Pulling repositories...

# `pull_files()` pulls files in the table format

    Code
      gh_files_table <- test_gql_gh$pull_files(org = "r-world-devs", file_path = "LICENSE",
        settings = test_settings)
    Message
      i [Engine:GraphQL][org:r-world-devs] Pulling LICENSE files...

# `pull_release_logs()` pulls release logs in the table format

    Code
      releases_table <- test_gql_gh$pull_release_logs(org = "r-world-devs",
        date_from = "2023-05-01", date_until = "2023-09-30", settings = test_settings)
    Message
      i [Engine:GraphQL][org:r-world-devs] Pulling releases...
      i [GitHub][Engine:GraphQL][org:r-world-devs] Pulling repositories...

