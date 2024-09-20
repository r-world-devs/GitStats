test_gql_gl <- EngineGraphQLGitLab$new(
  gql_api_url = "https://gitlab.com/api/graphql",
  token = Sys.getenv("GITLAB_PAT_PUBLIC")
)

# private methods

test_gql_gl <- environment(test_gql_gl$initialize)$private



test_that("is query error is FALSE when response is empty (non query error)", {
  expect_false(
    test_gql_gl$is_query_error(list())
  )
})
