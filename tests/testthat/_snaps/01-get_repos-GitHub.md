# repos_by_org query is built properly

    Code
      gh_repos_by_org_query
    Output
      [1] "\n        query GetReposByOrg($login: String! $repoCursor: String!) {\n          repositoryOwner(login: $login) {\n            ... on Organization {\n              \n      repositories(first: 100 after: $repoCursor) {\n        totalCount\n        pageInfo {\n          endCursor\n          hasNextPage\n        }\n        nodes {\n          repo_id: id\n          repo_name: name\n          default_branch: defaultBranchRef {\n            name\n          }\n          stars: stargazerCount\n          forks: forkCount\n          created_at: createdAt\n          last_activity_at: pushedAt\n          languages (first: 5) { nodes {name} }\n          issues_open: issues (first: 100 states: [OPEN]) {\n            totalCount\n          }\n          issues_closed: issues (first: 100 states: [CLOSED]) {\n            totalCount\n          }\n          organization: owner {\n            login\n          }\n          repo_url: url\n        }\n      }\n      \n            }\n          }\n        }"

# `get_all_repos()` prints proper message

    Code
      gh_repos_table <- github_testhost_priv$get_all_repos(verbose = TRUE)
    Message
      i [Host:GitHub][Engine:GraphQl][Scope:test-org] Pulling repositories...

