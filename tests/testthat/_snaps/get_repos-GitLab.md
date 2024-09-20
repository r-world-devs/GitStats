# repos queries are built properly

    Code
      gl_repos_by_org_query
    Output
      [1] "query GetReposByOrg($org: ID!) {\n        group(fullPath: $org) {\n          projects(first: 100 ) {\n            count\n            pageInfo {\n              hasNextPage\n              endCursor\n            }\n            edges {\n              node {\n                repo_id: id\n                repo_name: name\n                repo_path: path\n                ... on Project {\n                  repository {\n                    rootRef\n                  }\n                }\n                stars: starCount\n                forks: forksCount\n                created_at: createdAt\n                last_activity_at: lastActivityAt\n                languages {\n                  name\n                }\n                issues: issueStatusCounts {\n                  all\n                  closed\n                  opened\n                }\n                group {\n                  path\n                }\n                repo_url: webUrl\n              }\n            }\n          }\n        }\n      }"

# GitHost prepares table from GitLab repositories response

    Code
      gl_repos_by_code_table <- gitlab_testhost_priv$prepare_repos_table_from_rest(
        repos_list = test_mocker$use("gl_repos_by_code_tailored"))
    Message
      i Preparing repositories table...

# `get_repos_contributors()` adds contributors to repos table

    Code
      gl_repos_table_with_contributors <- test_rest_gitlab$get_repos_contributors(
        test_mocker$use("gl_repos_table_with_api_url"), settings = test_settings)

