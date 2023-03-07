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

test_that("`get_repos()` methods pulls repositories from GitHub and translates output into `data.frame`", {
  repos <-
    git_hub_public$get_repos(by = "org")

  expect_repos_table(repos)

  repos_R <- gs_mock(
    "github/github_repos_by_R",
    git_hub_public$get_repos(
      by = "org",
      language = "R"
    )
  )

  expect_repos_table(repos_R)

  repos_Python <- gs_mock(
    "github/github_repos_by_Python",
    git_hub_public$get_repos(
      by = "org",
      language = "Python"
    )
  )

  expect_repos_table(repos_Python)

  repos_JS <- gs_mock(
    "github/github_repos_by_Javascript",
    git_hub_public$get_repos(
      by = "org",
      language = "Javascript"
    )
  )

  expect_empty_table(repos_JS)

  team <- c("galachad", "kalimu", "maciekbanas", "Cotau", "krystian8207", "marcinkowskak")

  repos_by_team <- gs_mock(
    "github/github_repos_by_team",
    git_hub_public$get_repos(
      by = "team",
      team = team
    )
  )

  expect_repos_table(repos_by_team)

  git_hub_public <- GitHub$new(
    rest_api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = c("openpharma", "pharmaverse")
  )

  search_params <- tibble::tibble(
    phrase = c("diabetes", "covid"),
    language = c("R", "R")
  )

  purrr::pwalk(search_params, function(phrase, language) {
    suppressMessages(
      repos_by_key <- gs_mock(
        paste0("github/github_repos_by_phrase_", phrase),
        git_hub_public$get_repos(
          by = "phrase",
          phrase = phrase,
          language = language
        )
      )
    )

    expect_repos_table(repos_by_key)
  })
})
