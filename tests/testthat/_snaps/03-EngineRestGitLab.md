# `check_token()` prints error when token exists but does not grant access

    x HTTP 401 Unauthorized.

# `pull_repos_contributors()` adds contributors to repos table

    Code
      gl_repos_table_with_contributors <- test_rest$pull_repos_contributors(
        test_mocker$use("gl_repos_table"))
    Message
      i [GitLab][Engine:REST][org:MB Tests] Pulling contributors...

# `pull_repos_by_phrase()` works

    Code
      result <- test_rest$pull_repos(org = "gitlab-org", settings = test_settings)
    Message
      i [GitLab][Engine:REST][phrase:covid][org:gitlab-org] Searching repositories...

# `pull_commits()` works as expected

    Code
      result <- test_rest$pull_commits(org = "mbtests", date_from = "2023-01-01",
        date_until = "2023-04-20", settings = test_settings)
    Message
      i [GitLab][Engine:REST][org:mbtests] Pulling repositories...
      i [GitLab][Engine:REST][org:mbtests] Pulling commits...

# `pull_commits()` works with repositories implied

    Code
      result <- test_rest$pull_commits(org = "mbtests", repos = c("gitstatstesting",
        "gitstats-testing-2"), date_from = "2023-01-01", date_until = "2023-04-20",
      settings = test_settings_repo)
    Message
      i [GitLab][Engine:REST][org:mbtests][custom repositories] Pulling commits...

