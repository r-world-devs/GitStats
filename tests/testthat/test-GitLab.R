git_lab <- GitLab$new(
  rest_api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT"),
  orgs = c("erasmusmc-public-health")
)

gitlab_env <- environment(git_lab$initialize)$private

test_that("`pull_repos_contributors()` adds contributors' statistics to repositories list", {
  testthat::skip_on_ci()

  repos_list <- readRDS("mocked/gitlab/gitlab_repos_raw.rds")

  repos_list_with_contributors <- gs_mock(
    "gitlab/gitlab_pull_repos_contributors",
    gitlab_env$pull_repos_contributors(repos_list)
  )

  expect_gt(length(repos_list_with_contributors[[1]]), length(repos_list[[1]]))
  expect_list_contains(repos_list_with_contributors, c("contributors"))
  expect_type(repos_list_with_contributors[[1]]$contributors, "character")
})

test_that("`pull_repos_issues()` adds issues statistics to repositories list", {
  testthat::skip_on_ci()

  repos_list <- readRDS("mocked/gitlab/gitlab_repos_raw.rds")

  repos_list_with_issues <- gs_mock(
    "gitlab/gitlab_pull_repos_issues",
    gitlab_env$pull_repos_issues(repos_list)
  )

  expect_gt(length(repos_list_with_issues[[1]]), length(repos_list[[1]]))
  expect_list_contains(repos_list_with_issues, c("issues", "issues_open", "issues_closed"))
  expect_type(repos_list_with_issues[[1]]$issues, "integer")
  expect_type(repos_list_with_issues[[1]]$issues_open, "integer")
  expect_type(repos_list_with_issues[[1]]$issues_closed, "integer")
  purrr::walk(repos_list_with_issues, ~ expect_equal(.$issues, .$issues_open + .$issues_closed))
})

test_that("`pull_repos_from_org()` pulls correctly repositories for GitLab", {
  testthat::skip_on_ci()

  orgs <- git_lab$orgs

  purrr::walk(orgs, function(group) {
    repos_n <- length(get_response(
      endpoint = paste0("https://gitlab.com/api/v4/groups/", group),
      token = Sys.getenv("GITLAB_PAT")
    )[["projects"]])

    pulled_repos_list <- gs_mock(
      paste0("gitlab/gitlab_pull_repos_by_", group),
      gitlab_env$pull_repos_from_org(org = group)
    )

    expect_equal(
      length(pulled_repos_list),
      repos_n
    )
  })
})

test_that("`tailor_repos_info()` tailors precisely `repos_list`", {
  repos_full <- readRDS("mocked/gitlab/gitlab_pull_repos_by_erasmusmc-public-health.rds")

  tailored_repos <- gs_mock(
    "gitlab/gitlab_tailored_repos",
    gitlab_env$tailor_repos_info(repos_full)
  )

  tailored_repos %>%
    expect_type("list") %>%
    expect_length(length(repos_full)) %>%
    expect_list_contains(c(
      "organisation", "name", "created_at", "last_activity_at",
      "forks", "stars", "contributors", "issues", "issues_open", "issues_closed",
      "description"
    ))

  expect_lt(length(tailored_repos[[1]]), length(repos_full[[1]]))
})

test_that("`get_repos()` methods pulls repositories from GitLab and translates output into `data.frame`", {
  testthat::skip_on_ci()

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
