# groups GitLab query is built properly

    Code
      gl_orgs_query
    Output
      [1] "query GetGroups($groupCursor: String!) {\n            groups (after: $groupCursor) {\n              pageInfo {\n                endCursor\n                hasNextPage\n              }\n              edges {\n                node {\n      name\n      description\n      fullPath\n      webUrl\n      projectsCount\n      groupMembersCount\n      avatarUrl\n    }\n              }\n            }\n        }"

# group GitLab query is built properly

    Code
      gl_org_query
    Output
      [1] "\n      query GetGroup($org: ID!) {\n        group(fullPath: $org) {\n      name\n      description\n      fullPath\n      webUrl\n      projectsCount\n      groupMembersCount\n      avatarUrl\n    }\n      }\n    "

# get_orgs_count prints message

    Code
      orgs_count <- test_rest_gitlab$get_orgs_count(verbose = TRUE)
    Message
      i [Host:GitLab][Engine:REST] Pulling number of all organizations...

# get_orgs prints message

    Code
      gl_orgs_full_response <- test_graphql_gitlab$get_orgs(orgs_count = 3L, output = "full_table",
        verbose = TRUE, progress = FALSE)
    Message
      i [Host:GitLab][Engine:GraphQL] Pulling organizations...

