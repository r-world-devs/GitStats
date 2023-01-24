git_hub_public <- GitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = c("r-world-devs")
)

git_hub_enterprise <- GitHub$new(
  rest_api_url = "https://github.avengers.com/v5",
  orgs = c("Avengers")
)

priv_publ <- environment(git_hub_public$initialize)$private
priv_enterp <- environment(git_hub_enterprise$initialize)$private

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

test_that("Private get_all_repos_from_owner pulls correctly repositories", {
  orgs <- c("openpharma", "r-world-devs", "pharmaverse")

  purrr::walk(orgs, function(org) {
    repos_n <- perform_get_request(
      endpoint = paste0("https://api.github.com/orgs/", org),
      token = Sys.getenv("GITHUB_PAT")
    )[["public_repos"]]

    expect_equal(
      length(priv_publ$get_all_repos_from_owner(repo_owner = org)),
      repos_n
    )
  })
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
      repos_by_key <- git_hub_public$get_repos(
        by = "phrase",
        phrase = phrase,
        language = language
      )
    )

    expect_repos_table(repos_by_key)
  })
})
