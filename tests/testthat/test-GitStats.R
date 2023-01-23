test_gitstats <- create_gitstats()

test_that("Setting team functionality and methods with team work correctly", {
  expect_invisible(
    test_gitstats$set_team(
      team_name = "RWD-IE",
      "galachad",
      "kalimu",
      "maciekbanas",
      "Cotau",
      "krystian8207",
      "marcinkowskak"
    )
  )

  expect_invisible(test_gitstats$get_repos(by = "team", print_out = FALSE))
  suppressMessages({
    expect_invisible(test_gitstats$get_commits(date_from = "2022-06-01", by = "team", print_out = FALSE))
  })
})

test_that("Error shows when no `date_from` input to `get_commits`", {
  expect_error(
    test_gitstats$get_commits(),
    "You need to define"
  )
})
