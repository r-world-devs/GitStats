# `pull_repos_contributors()` adds contributors to repos table

    Code
      gh_repos_by_code_table <- test_rest$pull_repos_contributors(test_mocker$use(
        "gh_repos_by_code_table"), settings = test_settings)
    Message
      i [GitHub][Engine:REST][org:openpharma] Pulling contributors...

# `pull_repos()` works

    Code
      result <- test_rest$pull_repos(org = "r-world-devs", code = "shiny", settings = test_settings)
    Message
      i [GitHub][Engine:REST][code:shiny][org:r-world-devs] Pulling repositories...

