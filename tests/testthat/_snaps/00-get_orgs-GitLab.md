# groups GitLab query is built properly

    Code
      gl_orgs_query
    Output
      [1] "query GetGroups($groupCursor: String!) {\n            groups (after: $groupCursor) {\n              pageInfo {\n                endCursor\n                hasNextPage\n              }\n              edges {\n                node {\n      name\n      description\n      fullPath\n      webUrl\n      projectsCount\n      groupMembersCount\n      groupMembers {\n        edges {\n          node {\n            user {\n              username\n            }\n          }\n        }\n      }\n      avatarUrl\n    }\n              }\n            }\n        }"

# group GitLab query is built properly

    Code
      gl_org_query
    Output
      [1] "\n      query GetGroup($org: ID!) {\n        group(fullPath: $org) {\n      name\n      description\n      fullPath\n      webUrl\n      projectsCount\n      groupMembersCount\n      groupMembers {\n        edges {\n          node {\n            user {\n              username\n            }\n          }\n        }\n      }\n      avatarUrl\n    }\n      }\n    "

# get_orgs prints message

    Code
      gitlab_orgs_table <- gitlab_testhost_priv$get_orgs_from_host(verbose = TRUE)
    Message
      i [GitLab][Engine:GraphQL] Pulling organizations...

