# commits_by_repo query is built properly

    Code
      commits_by_repo_query
    Output
      [1] "{\n          repository(name: \"GitStats\", owner: \"r-world-devs\") {\n            defaultBranchRef {\n              target {\n                ... on Commit {\n                  history(since: \"2023-01-01T00:00:00Z\"\n                          until: \"2023-02-28T00:00:00Z\"\n                          \n                          ) {\n                    pageInfo {\n                      hasNextPage\n                      endCursor\n                    }\n                    edges {\n                      node {\n                        ... on Commit {\n                          id\n                          committed_date: committedDate\n                          author {\n                            name\n                          }\n                          additions\n                          deletions\n                        }\n                      }\n                    }\n                  }\n                }\n              }\n            }\n          }\n        }"

# repos_by_org query is built properly

    Code
      repos_by_org_query
    Output
      [1] "\n        query {\n          repositoryOwner(login: \"r-world-devs\") {\n            ... on Organization {\n              repositories(first: 100 ) {\n              totalCount\n              pageInfo {\n                endCursor\n                hasNextPage\n              }\n              nodes {\n                id\n                name\n                stars: stargazerCount\n                forks: forkCount\n                created_at: createdAt\n                last_push: pushedAt\n                last_activity_at: updatedAt\n                languages (first: 5) { nodes {name} }\n                issues_open: issues (first: 100 states: [OPEN]) {\n                  totalCount\n                }\n                issues_closed: issues (first: 100 states: [CLOSED]) {\n                  totalCount\n                }\n                contributors: defaultBranchRef {\n                  target {\n                    ... on Commit {\n                      id\n                      history(since: \"2020-01-01T00:00:00Z\") {\n                        edges {\n                          node {\n                            committer {\n                              user {\n                                login\n                                id\n                              }\n                            }\n                          }\n                        }\n                      }\n                    }\n                  }\n                }\n                repo_url: url\n              }\n            }\n            }\n          }\n        }"

