# `get_commits_authors_handles_and_names()` adds author logis and names to commits table

    Code
      gl_commits_table <- test_rest_gitlab$get_commits_authors_handles_and_names(
        commits_table = test_mocker$use("gl_commits_table"), verbose = TRUE)
    Message
      i Looking up for authors' names and logins...

