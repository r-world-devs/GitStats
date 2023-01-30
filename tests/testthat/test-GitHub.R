git_hub_public <- GitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = c("r-world-devs")
)

git_hub_enterprise <- GitHub$new(
  rest_api_url = "https://github.avengers.com/v5",
  orgs = c("Avengers")
)

publ_env <- environment(git_hub_public$initialize)$private
enterp_env <- environment(git_hub_enterprise$initialize)$private

test_that("set_gql_url correctly sets gql api url - for public and private github", {
  expect_equal(
    publ_env$set_gql_url(),
    "https://api.github.com/graphql"
  )

  expect_equal(
    enterp_env$set_gql_url(),
    "https://github.avengers.com/graphql"
  )
})

test_that("Check correctly if API url is of Enterprise or Public Github", {
  expect_equal(publ_env$check_enterprise(git_hub_public$rest_api_url), FALSE)
  expect_equal(enterp_env$check_enterprise(git_hub_enterprise$rest_api_url), TRUE)
})

test_that("Get_repos methods pulls repositories from GitHub and translates output into data.frame", {
  repos <- git_hub_public$get_repos(by = "org")

  expect_repos_table(repos)

  repos_R <- git_hub_public$get_repos(
    by = "org",
    language = "R"
  )

  expect_repos_table(repos_R)

  repos_Python <- git_hub_public$get_repos(
    by = "org",
    language = "Python"
  )

  expect_empty_table(repos_Python)

  team <- c("galachad", "kalimu", "maciekbanas", "Cotau", "krystian8207", "marcinkowskak")

  repos_by_team <- git_hub_public$get_repos(
    by = "team",
    team = team
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
      repos_by_key <- gs_mock(paste0("github_by_phrase_", phrase),
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
