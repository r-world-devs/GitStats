test_that("Set_storage passes information to `storage` field", {
  test_gitstats <- create_gitstats()

  expect_null(test_gitstats$storage)

  set_storage(gitstats_obj = test_gitstats,
              type = "SQLite",
              dbname = "storage/test_db.sqlite")

  expect_length(test_gitstats$storage, 1)
  expect_true(test_gitstats$storage_on)

})

test_that("Saves pulled repos to database", {

  test_gitstats <- gs_mock("get_repos_storage",
                           create_gitstats() %>%
    set_connection(
      api_url = "https://api.github.com",
      token = Sys.getenv("GITHUB_PAT"),
      orgs = "r-world-devs"
    ) %>%
    set_storage(type = "SQLite",
                dbname = "storage/test_db.sqlite") %>%
    get_repos()
  )

  gitstats_priv <- environment(test_gitstats$initialize)$private

  saved_output <- gitstats_priv$read_storage(name = "repos_by_org")

  expect_repos_table(saved_output)

  expect_equal(test_gitstats$repos_dt,
               saved_output)

})

test_that("Saves pulled commits to database", {

  test_gitstats <- gs_mock("get_commits_storage",
                           create_gitstats() %>%
    set_connection(
      api_url = "https://api.github.com",
      token = Sys.getenv("GITHUB_PAT"),
      orgs = "r-world-devs"
    ) %>%
    set_storage(type = "SQLite",
                dbname = "storage/test_db.sqlite") %>%
    get_commits(date_from = "2022-10-01")
  )

  gitstats_priv <- environment(test_gitstats$initialize)$private

  saved_output <- gitstats_priv$read_storage(name = "commits_by_org")

  expect_commits_table(saved_output)

  expect_equal(test_gitstats$commits_dt,
               saved_output)

})
