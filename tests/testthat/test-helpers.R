test_that("`gql_response()` returns list", {
  gql_query <- GraphQLQuery$new()
  query <- gql_query$groups_by_user("maciekbanas")

  expect_type(
    gql_response(api_url = "https://gitlab.com/api/graphql",
                 gql_query = query,
                 token = Sys.getenv("GITLAB_PAT")),
    "list"
  )
})
