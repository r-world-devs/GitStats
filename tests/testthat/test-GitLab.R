git_lab <- GitLab$new(
  rest_api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT"),
  orgs = c("erasmusmc-public-health")
)

gitlab_env <- environment(git_lab$initialize)$private

test_that("Get_repos methods pulls repositories from GitLab and translates output into data.frame", {
  testthat::skip_on_ci()

  repos <- git_lab$get_repos(by = "org")

  expect_repos_table(repos)

  repos_R <- git_lab$get_repos(
    by = "org",
    language = "R"
  )

  expect_repos_table(repos_R)

  repos_Python <- git_lab$get_repos(
    by = "org",
    language = "Python"
  )

  expect_empty_table(repos_Python)

  team <- c("davidblok", "erasmgz", "PetradeVries")

  repos_by_team <- git_lab$get_repos(
    by = "team",
    team = team
  )

  expect_repos_table(repos_by_team)

  repos_by_key <- git_lab$get_repos(
    by = "phrase",
    phrase = "clinical",
    language = "R"
  )

  expect_repos_table(repos_by_key)

  repos_pokemon <- git_lab$get_repos(
    by = "phrase",
    phrase = "pokemon"
  )

  expect_empty_table(repos_pokemon)
})

test_that("Language handler works properly", {
  expect_equal(gitlab_env$language_handler("r"), "R")
  expect_equal(gitlab_env$language_handler("python"), "Python")
  expect_equal(gitlab_env$language_handler("javascript"), "Javascript")
})

test_that("Get_group_id gets group's id", {
  expect_equal(gitlab_env$get_group_id("erasmusmc-public-health"), 2853599)
})
