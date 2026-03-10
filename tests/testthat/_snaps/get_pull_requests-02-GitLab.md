# pr_by_repo GitLab query is built properly

    Code
      gl_pr_from_repo_query
    Output
      [1] "\n      query getPullRequestsFromRepo ($fullPath: ID!) {\n          project(fullPath: $fullPath) {\n            mergeRequests(first: 100, ) {\n              pageInfo {\n                endCursor\n                hasNextPage\n              }\n              edges {\n                node {\n                  number: iid\n                  created_at: createdAt\n                  merged_at: mergedAt\n                  state\n                  author {\n                    username\n                  }\n                  source_branch: sourceBranch\n                  target_branch: targetBranch\n                }\n              }\n            }\n          }\n        }\n      "

# get_pr_from_orgs for GitLab prints message

    Code
      gl_pr_from_orgs <- gitlab_testhost_priv$get_pr_from_orgs(verbose = TRUE,
        progress = FALSE)
    Message
      > Using cached repositories data...
      > [Host:GitLab][Engine:GraphQl][Scope:mbtests] Pulling pull requests 🔀...

# get_pr_from_repos for GitLab prints message

    Code
      gl_pr_from_repos <- gitlab_testhost_priv$get_pr_from_repos(verbose = TRUE,
        progress = FALSE)
    Message
      > [Host:GitLab][Engine:GraphQl][Scope:mbtests: 1 repos] Getting pull requests 🔀...

