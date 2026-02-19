# pr_by_repo GitHub query is built properly

    Code
      gh_pr_from_repo_query
    Output
      [1] "query GetPullRequestsFromRepo($org: String!, $repo: String!) {\n          repository(owner: $org, name: $repo) {\n            pullRequests(first: 100, ) {\n              edges {\n                node {\n                  number\n                  created_at: createdAt\n                  merged_at: mergedAt\n                  state\n                  author {\n                    login\n                  }\n                  source_branch: baseRefName\n                  target_branch: headRefName\n                }\n              }\n            }\n          }\n        }"

