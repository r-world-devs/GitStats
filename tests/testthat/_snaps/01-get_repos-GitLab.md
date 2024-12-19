# repos queries are built properly

    Code
      gl_repos_by_org_query
    Output
      [1] "\n        query GetReposByOrg($org: ID! $repo_cursor: String!) {\n          group(fullPath: $org) {\n            projects(first: 100 after: $repo_cursor) {\n            \n      count\n      pageInfo {\n        hasNextPage\n        endCursor\n      }\n      edges {\n        node {\n          repo_id: id\n          repo_name: name\n          repo_path: path\n          ... on Project {\n            repository {\n              rootRef\n            }\n          }\n          stars: starCount\n          forks: forksCount\n          created_at: createdAt\n          last_activity_at: lastActivityAt\n          languages {\n            name\n          }\n          issues: issueStatusCounts {\n            all\n            closed\n            opened\n          }\n          namespace {\n            path: fullPath\n          }\n          repo_url: webUrl\n        }\n      }\n            }\n          }\n        }"

# get_repos_from_org prints proper message

    Code
      gl_repos_from_orgs <- gitlab_testhost_priv$get_repos_from_orgs(verbose = TRUE,
        progress = FALSE)
    Message
      i [Host:GitLab][Engine:GraphQl][Scope:mbtests] Pulling repositories...

