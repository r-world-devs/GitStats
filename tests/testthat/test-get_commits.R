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

test_that("When storage is set, get commits first saves tables and for the second time it pulls tables from storage and pulls from API only recent commits", {

  test_gitstats <- create_gitstats() %>%
    set_connection(
      api_url = "https://api.github.com",
      token = Sys.getenv("GITHUB_PAT"),
      orgs = c("r-world-devs")
    ) %>%
    set_storage(
      type = "SQLite",
      dbname = "storage/test_db.sqlite"
    )

  DBI::dbRemoveTable(conn = test_gitstats$storage,
                     name = "commits_by_org")

  commits_stored <- gs_mock("get_commits_by_org_save_to_db",
    testthat::capture_messages(test_gitstats %>%
                                 get_commits(date_from = "2022-10-01",
                                             date_until = "2022-12-31",
                                             print_out = FALSE))
  )

  msgs <- c("`commits_by_org` not found in local database.",
            "All commits will be pulled from API.",
            "`commits_by_org` saved to local database.")
  purrr::walk(msgs, ~expect_match(commits_stored, ., all = FALSE))

  commits_stored <- gs_mock("get_commits_by_org_pull_from_and_append_to_db",
                            testthat::capture_messages(test_gitstats %>%
                                                         get_commits(date_from = "2022-10-01",
                                                                     print_out = FALSE))
  )

  msgs <- c("`commits_by_org` is stored in your local database.",
            "Only commits created since ",
            "`commits_by_org` appended to local database.")

  purrr::walk(msgs, ~expect_match(commits_stored, ., all = FALSE))
})
