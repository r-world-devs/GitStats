test_gql <- EngineGraphQL$new(
  gql_api_url = "https://api.github.com/graphql",
  token = Sys.getenv("GITHUB_PAT")
)

# private methods

test_gql_priv <- environment(test_gql$initialize)$private

test_that("GraphQL Engine filters repositories' table by team members", {
  repos_table <- test_mock$mocker$gh_repos_table
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

test_that("GraphQL Engine filters repositories' table by languages", {
  repos_table <- test_mock$mocker$gh_repos_table
  expect_snapshot(
    result <- test_gql_priv$filter_repos_by_language(
      repos_table,
      language = "JavaScript"
    )
  )
  expect_length(
    result,
    length(repos_table)
  )
  expect_true(
    all(grepl("JavaScript", result$languages))
  )
})

# public methods

test_that("get_repos_by_org gets repositories in the form of table", {
  mockery::stub(
    test_gql$get_repos_by_org,
    "self$get_repos_from_org",
    test_mock$mocker$gh_repos_table
  )
  suppressMessages(
    result <- test_gql$get_repos_by_org(
      org = "r-world-devs",
      by = "orgs",
      team = NULL,
      language = "CSS"
    )
  )
  expect_repos_table(result)
})
