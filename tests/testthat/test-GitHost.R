# public methods

test_host <- create_testhost(
  api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = c("openpharma", "r-world-devs")
)

test_that("GitHost gets users tables", {
  users_table <- test_host$get_users(
    users = c("maciekbanas", "kalimu", "galachad")
  )
  expect_users_table(users_table)
})

# private methods

test_host <- create_testhost(
  api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = c("openpharma", "r-world-devs"),
  mode = "private"
)

test_that("`set_gql_url()` correctly sets gql api url - for public and private github", {
  expect_equal(
    test_host$set_gql_url("https://api.github.com"),
    "https://api.github.com/graphql"
  )
})

test_that("GitHost filters repositories' table by languages", {
  repos_table <- test_mocker$use("gh_repos_table")
  expect_snapshot(
    result <- test_host$filter_repos_by_language(
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
