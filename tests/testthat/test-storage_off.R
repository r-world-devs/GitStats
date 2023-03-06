test_that("Switch storage on and off works", {

  test_gitstats <- create_gitstats()
  test_gitstats$clients[[1]] <- GitHub$new(
    rest_api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = "r-world-devs"
  )

  expect_snapshot(
      test_gitstats %>%
        set_storage(
          type = "SQLite",
          dbname = "storage/test_db.sqlite"
        ) %>%
        storage_off()
  )

  expect_false(test_gitstats$use_storage)

  test_gitstats %>%
    storage_on()

  expect_true(test_gitstats$use_storage)
})
