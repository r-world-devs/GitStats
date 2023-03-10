git_lab <- GitLab$new(
  rest_api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT"),
  orgs = c("mbtests")
)

gitlab_env <- environment(git_lab$initialize)$private

test_that("`pull_team_organizations()` returns character vector of organization names", {
  team = c("adam.forys", "kamil.wais1", "krystianigras", "maciekbanas")
  expect_snapshot(
    orgs_by_team <- gitlab_env$pull_team_organizations(team)
  )
  expect_type(orgs_by_team, "character")
})

test_that("Language handler works properly", {
  expect_equal(gitlab_env$language_handler("r"), "R")
  expect_equal(gitlab_env$language_handler("python"), "Python")
  expect_equal(gitlab_env$language_handler("javascript"), "Javascript")
})

test_that("`get_group_id()` gets group's id", {
  expect_equal(gitlab_env$get_group_id("erasmusmc-public-health"), 2853599)
})
