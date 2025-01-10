# repos_by_org query is built properly

    Code
      gh_repos_by_org_query
    Output
      [1] "\n        query GetReposByOrg($login: String!) {\n          repositoryOwner(login: $login) {\n            ... on Organization {\n              \n      repositories(first: 100) {\n        totalCount\n        pageInfo {\n          endCursor\n          hasNextPage\n        }\n        nodes {\n          repo_id: id\n          repo_name: name\n          default_branch: defaultBranchRef {\n            name\n          }\n          stars: stargazerCount\n          forks: forkCount\n          created_at: createdAt\n          last_activity_at: pushedAt\n          languages (first: 5) { nodes {name} }\n          issues_open: issues (first: 100 states: [OPEN]) {\n            totalCount\n          }\n          issues_closed: issues (first: 100 states: [CLOSED]) {\n            totalCount\n          }\n          organization: owner {\n            login\n          }\n          repo_url: url\n        }\n      }\n      \n            }\n          }\n        }"

# `get_repos_with_code_from_orgs()` pulls raw response

    Code
      repos_with_code_from_orgs_raw <- github_testhost_priv$
        get_repos_with_code_from_orgs(code = "shiny", in_files = c("DESCRIPTION",
        "NAMESPACE"), output = "raw", verbose = TRUE)
    Message
      i [Host:GitHub][Engine:REST][Scope:test_org] Pulling repositories...

# `get_repos_with_code_from_host()` pulls and parses output into table

    Code
      repos_with_code_from_host_table <- github_testhost_priv$
        get_repos_with_code_from_host(code = "DESCRIPTION", in_path = TRUE, output = "table_full",
        verbose = TRUE)
    Message
      i [Host:GitHub][Engine:REST] Pulling repositories...

# `get_repos_with_code_from_repos()` works

    Code
      repos_with_code_from_repos_full <- github_testhost_priv$
        get_repos_with_code_from_repos(code = "tests", output = "table_full",
        verbose = TRUE)
    Message
      i [Host:GitHub][Engine:REST][Scope:] Pulling repositories...
      i Preparing repositories table...

# `get_repos_with_code_from_repos()` pulls minimum version of table

    Code
      repos_with_code_from_repos_min <- github_testhost_priv$
        get_repos_with_code_from_repos(code = "tests", in_files = "DESCRIPTION",
        output = "table_min", verbose = TRUE)
    Message
      i [Host:GitHub][Engine:REST][Scope:] Pulling repositories...
      i Preparing repositories table...

# `get_repos_with_code_from_host()` pulls raw response

    Code
      repos_with_code_from_host_raw <- github_testhost_priv$
        get_repos_with_code_from_host(code = "shiny", in_files = c("DESCRIPTION",
        "NAMESPACE"), output = "raw", verbose = TRUE)
    Message
      i [Host:GitHub][Engine:REST] Pulling repositories...

# get_repos_from_repos works

    Code
      gh_repos_individual <- github_testhost_priv$get_repos_from_repos(verbose = TRUE,
        progress = FALSE)
    Message
      i [Host:GitHub][Engine:GraphQl][Scope:test_org/TestRepo] Pulling repositories...

# `get_all_repos()` is set to scan whole git host

    Code
      gh_repos <- github_testhost_all_priv$get_all_repos(verbose = TRUE, progress = FALSE)
    Message
      i [Host:GitHub][Engine:GraphQl] Pulling all organizations...

# `get_repos_contributors()` works on GitHost level

    Code
      gh_repos_with_contributors <- github_testhost_priv$get_repos_contributors(
        repos_table = test_mocker$use("gh_repos_table_with_platform"), verbose = TRUE,
        progress = FALSE)
    Message
      i [Host:GitHub][Engine:REST] Pulling contributors...

