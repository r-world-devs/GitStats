git_hub_public <- GitHub$new(
  owners = c("r-world-devs"),
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT")
)

git_hub_enterprise <- GitHub$new(
  owners = c("Avengers"),
  rest_api_url = "https://github.avengers.com/v5"
)

priv_publ <- environment(git_hub_public$get_repos_by_owner)$private
priv_enterp <- environment(git_hub_enterprise$get_repos_by_owner)$private

test_that("set_gql_url correctly sets gql api url - for public and private github", {
  expect_equal(
    priv_publ$set_gql_url(),
    "https://api.github.com/graphql"
  )

  expect_equal(
    priv_enterp$set_gql_url(),
    "https://github.avengers.com/graphql"
  )
})

test_that("Check correctly if API url is of Enterprise or Public Github", {
  expect_equal(priv_publ$check_enterprise_github(git_hub_public$rest_api_url), FALSE)
  expect_equal(priv_enterp$check_enterprise_github(git_hub_enterprise$rest_api_url), TRUE)
})
