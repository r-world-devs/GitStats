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

test_that("`get_repos()` methods pulls repositories from GitLab and translates output into `data.frame`", {
  repos <- gs_mock(
    "gitlab/gitlab_repos_by_org",
    git_lab$get_repos(by = "org")
  )

  expect_repos_table(repos)

  repos_R <- gs_mock(
    "gitlab/gitlab_repos_by_R",
    git_lab$get_repos(
      by = "org",
      language = "R"
    )
  )

  expect_repos_table(repos_R)

  repos_Python <- gs_mock(
    "gitlab/gitlab_repos_Python",
    git_lab$get_repos(
      by = "org",
      language = "Python"
    )
  )

  expect_empty_table(repos_Python)

  team <- c("Rinke Hoekstra")

  repos_by_team <- gs_mock(
    "gitlab/gitlab_repos_by_team",
    git_lab$get_repos(
      by = "team",
      team = team
    )
  )

  expect_repos_table(repos_by_team)

  repos_by_key <- gs_mock(
    "gitlab/gitlab_repos_by_phrase",
    git_lab$get_repos(
      by = "phrase",
      phrase = "clinical",
      language = "R"
    )
  )

  expect_repos_table(repos_by_key)

  repos_pokemon <- gs_mock(
    "gitlab/gitlab_repos_empty",
    git_lab$get_repos(
      by = "phrase",
      phrase = "pokemon"
    )
  )

  expect_empty_table(repos_pokemon)
})

test_that("Language handler works properly", {
  expect_equal(gitlab_env$language_handler("r"), "R")
  expect_equal(gitlab_env$language_handler("python"), "Python")
  expect_equal(gitlab_env$language_handler("javascript"), "Javascript")
})

test_that("`get_group_id()` gets group's id", {
  expect_equal(gitlab_env$get_group_id("erasmusmc-public-health"), 2853599)
})
