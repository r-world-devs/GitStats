# get_pr_from_orgs for GitHub prints messages

    Code
      gh_pr_from_orgs <- github_testhost_priv$get_pr_from_orgs(verbose = TRUE,
        progress = FALSE)
    Message
      > [Host:GitHub][Engine:GraphQl][Scope:r-world-devs] Pulling pull requests 🔀...

# get_pr_from_repos for GitHub prints messages

    Code
      gh_pr_from_repos <- github_testhost_priv$get_pr_from_repos(verbose = TRUE,
        progress = FALSE)
    Message
      > [Host:GitHub][Engine:GraphQl][Scope:test_org: 1 repos] Getting pull requests 🔀...

# pr_by_repo GitHub query is built properly

    Code
      gh_pr_from_repo_query
    Output
      [1] "query GetPullRequestsFromRepo($org: String!, $repo: String!) {\n          repository(owner: $org, name: $repo) {\n            pullRequests(first: 100, ) {\n              pageInfo {\n                 hasNextPage\n                endCursor\n              }\n              edges {\n                node {\n                  number\n                  created_at: createdAt\n                  merged_at: mergedAt\n                  state\n                  author {\n                    login\n                  }\n                  source_branch: headRefName\n                  target_branch: baseRefName\n                }\n              }\n            }\n          }\n        }"

