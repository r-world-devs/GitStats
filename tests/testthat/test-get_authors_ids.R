git_hub_public <- GitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = c("openpharma", "r-world-devs")
)

publ_env <- environment(git_hub_public$initialize)$private

test_that("`get_authors_ids()` works as expected", {
  team <- list(
    "Member1" = list(
      logins = "galachad"
    ),
    "Member2" = list(
      logins = "Cotau"
    ),
    "Member3" = list(
      logins = "maciekbanas"
    )
  )
  expect_snapshot(
    publ_env$get_authors_ids(team)
  )
})
