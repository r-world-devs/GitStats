test_gitstats <- create_gitstats()

test_that("Set connection returns appropriate messages", {
  expect_snapshot(
    set_connection(
      gitstats_obj = test_gitstats,
      api_url = "https://api.github.com",
      token = Sys.getenv("GITHUB_PAT"),
      orgs = c("openpharma", "r-world-devs")
    )
  )
  expect_snapshot(
    test_gitstats %>% set_connection(
      api_url = "https://gitlab.com/api/v4",
      token = Sys.getenv("GITLAB_PAT_PUBLIC"),
      orgs = c("mbtests")
    )
  )
})

test_that("When empty token for GitHub, GitStats pulls default token", {
  expect_snapshot(
    test_gitstats <- create_gitstats() %>%
      set_connection(
        api_url = "https://api.github.com",
        orgs = c("openpharma", "r-world-devs")
      )
  )
})

test_that("When empty token for GitLab, GitStats pulls default token", {
  expect_snapshot(
    withr::with_envvar(new = c("GITLAB_PAT" = Sys.getenv("GITLAB_PAT_PUBLIC")), {
      test_gitstats <- create_gitstats() %>%
        set_connection(
          api_url = "https://gitlab.com/api/v4",
          orgs = "mbtests"
        )
    })
  )
})

test_that("Warning shows if organizations are not specified and host is not passed", {
  test_gitstats <- create_gitstats()
  expect_snapshot(
    test_gitstats %>%
      set_connection(
        api_url = "https://api.github.com",
        token = Sys.getenv("GITHUB_PAT")
      )
  )
})

test_that("Warning shows, when wrong input is passed when setting connection and host is not passed", {
  test_gitstats <- create_gitstats()

  expect_snapshot(
    set_connection(
      gitstats_obj = test_gitstats,
      api_url = "https://avengers.com",
      token = Sys.getenv("GITLAB_PAT_PUBLIC")
    )
  )
})

test_that("Error pops out, when two clients of the same url api are passed as input", {
  test_gitstats <- create_gitstats()

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

  expect_snapshot(
    test_gitstats <- create_gitstats() %>%
      set_connection(
        api_url = "https://gitlab.com/api/v4",
        token = Sys.getenv("GITLAB_PAT_PUBLIC"),
        orgs = c("openparma", "mbtests")
      )
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

  expect_snapshot(
    test_gitstats <- create_gitstats() %>%
      set_connection(
        api_url = "https://gitlab.com/api/v4",
        token = Sys.getenv("GITLAB_PAT_PUBLIC"),
        orgs = c("mbtests", "MB Tests")
      )
  )
})
