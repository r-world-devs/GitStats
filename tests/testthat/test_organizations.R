test_gitstats <- create_gitstats()

test_that("Can not set organizations if no connection is set", {
  expect_error(
    test_gitstats %>%
      set_organizations("r-world_devs"),
    "Set your connections first"
  )
})

test_that("Needs to specify `api_url` when multiple connections", {
  test_gitstats$clients[[1]] <- TestHost$new(
      rest_api_url = "https://api.github.com",
      token = Sys.getenv("GITHUB_PAT"),
      orgs = c("pharmaverse")
    )
  test_gitstats$clients[[2]] <- TestHost$new(
      rest_api_url = "https://gitlab.com/api/v4",
      token = Sys.getenv("GITLAB_PAT_PUBLIC"),
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
  test_gitstats$clients[[1]] <- TestHost$new(
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

  test_gitstats$clients[[1]] <- TestHost$new(
      rest_api_url = "https://api.github.com",
      token = Sys.getenv("GITHUB_PAT"),
      orgs = c("r-world-devs", "insightsengineering")
    )
  test_gitstats$clients[[2]] <- TestHost$new(
      rest_api_url = "https://gitlab.com/api/v4",
      token = Sys.getenv("GITLAB_PAT_PUBLIC"),
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

test_host <- create_testhost(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  mode = "private"
)

test_that("Organizations are correctly checked if they are not present", {

  expect_snapshot(
    error = TRUE,
    test_host$check_for_organizations()
  )

})

test_github <- create_testgh(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  mode = "private"
)

test_gitlab <- create_testgl(
  rest_api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT_PUBLIC"),
  mode = "private"
)

test_that("Organizations are correctly checked if their names are invalid", {

  expect_snapshot(
    test_github$check_organizations(c("openparma", "r-world-devs"))
  )

  expect_snapshot(
    test_gitlab$check_organizations("openparma")
  )

})
