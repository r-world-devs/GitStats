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
  repo_cols <- c("organisation", "name", "created_at", "last_activity_at", "description", "api_url")

  repos <- git_hub_public$get_repos(by = "org")

  expect_s3_class(repos, "data.frame")
  expect_named(repos, repo_cols)
  expect_gt(nrow(repos), 0)

  repos_R <- git_hub_public$get_repos(by = "org",
                                      language = "R")

  expect_s3_class(repos_R, "data.frame")
  expect_named(repos_R, repo_cols)
  expect_gt(nrow(repos_R), 0)

  repos_Python <- git_hub_public$get_repos(by = "org",
                                           language = "Python")

  expect_s3_class(repos_Python, "data.frame")
  expect_length(repos_Python, 0)

  team <- c("galachad", "kalimu", "maciekbanas", "Cotau", "krystian8207", "marcinkowskak")

  repos_by_team <- git_hub_public$get_repos(
    by = "team",
    team = team
  )

  expect_s3_class(repos_by_team, "data.frame")
  expect_named(repos_by_team, repo_cols)
  expect_gt(nrow(repos_by_team), 0)

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

    expect_s3_class(repos_by_key, "data.frame")
    expect_named(repos_by_key, repo_cols)
    expect_gt(nrow(repos_by_key), 0)
  })
})
