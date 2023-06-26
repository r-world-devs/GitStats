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

