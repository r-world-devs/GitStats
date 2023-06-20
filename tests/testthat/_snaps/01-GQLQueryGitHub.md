# commits_by_repo query is built properly

    Code
      gh_commits_by_repo_query
    Output
      [1] "{\n          repository(name: \"GitStats\", owner: \"r-world-devs\") {\n            defaultBranchRef {\n              target {\n                ... on Commit {\n                  history(since: \"2023-01-01T00:00:00Z\"\n                          until: \"2023-02-28T00:00:00Z\"\n                          \n                          ) {\n                    pageInfo {\n                      hasNextPage\n                      endCursor\n                    }\n                    edges {\n                      node {\n                        ... on Commit {\n                          id\n                          committed_date: committedDate\n                          author {\n                            name\n                          }\n                          additions\n                          deletions\n                        }\n                      }\n                    }\n                  }\n                }\n              }\n            }\n          }\n        }"

# repos_by_org query is built properly

    Code
      gh_repos_by_org_query
    Output
      [1] "\n        query GetReposByOrg($org: String!) {\n          repositoryOwner(login: $org) {\n            ... on Organization {\n              repositories(first: 100 ) {\n              totalCount\n        pageInfo {\n          endCursor\n          hasNextPage\n        }\n        nodes {\n          id\n          name\n          stars: stargazerCount\n          forks: forkCount\n          created_at: createdAt\n          last_activity_at: pushedAt\n          languages (first: 5) { nodes {name} }\n          issues_open: issues (first: 100 states: [OPEN]) {\n            totalCount\n          }\n          issues_closed: issues (first: 100 states: [CLOSED]) {\n            totalCount\n          }\n          organization: owner {\n            login\n          }\n          repo_url: url\n        }\n              }\n            }\n          }\n        }"

# repos_by_user query is built properly

    Code
      gh_repos_by_user_query
    Output
      [1] "\n        query GetReposByUser($user: String!) {\n          user(login: $user) {\n            repositories(\n              first: 100\n              ownerAffiliations: COLLABORATOR\n              ) {\n              totalCount\n        pageInfo {\n          endCursor\n          hasNextPage\n        }\n        nodes {\n          id\n          name\n          stars: stargazerCount\n          forks: forkCount\n          created_at: createdAt\n          last_activity_at: pushedAt\n          languages (first: 5) { nodes {name} }\n          issues_open: issues (first: 100 states: [OPEN]) {\n            totalCount\n          }\n          issues_closed: issues (first: 100 states: [CLOSED]) {\n            totalCount\n          }\n          organization: owner {\n            login\n          }\n          repo_url: url\n        }\n            }\n          }\n        }"

