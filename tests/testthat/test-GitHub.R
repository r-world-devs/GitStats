git_hub_public <- GitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = c("openpharma", "r-world-devs")
)

git_hub_enterprise <- GitHub$new(
  rest_api_url = "https://github.avengers.com/v5",
  orgs = c("Avengers")
)

publ_env <- environment(git_hub_public$initialize)$private
enterp_env <- environment(git_hub_enterprise$initialize)$private

test_that("`set_gql_url()` correctly sets gql api url - for public and private github", {
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

test_that("`pull_repos_contributors()` adds contributors' statistics to repositories list", {

  repos_list <- readRDS("mocked/github/github_repos_raw.rds")

  repos_list_with_contributors <- gs_mock("github/github_pull_repos_contributors",
                                          publ_env$pull_repos_contributors(repos_list)
  )

  expect_gt(length(repos_list_with_contributors[[1]]), length(repos_list[[1]]))
  expect_list_contains(repos_list_with_contributors, c("contributors"))
  expect_type(repos_list_with_contributors[[1]]$contributors, "character")

})

test_that("`pull_repos_issues()` adds issues statistics to repositories list", {

  repos_list <- readRDS("mocked/github/github_repos_raw.rds")

  repos_list_with_issues <- gs_mock("github/github_pull_repos_issues",
                                    publ_env$pull_repos_issues(repos_list)
  )

  expect_gt(length(repos_list_with_issues[[1]]), length(repos_list[[1]]))
  expect_list_contains(repos_list_with_issues, c("issues", "issues_open", "issues_closed"))
  expect_type(repos_list_with_issues[[1]]$issues, "integer")
  expect_type(repos_list_with_issues[[1]]$issues_open, "integer")
  expect_type(repos_list_with_issues[[1]]$issues_closed, "integer")
  purrr::walk(repos_list_with_issues, ~expect_equal(.$issues, .$issues_open + .$issues_closed))

})

test_that("`pull_repos_from_org()` pulls correctly repositories for GitHub", {

  orgs <- git_hub_public$orgs

  purrr::walk(orgs, function(org) {
    repos_n <- get_response(
      endpoint = paste0("https://api.github.com/orgs/", org),
      token = Sys.getenv("GITHUB_PAT")
    )[["public_repos"]]

    pulled_repos_list <- gs_mock(paste0("github/github_pull_repos_by_", org),
                                 publ_env$pull_repos_from_org(org = org)
    )

    expect_equal(
      length(pulled_repos_list),
      repos_n
    )
  })
})

test_that("`tailor_repos_info()` tailors precisely `repos_list`", {

  repos_full <- readRDS("mocked/github/github_pull_repos_by_openpharma.rds")

  tailored_repos <- gs_mock("github/github_tailored_repos",
                            publ_env$tailor_repos_info(repos_full)
  )

  tailored_repos %>%
    expect_type("list") %>%
    expect_length(length(repos_full)) %>%
    expect_list_contains(c("organisation", "name", "created_at", "last_activity_at",
                         "forks", "stars", "contributors", "issues", "issues_open", "issues_closed",
                         "description"))

  expect_lt(length(tailored_repos[[1]]), length(repos_full[[1]]))

})

test_that("`get_repos()` methods pulls repositories from GitHub and translates output into `data.frame`", {
  repos <- gs_mock("github/github_repos_by_og",
    git_hub_public$get_repos(by = "org")
  )

  expect_repos_table(repos)

  repos_R <- gs_mock("github/github_repos_by_R",
    git_hub_public$get_repos(
      by = "org",
      language = "R"
    )
  )

  expect_repos_table(repos_R)

  repos_Python <- gs_mock("github/github_repos_by_Python",
    git_hub_public$get_repos(
      by = "org",
      language = "Python"
    )
  )

  expect_repos_table(repos_Python)

  repos_JS <- gs_mock("github/github_repos_by_Javascript",
    git_hub_public$get_repos(
      by = "org",
      language = "Javascript"
    )
  )

  expect_empty_table(repos_JS)

  team <- c("galachad", "kalimu", "maciekbanas", "Cotau", "krystian8207", "marcinkowskak")

  repos_by_team <- gs_mock("github/github_repos_by_team",
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
      repos_by_key <- gs_mock(paste0("github/github_repos_by_phrase_", phrase),
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
