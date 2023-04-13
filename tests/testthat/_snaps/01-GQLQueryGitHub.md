# commits_by_repo query is built properly

    Code
      commits_by_repo_query
    Output
      [1] "{\n          repository(name: \"GitStats\", owner: \"r-world-devs\") {\n            defaultBranchRef {\n              target {\n                ... on Commit {\n                  history(since: \"2023-01-01T00:00:00Z\"\n                          until: \"2023-02-28T00:00:00Z\"\n                          \n                          ) {\n                    pageInfo {\n                      hasNextPage\n                      endCursor\n                    }\n                    edges {\n                      node {\n                        ... on Commit {\n                          id\n                          committed_date: committedDate\n                          author {\n                            name\n                          }\n                          additions\n                          deletions\n                        }\n                      }\n                    }\n                  }\n                }\n              }\n            }\n          }\n        }"

