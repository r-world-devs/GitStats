git_hub_public <- GitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = c("openpharma", "r-world-devs")
)

publ_env <- environment(git_hub_public$initialize)$private

test_that("`set_gql_url()` correctly sets gql api url - for public and private github", {
  expect_equal(
    publ_env$set_gql_url("https://api.github.com"),
    "https://api.github.com/graphql"
  )
})
