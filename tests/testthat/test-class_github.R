git_hub_public <- GitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = c("r-world-devs")
)

git_hub_enterprise <- GitHub$new(
  rest_api_url = "https://github.avengers.com/v5",
  orgs = c("Avengers")
)

priv_publ <- environment(git_hub_public$get_repos_by_org)$private
priv_enterp <- environment(git_hub_enterprise$get_repos_by_org)$private

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
  expect_equal(priv_publ$check_enterprise(git_hub_public$rest_api_url), FALSE)
  expect_equal(priv_enterp$check_enterprise(git_hub_enterprise$rest_api_url), TRUE)
})
