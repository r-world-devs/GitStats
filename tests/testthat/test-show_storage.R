test_that("show_storage shows list of tables", {
  test_gitstats <- gs_mock(
    "show_storage",
    create_gitstats() %>%
      set_connection(
        api_url = "https://api.github.com",
        token = Sys.getenv("GITHUB_PAT"),
        orgs = "r-world-devs"
      ) %>%
      set_storage(
        type = "SQLite",
        dbname = "storage/test_db.sqlite"
      ) %>%
      get_repos() %>%
      get_commits(date_from = "2022-10-01")
  )
  output <- show_storage(test_gitstats)
  expect_length(output, 2)
  expect_equal(nrow(output), 2)
  expect_true(grepl("commits_by_org", output$table[1]))
  expect_true(grepl("repos_by_org", output$table[2]))
})
