# `pull_repos_contributors()` adds contributors to repos table

    Code
      gh_repos_by_code_table <- test_rest$pull_repos_contributors(test_mocker$use(
        "gh_repos_by_code_table"), settings = test_settings)
    Message
      i [GitHub][Engine:REST][org:openpharma] Pulling contributors...

