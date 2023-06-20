# repos queries are built properly

    Code
      gl_repos_by_org_query
    Output
      [1] "query GetReposByOrg($org: ID!) {\n        group(fullPath: $org) {\n          projects(first: 100 ) {\n            count\n            pageInfo {\n              hasNextPage\n              endCursor\n            }\n            edges {\n              node {\n                id\n                name\n                stars: starCount\n                forks: forksCount\n                created_at: createdAt\n                last_activity_at: lastActivityAt\n                languages {\n                  name\n                }\n                issues: issueStatusCounts {\n                  all\n                  closed\n                  opened\n                }\n                group {\n                  name\n                }\n                repo_url: webUrl\n              }\n            }\n          }\n        }\n      }"

