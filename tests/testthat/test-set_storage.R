test_that("Set_storage passes information to `storage` field", {
  test_gitstats <- create_gitstats()

  expect_null(test_gitstats$storage)

  set_storage(gitstats_obj = test_gitstats,
              type = "SQLite",
              dbname = "storage/test_db.sqlite")

  expect_length(test_gitstats$storage, 1)
  expect_true(test_gitstats$use_storage)
  expect_s4_class(test_gitstats$storage, "SQLiteConnection")

})

test_that("Saves pulled repos to database", {

  if (file.exists("storage/test_db.sqlite")) {
    file.remove("storage/test_db.sqlite")
  }

  test_gitstats <- create_gitstats() %>%
    set_connection(
      api_url = "https://api.github.com",
      token = Sys.getenv("GITHUB_PAT"),
      orgs = "r-world-devs"
    ) %>%
    set_storage(type = "SQLite",
                dbname = "storage/test_db.sqlite") %>%
    get_repos(print_out = FALSE)


  gitstats_priv <- environment(test_gitstats$initialize)$private

  saved_output <- gitstats_priv$pull_storage(name = "repos_by_org")

  expect_repos_table(saved_output)

  expect_equal(test_gitstats$repos_dt,
               saved_output)

})

test_that("Saves pulled commits to database", {

  expect_message(
    test_gitstats <- create_gitstats() %>%
      set_connection(
        api_url = "https://api.github.com",
        token = Sys.getenv("GITHUB_PAT"),
        orgs = "r-world-devs"
      ) %>%
      set_storage(type = "SQLite",
                  dbname = "storage/test_db.sqlite") %>%
      get_commits(date_from = "2022-12-01",
                  date_until = "2022-12-31",
                  print_out = FALSE),
    "`commits_by_org` saved to local database."
  )

  gitstats_priv <- environment(test_gitstats$initialize)$private

  saved_output <- gitstats_priv$pull_storage(name = "commits_by_org")

  expect_commits_table(saved_output)

  expect_equal(test_gitstats$commits_dt,
               saved_output)

})
