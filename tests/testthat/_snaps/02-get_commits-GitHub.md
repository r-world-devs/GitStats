# commits_by_repo GitHub query is built properly

    Code
      gh_commits_from_repo_query
    Output
      [1] "\n      query GetCommitsFromRepo($repo: String!\n                               $org: String!\n                               $since: GitTimestamp\n                               $until: GitTimestamp){\n          repository(name: $repo, owner: $org) {\n            defaultBranchRef {\n              target {\n                ... on Commit {\n                  history(since: $since\n                          until: $until\n                          ) {\n                    pageInfo {\n                      hasNextPage\n                      endCursor\n                    }\n                    edges {\n                      node {\n                        ... on Commit {\n                          id\n                          committed_date: committedDate\n                          author {\n                            name\n                            user {\n                              name\n                              login\n                            }\n                          }\n                          additions\n                          deletions\n                          repository {\n                            url\n                          }\n                        }\n                      }\n                    }\n                  }\n                }\n              }\n            }\n          }\n        }"

# `get_commits_from_one_repo()` handles 502 error and returns empty list

    Code
      commits_from_repo <- test_graphql_github_priv$get_commits_from_one_repo(org = "r-world-devs",
        repo = "GitStats", since = "2023-01-01", until = "2023-02-28")
    Message
      x unused arguments (org = org, repo = repo, since = since, until = until, commits_cursor = commits_cursor)

