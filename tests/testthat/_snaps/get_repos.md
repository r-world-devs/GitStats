# repos_by_org query is built properly

    Code
      gh_repos_by_org_query
    Output
      [1] "\n        query GetReposByOrg($org: String!) {\n          repositoryOwner(login: $org) {\n            ... on Organization {\n              repositories(first: 100 ) {\n              totalCount\n        pageInfo {\n          endCursor\n          hasNextPage\n        }\n        nodes {\n          repo_id: id\n          repo_name: name\n          default_branch: defaultBranchRef {\n            name\n          }\n          stars: stargazerCount\n          forks: forkCount\n          created_at: createdAt\n          last_activity_at: pushedAt\n          languages (first: 5) { nodes {name} }\n          issues_open: issues (first: 100 states: [OPEN]) {\n            totalCount\n          }\n          issues_closed: issues (first: 100 states: [CLOSED]) {\n            totalCount\n          }\n          organization: owner {\n            login\n          }\n          repo_url: url\n        }\n              }\n            }\n          }\n        }"

# repos queries are built properly

    Code
      gl_repos_by_org_query
    Output
      [1] "query GetReposByOrg($org: ID!) {\n        group(fullPath: $org) {\n          projects(first: 100 ) {\n            count\n            pageInfo {\n              hasNextPage\n              endCursor\n            }\n            edges {\n              node {\n                repo_id: id\n                repo_name: name\n                repo_path: path\n                ... on Project {\n                  repository {\n                    rootRef\n                  }\n                }\n                stars: starCount\n                forks: forksCount\n                created_at: createdAt\n                last_activity_at: lastActivityAt\n                languages {\n                  name\n                }\n                issues: issueStatusCounts {\n                  all\n                  closed\n                  opened\n                }\n                group {\n                  path\n                }\n                repo_url: webUrl\n              }\n            }\n          }\n        }\n      }"

