test_that("GitStats object is created", {
  test_gitstats <- create_gitstats()
  expect_s3_class(test_gitstats, "GitStats")
})

test_that("check_storage works as expected", {

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
               print_out = FALSE)

  gitstats_priv <- environment(test_gitstats$initialize)$private

  expect_message(
    gitstats_priv$check_storage("commits_by_team"),
    "`commits_by_team` not found in local database. All commits will be pulled from API."
  )

  expect_message(
    gitstats_priv$check_storage("commits_by_org"),
    "`commits_by_org` is stored in your local database."
  )

  expect_message(
    gitstats_priv$check_storage("commits_by_org"),
    "Only commits created since "
  )

  test_gitstats <- create_gitstats() %>%
    set_connection(
      api_url = "https://github.avengers.com",
      token = Sys.getenv("GITHUB_PAT"),
      orgs = "avengers"
    ) %>%
    set_storage(type = "SQLite",
                dbname = "storage/test_db.sqlite")

  gitstats_priv <- environment(test_gitstats$initialize)$private

  expect_message(
    gitstats_priv$check_storage("commits_by_org"),
    "`commits_by_org` is stored in your local database."
  )

  expect_message(
    gitstats_priv$check_storage("commits_by_org"),
    "No clients found in database table."
  )

  expect_message(
    gitstats_priv$check_storage("commits_by_org"),
    "All commits will be pulled from API."
  )

  test_gitstats <- create_gitstats() %>%
    set_connection(
      api_url = "https://api.github.com",
      token = Sys.getenv("GITHUB_PAT"),
      orgs = "openpharma"
    ) %>%
    set_storage(type = "SQLite",
                dbname = "storage/test_db.sqlite")

  gitstats_priv <- environment(test_gitstats$initialize)$private

  expect_message(
    gitstats_priv$check_storage("commits_by_org"),
    "`commits_by_org` is stored in your local database."
  )

  expect_message(
    gitstats_priv$check_storage("commits_by_org"),
    "No organizations found in database table."
  )

  expect_message(
    gitstats_priv$check_storage("commits_by_org"),
    "All commits will be pulled from API."
  )

})
