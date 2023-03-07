git_hub_public <- GitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = c("openpharma", "r-world-devs")
)

publ_env <- environment(git_hub_public$initialize)$private

test_that("`set_gql_url()` correctly sets gql api url - for public and private github", {
  expect_equal(
    publ_env$set_gql_url(),
    "https://api.github.com/graphql"
  )
})

test_that("Check correctly if API url is of Enterprise or Public Github", {
  expect_equal(publ_env$check_enterprise(git_hub_public$rest_api_url), FALSE)
})

test_that("`pull_team_organizations()` returns character vector of organization names", {
  team = c("galachad", "kalimu", "maciekbanas", "Cotau", "krystian8207", "marcinkowskak")
  expect_snapshot(
    orgs_by_team <- publ_env$pull_team_organizations(team)
  )
  expect_type(orgs_by_team, "character")
})
