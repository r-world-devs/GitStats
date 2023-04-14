test_gql <- EngineGraphQL$new(gql_api_url = "https://api.github.com/graphql",
                              token = Sys.getenv("GITHUB_PAT"))

# private methods

test_gql_priv <- environment(test_gql$initialize)$private

test_that("GraphQL Engine filters repositories' table by team members", {
  repos_table <- test_mock$mocker$repos_table
  expect_snapshot(
    result <- test_gql_priv$filter_repos_by_team(
      repos_table,
      team = list(
        "Member1" = list(
          logins = "kalimu"
        ),
        "Member2" = list(
          logins = "epijim"
        )
      )
    )
  )
  expect_type(
    result,
    "list"
  )
  expect_length(
    result,
    length(repos_table)
  )
  expect_true(
    all(result$contributors %in% c("epijim", "kalimu"))
  )
})
