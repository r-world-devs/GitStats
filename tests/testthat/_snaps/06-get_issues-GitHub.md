# issues_by_repo GitHub query is built properly

    Code
      gh_issues_from_repo_query
    Output
      [1] "\n      query getIssuesFromRepo ($repo: String!\n                               $org: String!) {\n          repository(name: $repo, owner: $org) {\n            issues(first: 100\n                   ) {\n              pageInfo {\n                hasNextPage\n      \t\t\t\t  endCursor\n      \t\t\t\t}\n              edges {\n                node {\n                  number\n                  title\n                  description: body\n                  created_at: createdAt\n                  closed_at: closedAt\n                  state\n                  url\n                  author {\n                    login\n                  }\n                }\n              }\n            }\n          }\n        }\n      "

