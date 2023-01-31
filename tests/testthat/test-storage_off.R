test_that("Switch storage on and off works", {

  expect_message(
    test_gitstats <- create_gitstats() %>%
      set_connection(
        api_url = "https://api.github.com",
        token = Sys.getenv("GITHUB_PAT"),
        orgs = "r-world-devs"
      ) %>%
      set_storage(type = "SQLite",
                  dbname = "storage/test_db.sqlite") %>%
      storage_off(),
    "Storage will not be used.")

  expect_false(test_gitstats$use_storage)

  test_gitstats %>%
    storage_on()

  expect_true(test_gitstats$use_storage)

})
