git_lab_public <- GitLab$new(
  rest_api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT"),
  orgs = c("erasmusmc-public-health")
)

priv_publ <- environment(git_lab_public$initialize)$private

test_that("Private get_all_repos_from_owner pulls correctly repositories", {
  testthat::skip_on_ci()
  orgs <- c("erasmusmc-public-health")

  purrr::walk(orgs, function(group) {
    repos_n <- length(perform_get_request(
      endpoint = paste0("https://gitlab.com/api/v4/groups/", group),
      token = Sys.getenv("GITLAB_PAT")
    )[["projects"]])

    expect_equal(
      length(priv_publ$get_all_repos_from_group(project_group = group)),
      repos_n
    )
  })
})

test_that("Get_repos methods pulls repositories from GitLab and translates output into data.frame", {
  testthat::skip_on_ci()

  repo_cols <- c("organisation", "name", "created_at", "last_activity_at", "description", "api_url")

  repos <- git_lab_public$get_repos(by = "org")

  expect_s3_class(repos, "data.frame")
  expect_named(repos, repo_cols)
  expect_gt(nrow(repos), 0)

  repos_R <- git_lab_public$get_repos(by = "org",
                                      language = "R")

  expect_s3_class(repos_R, "data.frame")
  expect_named(repos_R, repo_cols)
  expect_gt(nrow(repos_R), 0)

  repos_Python <- git_lab_public$get_repos(by = "org",
                                           language = "Python")

  expect_s3_class(repos_Python, "data.frame")
  expect_length(repos_Python, 0)

  team <- c("davidblok", "erasmgz", "PetradeVries")

  repos_by_team <- git_lab_public$get_repos(
    by = "team",
    team = team
  )

  expect_s3_class(repos_by_team, "data.frame")
  expect_named(repos_by_team, repo_cols)
  expect_gt(nrow(repos_by_team), 0)

  repos_by_key <- git_lab_public$get_repos(
    by = "phrase",
    phrase = "clinical",
    language = "R"
  )

  expect_s3_class(repos_by_key, "data.frame")
  expect_named(repos_by_key, repo_cols)
  expect_gt(nrow(repos_by_key), 0)

  repos_pokemon <- git_lab_public$get_repos(
    by = "phrase",
    phrase = "pokemon"
  )

  expect_s3_class(repos_by_key, "data.frame")
  expect_length(repos_pokemon, 0)
})

test_that("Language handler works properly", {
  expect_equal(priv_publ$language_handler("r"), "R")
  expect_equal(priv_publ$language_handler("python"), "Python")
  expect_equal(priv_publ$language_handler("javascript"), "Javascript")
})

test_that("Get_group_id gets group's id", {
  expect_equal(priv_publ$get_group_id("erasmusmc-public-health"), 2853599)
})
