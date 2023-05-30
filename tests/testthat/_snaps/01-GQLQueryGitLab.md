# user query is built properly

    Code
      gl_repos_by_org_query
    Output
      [1] "{\n        group(fullPath: \"mbtests\") {\n          projects(first: 100 ) {\n            count\n            pageInfo {\n              hasNextPage\n              endCursor\n            }\n            edges {\n              node {\n                id\n                name\n                createdAt\n                starCount\n                forksCount\n                lastActivityAt\n                languages {\n                  name\n                }\n                issueStatusCounts {\n                  all\n                  closed\n                  opened\n                }\n              }\n            }\n          }\n        }\n      }"

