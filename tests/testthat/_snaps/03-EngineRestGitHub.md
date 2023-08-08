# `check_token()` prints error when token exists but does not grant access

    x HTTP 401 Unauthorized.

# `add_commits_stats()` works as expected

    Code
      gh_rest_commits_table_with_stats <- test_rest_priv$add_commits_stats(
        commits_table = test_mocker$use("gh_rest_commits_table")[1:5, ])
    Message <cliMessage>
      i [GitHub][Engine:REST] Pulling commits stats...

# `add_repos_contributors()` adds contributors to repos table

    Code
      gh_repos_by_phrase_table <- test_rest$add_repos_contributors(test_mocker$use(
        "gh_repos_by_phrase_table"))
    Message <cliMessage>
      i [GitHub][Engine:REST] Pulling contributors...

# `get_repos()` works

    Code
      result <- test_rest$get_repos(org = "r-world-devs", settings = settings)
    Message <cliMessage>
      i [GitHub][Engine:REST][phrase:shiny][org:r-world-devs] Searching repositories...

# supportive method for getting commits works

    Code
      gh_rest_commits_table <- test_rest$get_commits_supportive(org = "r-world-devs",
        date_from = "2023-01-01", date_until = "2023-07-01", settings = test_settings)
    Message <cliMessage>
      i [GitHub][Engine:REST][org:r-world-devs] Pulling commits...

