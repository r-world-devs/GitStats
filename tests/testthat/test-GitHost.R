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


