# repos_by_org query is built properly

    Code
      gh_repos_by_org_query
    Output
      [1] "\n        query GetReposByOrg($login: String!) {\n          repositoryOwner(login: $login) {\n            ... on Organization {\n              \n      repositories(first: 100) {\n        totalCount\n        pageInfo {\n          endCursor\n          hasNextPage\n        }\n        nodes {\n      repo_id: id\n      repo_name: name\n      repo_path: name\n      repo_fullpath: nameWithOwner\n      default_branch: defaultBranchRef {\n        name\n      }\n      stars: stargazerCount\n      forks: forkCount\n      created_at: createdAt\n      last_activity_at: pushedAt\n      languages(first: 5) {\n        nodes {\n          name\n        }\n      }\n      issues_open: issues(first: 100, states: [OPEN]) {\n        totalCount\n      }\n      issues_closed: issues(first: 100, states: [CLOSED]) {\n        totalCount\n      }\n      organization: owner {\n        login\n      }\n      repo_url: url\n      defaultBranchRef {\n        target {\n          ... on Commit {\n            oid\n          }\n        }\n      }\n    }\n      }\n            }\n          }\n        }"

# repos_by_user query is built properly

    Code
      gh_repos_by_user_query
    Output
      [1] "\n        query GetUsersRepos($login: String!){\n          user(login: $login) {\n            \n      repositories(first: 100) {\n        totalCount\n        pageInfo {\n          endCursor\n          hasNextPage\n        }\n        nodes {\n      repo_id: id\n      repo_name: name\n      repo_path: name\n      repo_fullpath: nameWithOwner\n      default_branch: defaultBranchRef {\n        name\n      }\n      stars: stargazerCount\n      forks: forkCount\n      created_at: createdAt\n      last_activity_at: pushedAt\n      languages(first: 5) {\n        nodes {\n          name\n        }\n      }\n      issues_open: issues(first: 100, states: [OPEN]) {\n        totalCount\n      }\n      issues_closed: issues(first: 100, states: [CLOSED]) {\n        totalCount\n      }\n      organization: owner {\n        login\n      }\n      repo_url: url\n      defaultBranchRef {\n        target {\n          ... on Commit {\n            oid\n          }\n        }\n      }\n    }\n      }\n          }\n        }"

# repos_by_ids query is built properly

    Code
      gh_repos_by_ids_query
    Output
      [1] "\n        query GetReposByIds($ids: [ID!]!) {\n          nodes(ids: $ids) {\n            ... on Repository {\n      repo_id: id\n      repo_name: name\n      repo_path: name\n      repo_fullpath: nameWithOwner\n      default_branch: defaultBranchRef {\n        name\n      }\n      stars: stargazerCount\n      forks: forkCount\n      created_at: createdAt\n      last_activity_at: pushedAt\n      languages(first: 5) {\n        nodes {\n          name\n        }\n      }\n      issues_open: issues(first: 100, states: [OPEN]) {\n        totalCount\n      }\n      issues_closed: issues(first: 100, states: [CLOSED]) {\n        totalCount\n      }\n      organization: owner {\n        login\n      }\n      repo_url: url\n      defaultBranchRef {\n        target {\n          ... on Commit {\n            oid\n          }\n        }\n      }\n    \n            }\n          }\n        }\n        "

# parse_search_response prints message

    Code
      gh_repos_raw_output <- github_testhost_priv$parse_search_response(
        search_response = test_mocker$use("gh_search_repos_for_code"), org = gh_org,
        output = "raw", verbose = TRUE)
    Message
      > Parsing search response with GraphQL...

# `get_repos_with_code_from_orgs()` pulls raw response

    Code
      repos_with_code_from_orgs_raw <- github_testhost_priv$
        get_repos_with_code_from_orgs(code = "shiny", in_files = c("DESCRIPTION",
        "NAMESPACE"), language = "R", output = "raw", verbose = TRUE)
    Message
      > [Host:GitHub][Engine:REST][Scope:test_org] Pulling repositories...

# `get_repos_with_code_from_host()` pulls and parses output into table

    Code
      repos_with_code_from_host_table <- github_testhost_priv$
        get_repos_with_code_from_host(code = "DESCRIPTION", in_path = TRUE, output = "table_full",
        verbose = TRUE)
    Message
      > [Host:GitHub][Engine:REST] Pulling repositories...

# `get_repos_with_code_from_repos()` works

    Code
      repos_with_code_from_repos_full <- github_testhost_priv$
        get_repos_with_code_from_repos(code = "tests", output = "table", verbose = TRUE)
    Message
      > [Host:GitHub][Engine:REST][Scope:] Pulling repositories...

# get_repos_from_repos works

    Code
      gh_repos_individual <- github_testhost_priv$get_repos_from_repos(verbose = TRUE,
        progress = FALSE)
    Message
      > [Host:GitHub][Engine:GraphQl][Scope:test_org: 1 repos] Pulling repositories...

# `get_repos_contributors()` works on GitHost level

    Code
      gh_repos_with_contributors <- github_testhost_priv$get_repos_contributors(
        repos_table = test_mocker$use("gh_repos_table_with_platform"), verbose = TRUE,
        progress = FALSE)
    Message
      > [Host:GitHub][Engine:REST] Pulling contributors...

