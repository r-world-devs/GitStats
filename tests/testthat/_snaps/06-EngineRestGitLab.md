# `pull_repos_contributors()` adds contributors to repos table

    Code
      gl_repos_table_with_contributors <- test_rest$pull_repos_contributors(
        test_mocker$use("gl_repos_table_with_api_url"), settings = test_settings)

# `get_commits_authors_handles_and_names()` adds author logis and names to commits table

    Code
      gl_commits_table <- test_rest$get_commits_authors_handles_and_names(
        commits_table = test_mocker$use("gl_commits_table"), verbose = TRUE)
    Message
      i Looking up for authors' names and logins...

