# `check_token()` prints error when token exists but does not grant access

    x HTTP 401 Unauthorized.

# `add_repos_contributors()` adds contributors to repos table

    Code
      gl_repos_table <- test_rest$add_repos_contributors(test_mocker$use(
        "gl_repos_table"))
    Message <cliMessage>
      i [GitLab][Engine:REST] Pulling contributors...

# `get_repos_by_phrase()` works

    Code
      result <- test_rest$get_repos(org = "erasmusmc-public-health", settings = settings)
    Message <cliMessage>
      i [GitLab][Engine:REST][phrase:covid][org:erasmusmc-public-health] Searching repositories...

# `get_commits()` works as expected

    Code
      result <- test_rest$get_commits(org = "mbtests", date_from = "2023-01-01",
        date_until = "2023-04-20", settings = settings)
    Message <cliMessage>
      i [GitLab][Engine:REST][org:mbtests] Pulling repositories...
      i [GitLab][Engine:REST][org:mbtests] Pulling commits...

