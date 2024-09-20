# commits_by_repo GitHub query is built properly

    Code
      gh_commits_by_repo_query
    Output
      [1] "{\n          repository(name: \"GitStats\", owner: \"r-world-devs\") {\n            defaultBranchRef {\n              target {\n                ... on Commit {\n                  history(since: \"2023-01-01T00:00:00Z\"\n                          until: \"2023-02-28T00:00:00Z\"\n                          \n                          ) {\n                    pageInfo {\n                      hasNextPage\n                      endCursor\n                    }\n                    edges {\n                      node {\n                        ... on Commit {\n                          id\n                          committed_date: committedDate\n                          author {\n                            name\n                            user {\n                              name\n                              login\n                            }\n                          }\n                          additions\n                          deletions\n                        }\n                      }\n                    }\n                  }\n                }\n              }\n            }\n          }\n        }"

# `get_commits_authors_handles_and_names()` adds author logis and names to commits table

    Code
      gl_commits_table <- test_rest_gitlab$get_commits_authors_handles_and_names(
        commits_table = test_mocker$use("gl_commits_table"), verbose = TRUE)
    Message
      i Looking up for authors' names and logins...

