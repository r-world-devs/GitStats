test_gitstats <- create_gitstats()

test_that("Can not set organizations if no connection is set", {
  expect_error(
    test_gitstats %>%
      set_organizations("r-world_devs"),
    "Set your connections first"
  )
})

test_that("Needs to specify `api_url` when multiple connections", {
  test_gitstats$clients[[1]] <- TestClient$new(
      rest_api_url = "https://api.github.com",
      token = Sys.getenv("GITHUB_PAT"),
      orgs = c("pharmaverse")
    )
  test_gitstats$clients[[2]] <- TestClient$new(
      rest_api_url = "https://gitlab.com/api/v4",
      token = Sys.getenv("GITLAB_PAT"),
      orgs = "mbtests"
    )

  expect_error(
    test_gitstats %>%
      set_organizations("r-world-devs", "openpharma"),
    "You need to specify"
  )
})

test_that("`Set_organizations()` sets properly organizations to client", {
  test_gitstats$clients <- list()
  test_gitstats$clients[[1]] <- TestClient$new(
      rest_api_url = "https://api.github.com",
      token = Sys.getenv("GITHUB_PAT"),
      orgs = c("pharmaverse", "insightsengineering")
    )

  expect_message(
    test_gitstats %>%
      set_organizations("r-world-devs", "openpharma"),
    "New organizations set"
  )

  expect_equal(
    test_gitstats$clients[[1]]$orgs,
    c("r-world-devs", "openpharma")
  )

  test_gitstats$clients <- list()

  test_gitstats$clients[[1]] <- TestClient$new(
      rest_api_url = "https://api.github.com",
      token = Sys.getenv("GITHUB_PAT"),
      orgs = c("r-world-devs", "insightsengineering")
    )
  test_gitstats$clients[[2]] <- TestClient$new(
      rest_api_url = "https://gitlab.com/api/v4",
      token = Sys.getenv("GITLAB_PAT"),
      orgs = "erasmusmc-public-health"
    )

  expect_message(
    test_gitstats %>%
      set_organizations(
        api_url = "https://api.github.com",
        "pharmaverse"
      ),
    "New organizations set"
  )


  expect_equal(
    test_gitstats$clients[[1]]$orgs,
    "pharmaverse"
  )

  expect_equal(
    test_gitstats$clients[[2]]$orgs,
    "erasmusmc-public-health"
  )
})

suppressMessages({
  git_hub <- GitHub$new(
    rest_api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = c("openpharma", "pharmaverse", "insightsengineering")
  )

  github_env <- environment(git_hub$initialize)$private

  git_lab <- GitLab$new(
    rest_api_url = "https://gitlab.com/api/v4",
    token = Sys.getenv("GITLAB_PAT_PUBLIC"),
    orgs = c("mbtests")
  )

  gitlab_env <- environment(git_lab$initialize)$private
})

test_that("Organizations are correctly checked if they do not exist", {

  expect_snapshot(
    github_env$check_orgs(c("openparma", "r-world-devs"))
  )

  expect_snapshot(
    gitlab_env$check_orgs("openparma")
  )

})
