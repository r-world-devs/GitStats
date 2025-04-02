# orgs GitHub query is built properly

    Code
      gh_orgs_query
    Output
      [1] "query {\n          search(first: 100, type: USER, query: \"type:org\" ) {\n            pageInfo {\n               hasNextPage\n               endCursor\n            }\n            edges {\n              node{\n                ... on Organization {\n      name\n      description\n      login\n      url\n      repositories (first: 100) {\n        totalCount\n      }\n      membersWithRole(first: 100) {\n        totalCount\n      }\n      avatarUrl\n    }\n              }\n            }\n          }\n        }"

# org GitHub query is built properly

    Code
      gh_org_query
    Output
      [1] "\n        query GetOrg($org: String!) {\n          organization(login: $org) {\n      name\n      description\n      login\n      url\n      repositories (first: 100) {\n        totalCount\n      }\n      membersWithRole(first: 100) {\n        totalCount\n      }\n      avatarUrl\n    }\n        }"

# get_orgs prints message

    Code
      gh_orgs_full_response <- test_graphql_github$get_orgs(output = "full_table",
        verbose = TRUE)
    Message
      > [Host:GitHub][Engine:GraphQL] Pulling organizations...

