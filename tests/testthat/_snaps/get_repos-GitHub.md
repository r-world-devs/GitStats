# repos_by_org query is built properly

    Code
      gh_repos_by_org_query
    Output
      [1] "\n        query GetReposByOrg($org: String!) {\n          repositoryOwner(login: $org) {\n            ... on Organization {\n              repositories(first: 100 ) {\n              totalCount\n        pageInfo {\n          endCursor\n          hasNextPage\n        }\n        nodes {\n          repo_id: id\n          repo_name: name\n          default_branch: defaultBranchRef {\n            name\n          }\n          stars: stargazerCount\n          forks: forkCount\n          created_at: createdAt\n          last_activity_at: pushedAt\n          languages (first: 5) { nodes {name} }\n          issues_open: issues (first: 100 states: [OPEN]) {\n            totalCount\n          }\n          issues_closed: issues (first: 100 states: [CLOSED]) {\n            totalCount\n          }\n          organization: owner {\n            login\n          }\n          repo_url: url\n        }\n              }\n            }\n          }\n        }"

# `prepare_repos_table()` prepares repos table

    Code
      gh_repos_by_code_table <- github_testhost_priv$prepare_repos_table_from_rest(
        repos_list = test_mocker$use("gh_repos_by_code_tailored"))
    Message
      i Preparing repositories table...

# `get_all_repos()` works as expected

    Code
      gh_repos_table <- github_testhost_priv$get_all_repos()
    Message
      i [Host:GitHub][Engine:GraphQl][Scope:r-world-devs] Pulling repositories...

# `get_repos_contributors()` adds contributors to repos table

    Code
      gh_repos_by_code_table <- test_rest_github$get_repos_contributors(repos_table = test_mocker$
        use("gh_repos_by_code_table"), progress = FALSE)

