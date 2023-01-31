test_that("show_storage shows list of tables", {

  test_gitstats <- gs_mock("show_storage",
                           create_gitstats() %>%
                             set_connection(
                               api_url = "https://api.github.com",
                               token = Sys.getenv("GITHUB_PAT"),
                               orgs = "r-world-devs"
                             ) %>%
                             set_storage(type = "SQLite",
                                         dbname = "storage/test_db.sqlite") %>%
                             get_repos() %>%
                             get_commits(date_from = "2022-10-01")
  )
  expect_length(show_storage(test_gitstats), 1)
  expect_equal(nrow(show_storage(test_gitstats)), 2)
})
