git_hub_wrong_owners <- GitHubClient$new(
  owners = c("r-world-devs", "bum-szaka-laka"),
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT")
)

git_hub_no_gql <- GitHubClient$new(
  owners = c("r-world-devs"),
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT")
)

git_hub_priv_no_gql <- GitHubClient$new(
  owners = c("Avengers"),
  rest_api_url = "https://github.avengers.com/v5"
)

test_that("warning pops-up when wrong owners are submitted", {
  expect_warning(git_hub_wrong_owners$get_repos_by_owner())
})

test_that("set_gql_url correctly sets gql api url - for public and private github", {

  priv <- environment(git_hub_no_gql$get_repos_by_owner)$private
  expect_equal(priv$set_gql_url(),
               "https://api.github.com/graphql")

  priv2 <- environment(git_hub_priv_no_gql$get_repos_by_owner)$private
  expect_equal(priv2$set_gql_url(),
               "https://github.avengers.com/graphql")

})
