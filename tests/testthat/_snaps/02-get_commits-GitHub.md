# commits_by_repo GitHub query is built properly

    Code
      gh_commits_from_repo_query
    Output
      [1] "\n      query GetCommitsFromRepo($repo: String!\n                               $org: String!\n                               $since: GitTimestamp\n                               $until: GitTimestamp){\n          repository(name: $repo, owner: $org) {\n            defaultBranchRef {\n              target {\n                ... on Commit {\n                  history(since: $since\n                          until: $until\n                          ) {\n                    pageInfo {\n                      hasNextPage\n                      endCursor\n                    }\n                    edges {\n                      node {\n                        ... on Commit {\n                          id\n                          committed_date: committedDate\n                          author {\n                            name\n                            user {\n                              name\n                              login\n                            }\n                          }\n                          additions\n                          deletions\n                          repository {\n                            url\n                          }\n                        }\n                      }\n                    }\n                  }\n                }\n              }\n            }\n          }\n        }"

# get_commits_from_orgs for GitHub prints messages

    Code
      gh_commits_from_orgs <- github_testhost_priv$get_commits_from_orgs(since = "2023-03-01",
        until = "2023-04-01", verbose = TRUE, progress = FALSE)
    Message
      > [Host:GitHub][Engine:GraphQl][Scope:r-world-devs] Pulling commits 🕒...

# get_commits_from_repos for GitHub prints messages

    Code
      gh_commits_from_repos <- github_testhost_priv$get_commits_from_repos(since = "2023-03-01",
        until = "2023-04-01", verbose = TRUE, progress = FALSE)
    Message
      > [Host:GitHub][Engine:GraphQl][Scope:test_org: 1 repos] Pulling commits 🕒...

