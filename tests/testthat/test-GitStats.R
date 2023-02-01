test_that("GitStats object is created", {
  test_gitstats <- create_gitstats()
  expect_s3_class(test_gitstats, "GitStats")
})

test_that("check_storage_relevance works as expected", {

  test_gitstats <- create_gitstats() %>%
    set_connection(
      api_url = "https://api.github.com",
      token = Sys.getenv("GITHUB_PAT"),
      orgs = "r-world-devs"
    ) %>%
    set_storage(type = "SQLite",
                dbname = "storage/test_db.sqlite")

  gitstats_priv <- environment(test_gitstats$initialize)$private

  expect_message(
    gitstats_priv$check_storage("repos_by_team"),
    "No tables found in local database. All repos will be pulled from API."
  )

  expect_message(
    gitstats_priv$check_storage("repos_by_org"),
    " is stored in your local database."
  )

})
