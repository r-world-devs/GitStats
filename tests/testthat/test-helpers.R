test_that("`get_response()` returns proper status", {

  bad_endpoint <- "https://api.github.com/orgs/everybody_loves_somebody"

  expect_message(
    get_response(
      endpoint = bad_endpoint,
      token = Sys.getenv("GITHUB_PAT")
    ),
    "HTTP 404 No such address"
  )

})

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
