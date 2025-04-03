# issues_by_repo GitLab query is built properly

    Code
      gl_issues_from_repo_query
    Output
      [1] "\n      query getIssuesFromRepo ($fullPath: ID!) {\n          project(fullPath: $fullPath) {\n            issues(first: 100\n                   ) {\n              pageInfo {\n                hasNextPage\n      \t\t\t\t  endCursor\n      \t\t\t\t}\n              edges {\n                node {\n                  number: iid\n                  title\n                  description\n                  created_at: createdAt\n                  closed_at: closedAt\n                  state\n                  url: webUrl\n                  author {\n                    login: username\n                  }\n                }\n              }\n            }\n          }\n        }\n      "

