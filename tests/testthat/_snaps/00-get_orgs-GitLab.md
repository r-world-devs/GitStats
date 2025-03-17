# groups GitLab query is built properly

    Code
      gl_orgs_query
    Output
      [1] "query GetGroups($groupCursor: String!) {\n            groups (after: $groupCursor) {\n              pageInfo {\n                endCursor\n                hasNextPage\n              }\n              edges {\n                node {\n                  name\n                  description\n                  fullPath\n                  webUrl\n                  projectsCount\n                  avatarUrl\n                }\n              }\n            }\n        }"

# get_orgs prints message

    Code
      gitlab_orgs_table <- gitlab_testhost$get_orgs(output = "full_table", verbose = TRUE)
    Message
      i [GitLab][Engine:GraphQL] Pulling organizations...

