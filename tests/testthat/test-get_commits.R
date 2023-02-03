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

test_that("When storage is set, `get_commits()` first saves tables and for the second time it pulls tables from storage
          and pulls from API only recent commits, and then appends to the database only these new ones", {

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

  tryCatch({
    DBI::dbRemoveTable(conn = test_gitstats$storage,
                       name = "commits_by_org")
  },
  error = function(e) message("`commits_by_org` not found in db."))

  commits_stored <- testthat::capture_messages(test_gitstats %>%
                                 get_commits(date_from = "2022-10-01",
                                             date_until = "2022-12-31",
                                             print_out = FALSE))

  msgs <- c("`commits_by_org` not found in local database.",
            "All commits will be pulled from API.",
            "`commits_by_org` saved to local database.")
  purrr::walk(msgs, ~expect_match(commits_stored, ., all = FALSE))

  gitstats_priv <- environment(test_gitstats$initialize)$private

  commits_before <- gitstats_priv$pull_storage("commits_by_org")

  commits_stored <- testthat::capture_messages(test_gitstats %>%
                                                 get_commits(date_from = "2022-10-01",
                                                             print_out = FALSE))

  msgs <- c("`commits_by_org` is stored in your local database.",
            "Only commits created since ",
            "`commits_by_org` appended to local database.")

  purrr::walk(msgs, ~expect_match(commits_stored, ., all = FALSE))

  commits_after <- gitstats_priv$pull_storage("commits_by_org")

  diff_rows <- nrow(commits_after) - nrow(commits_before)

  expect_gt(diff_rows, 0)

  # expect no duplicates of commits (the dates from are set correctly)
  expect_equal(length(unique(commits_after$id)), nrow(commits_after))

})
