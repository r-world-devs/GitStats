test_that("Error shows when no `date_from` input to `get_commits`", {
  expect_error(
    test_gitstats <- create_gitstats() %>%
      set_connection(
        api_url = "https://api.github.com",
        token = Sys.getenv("GITHUB_PAT"),
        orgs = c("r-world-devs", "openpharma")
      ) %>%
      get_commits(),
    "You need to define"
  )
})

test_that("Get commits prepares table of commits", {
  test_gitstats <- gs_mock("get_commits_by_org",
                           create_gitstats() %>%
                             set_connection(
                               api_url = "https://api.github.com",
                               token = Sys.getenv("GITHUB_PAT"),
                               orgs = c("r-world-devs", "openpharma")
                             ) %>%
                             get_commits(
                               date_from = "2022-09-01",
                               print_out = FALSE
                             )
  )

  suppressMessages({
    expect_commits_table(test_gitstats$commits_dt)
  })
})
