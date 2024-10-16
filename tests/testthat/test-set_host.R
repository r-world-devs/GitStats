test_gitstats <- create_gitstats()

test_that("Set connection returns appropriate messages", {
  skip_on_cran()
  expect_snapshot(
    set_github_host(
      gitstats_obj = test_gitstats,
      token = Sys.getenv("GITHUB_PAT"),
      orgs = c("openpharma", "r-world-devs")
    )
  )
  expect_snapshot(
    test_gitstats %>% set_gitlab_host(
      token = Sys.getenv("GITLAB_PAT_PUBLIC"),
      orgs = c("mbtests")
    )
  )
})

test_that("When empty token for GitHub, GitStats pulls default token", {
  skip_on_cran()
  expect_snapshot(
    test_gitstats <- create_gitstats() %>%
      set_github_host(
        orgs = c("openpharma", "r-world-devs")
      )
  )
})

test_that("When empty token for GitLab, GitStats pulls default token", {
  skip_on_cran()
  expect_snapshot(
    withr::with_envvar(new = c("GITLAB_PAT" = Sys.getenv("GITLAB_PAT_PUBLIC")), {
      test_gitstats <- create_gitstats() %>%
        set_gitlab_host(
          orgs = "mbtests"
        )
    })
  )
})

test_that("Set GitHub host with particular repos vector instead of orgs", {
  skip_on_cran()
  test_gitstats <- create_gitstats()
  expect_snapshot(
    test_gitstats %>%
      set_github_host(
        token = Sys.getenv("GITHUB_PAT"),
        repos = c("r-world-devs/GitStats", "r-world-devs/shinyCohortBuilder", "openpharma/GithubMetrics", "openpharma/DataFakeR")
      )
  )
  expect_length(
    test_gitstats$.__enclos_env__$private$hosts,
    1
  )
})

test_that("Set GitLab host with particular repos vector instead of orgs", {
  skip_on_cran()
  test_gitstats <- create_gitstats()
  expect_snapshot(
    test_gitstats %>%
      set_gitlab_host(
        token = Sys.getenv("GITLAB_PAT_PUBLIC"),
        repos = c("mbtests/gitstatstesting", "mbtests/gitstats-testing-2")
      )
  )
  expect_length(
    test_gitstats$.__enclos_env__$private$hosts,
    1
  )
})

test_that("Set host prints error when repos and orgs are defined and host is not passed to GitStats", {
  skip_on_cran()
  test_gitstats <- create_gitstats()
  expect_snapshot_error(
    test_gitstats %>%
      set_github_host(
        token = Sys.getenv("GITHUB_PAT"),
        orgs = c('r-world-devs', "openpharma"),
        repos = c("r-world-devs/GitStats", "r-world-devs/shinyCohortBuilder", "openpharma/GithubMetrics", "openpharma/DataFakeR")
      )
  )
  expect_length(
    test_gitstats$.__enclos_env__$private$hosts,
    0
  )
})

test_that("Error shows if organizations are not specified and host is not passed", {
  skip_on_cran()
  test_gitstats <- create_gitstats()
  expect_snapshot_error(
    test_gitstats %>%
      set_github_host(
        token = Sys.getenv("GITHUB_PAT")
      )
  )
  expect_length(
    test_gitstats$.__enclos_env__$private$hosts,
    0
  )
})

test_that("Error shows, when wrong input is passed when setting connection and host is not passed", {
  skip_on_cran()
  test_gitstats <- create_gitstats()
  expect_snapshot_error(
    set_gitlab_host(
      gitstats_object = test_gitstats,
      host = "https://avengers.com",
      token = Sys.getenv("GITLAB_PAT_PUBLIC")
    )
  )
  expect_snapshot({
    create_gitstats() %>%
      set_github_host(
        host = "wrong.url",
        orgs = c("openpharma", "r_world_devs")
      )
    },
    error = TRUE
  )
})

test_that("Error pops out, when two clients of the same url api are passed as input", {
  skip_on_cran()
  test_gitstats <- create_gitstats()
  expect_snapshot(
    error = TRUE,
    test_gitstats %>%
      set_github_host(
        token = Sys.getenv("GITHUB_PAT"),
        orgs = "pharmaverse"
      ) %>%
      set_github_host(
        token = Sys.getenv("GITHUB_PAT"),
        orgs = "openpharma"
      )
  )
})

test_that("Error pops out when `org` does not exist", {
  skip_on_cran()
  expect_snapshot({
    test_gitstats <- create_gitstats() %>%
      set_github_host(
        token = Sys.getenv("GITHUB_PAT"),
        orgs = c("openparma")
      )
    },
    error = TRUE
  )

  expect_snapshot({
    test_gitstats <- create_gitstats() %>%
      set_gitlab_host(
        token = Sys.getenv("GITLAB_PAT_PUBLIC"),
        orgs = c("openparma", "mbtests")
      )
    },
    error = TRUE
  )

  expect_snapshot({
    test_gitstats <- create_gitstats() %>%
      set_github_host(
        token = Sys.getenv("GITHUB_PAT"),
        orgs = c("openpharma", "r_world_devs")
      )
    },
    error = TRUE
  )
})
