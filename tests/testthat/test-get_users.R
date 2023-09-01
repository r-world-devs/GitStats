test_that("get_users shows error when no hosts are defined", {
  test_gitstats <- create_gitstats()
  expect_snapshot_error(
    get_users(test_gitstats,
              c("maciekbanas", "kalimu"))
  )
})

test_that("get_users works as expected", {
  test_gitstats <- create_gitstats()
  suppressMessages({
    test_gitstats$set_host(
      api_url = "https://api.github.com",
      token = Sys.getenv("GITHUB_PAT"),
      orgs = c("r-world-devs", "openpharma")
    )

    test_gitstats$set_host(
      api_url = "https://gitlab.com/api/v4",
      token = Sys.getenv("GITLAB_PAT_PUBLIC"),
      orgs = "mbtests"
    )
  })
  get_users(test_gitstats,
            c("maciekbanas", "kalimu"))
  users_table <- test_gitstats$show_users()
  expect_users_table(
    users_table
  )
})
