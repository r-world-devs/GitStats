test_gitstats <- create_gitstats()

test_that("Set connection returns appropriate messages", {
  expect_snapshot(
    set_connection(
      gitstats_obj = test_gitstats,
      api_url = "https://api.github.com",
      token = Sys.getenv("GITHUB_PAT"),
      orgs = c("openpharma", "r-world-devs")
    ) %>%
      set_connection(
        api_url = "https://gitlab.com/api/v4",
        token = Sys.getenv("GITLAB_PAT_PUBLIC"),
        orgs = c("mbtests")
      )
  )
})

test_that("Adequate condition shows if organizations are not specified", {
  test_gitstats$clients <- list()
  expect_snapshot(
    test_gitstats %>%
      set_connection(
        api_url = "https://api.github.com",
        token = Sys.getenv("GITHUB_PAT")
      )
  )
  test_gitstats$clients <- list()
  expect_snapshot(
    test_gitstats %>%
      set_connection(
        api_url = "https://gitlab.com/api/v4",
        token = Sys.getenv("GITLAB_PAT_PUBLIC")
      )
  )
})

test_that("Errors pop out, when wrong input is passed when setting connection", {
  test_gitstats$clients <- list()

  expect_snapshot(
    error = TRUE,
    set_connection(
      gitstats_obj = test_gitstats,
      api_url = "https://avengers.com",
      token = Sys.getenv("GITLAB_PAT_PUBLIC")
    )
  )
})

test_that("Error pops out, when two clients of the same url api are passed as input", {
  test_gitstats$clients <- list()

  expect_snapshot(
    error = TRUE,
    test_gitstats %>%
      set_connection(
        api_url = "https://api.github.com",
        token = Sys.getenv("GITHUB_PAT"),
        orgs = "pharmaverse"
      ) %>%
      set_connection(
        api_url = "https://api.github.com",
        token = Sys.getenv("GITHUB_PAT"),
        orgs = "openpharma"
      )
  )
})

test_that("`Org` name is not passed to the object if it does not exist", {
  expect_snapshot(
    test_gitstats <- create_gitstats() %>%
      set_connection(
        api_url = "https://api.github.com",
        token = Sys.getenv("GITHUB_PAT"),
        orgs = c("openparma")
      )
  )

  expect_null(
    test_gitstats$clients[[1]]$orgs
  )

  expect_snapshot(
    test_gitstats <- create_gitstats() %>%
      set_connection(
        api_url = "https://gitlab.com/api/v4",
        token = Sys.getenv("GITLAB_PAT_PUBLIC"),
        orgs = c("openparma", "mbtests")
      )
  )

  expect_equal(
    test_gitstats$clients[[1]]$orgs,
    "mbtests"
  )
})

test_that("Error with message pops out, when you pass to your `GitLab` connection group name as you see it on the page (not from url)", {
  testthat::skip_on_ci()

  expect_snapshot(
    test_gitstats <- create_gitstats() %>%
      set_connection(
        api_url = "https://gitlab.com/api/v4",
        token = Sys.getenv("GITLAB_PAT_PUBLIC"),
        orgs = "MB Tests"
      )
  )

  expect_null(
    test_gitstats$clients[[1]]$orgs
  )

  expect_snapshot(
    test_gitstats <- create_gitstats() %>%
      set_connection(
        api_url = "https://gitlab.com/api/v4",
        token = Sys.getenv("GITLAB_PAT_PUBLIC"),
        orgs = c("mbtests", "MB Tests")
      )
  )

  expect_equal(
    test_gitstats$clients[[1]]$orgs,
    "mbtests"
  )
})
