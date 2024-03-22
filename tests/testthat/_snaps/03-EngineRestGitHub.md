# `check_token()` prints error when token exists but does not grant access

    x HTTP 401 Unauthorized.

# `pull_repos_contributors()` adds contributors to repos table

    Code
      gh_repos_by_phrase_table <- test_rest$pull_repos_contributors(test_mocker$use(
        "gh_repos_by_phrase_table"), settings = test_settings)
    Message
      i [GitHub][Engine:REST][org:openpharma] Pulling contributors...

# `pull_repos()` works

    Code
      result <- test_rest$pull_repos(org = "r-world-devs", settings = test_settings)
    Message
      i [GitHub][Engine:REST][phrase:shiny][org:r-world-devs] Searching repositories...

