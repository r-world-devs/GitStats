test_gql <- EngineGraphQLGitHub$new(
  gql_api_url = "https://api.github.com/graphql",
  token = Sys.getenv("GITHUB_PAT")
)

test_that("get_users build users table for GitHub", {
  users_result <- test_gql$get_users(
    users = c("maciekbanas", "Cotau", "marcinkowskak")
  )
  expect_users_table(
    users_result
  )
})

test_gql_gl <- EngineGraphQLGitLab$new(
  gql_api_url = "https://gitlab.com/api/graphql",
  token = Sys.getenv("GITLAB_PAT_PUBLIC")
)

test_that("get_users build users table for GitLab", {
  users_result <- test_gql$get_users(
    users = c("maciekbanas", "Cotau", "marcinkowskak")
  )
  expect_users_table(
    users_result
  )
})
