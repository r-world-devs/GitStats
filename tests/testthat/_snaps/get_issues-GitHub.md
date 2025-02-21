# issues_by_repo GitHub query is built properly

    Code
      gh_issues_from_repo_query
    Output
      [1] "\n      query getIssuesFromRepo ($repo: String!\n                               $org: String!\n                               $since: GitTimestamp\n                               $until: GitTimestamp) {\n          repository(name: $repo, owner: $org) {\n            issues(first: 100\n                   ) {\n              edges {\n                node {\n                  title\n                  body\n                  state\n                }\n              }\n            }\n          }\n        }\n      "

