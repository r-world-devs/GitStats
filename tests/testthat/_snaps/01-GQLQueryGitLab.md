# repos_by_org query is built properly

    Code
      gl_repos_by_org_query
    Output
      [1] "{\n        group(fullPath: \"mbtests\") {\n          projects(first: 100) {\n            count\n            pageInfo {\n              hasNextPage\n              endCursor\n            }\n            edges {\n              node {\n                id\n                name\n                stars: starCount\n                forks: forksCount\n                createdAt\n                last_activity_at: lastActivityAt\n                languages {\n                  name\n                }\n                issueStatusCounts {\n                  all\n                  closed\n                  opened\n                }\n              }\n            }\n          }\n        }\n      }"

