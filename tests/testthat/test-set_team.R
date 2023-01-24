test_that("Setting team works in pipeline with other functions", {
  expect_invisible(
    test_gitstats <- create_gitstats() %>%
      set_connection(
        api_url = "https://api.github.com",
        token = Sys.getenv("GITHUB_PAT"),
        orgs = c("r-world-devs", "openpharma")
      ) %>%
      set_team(
        team_name = "RWD-IE",
        "galachad",
        "kalimu",
        "maciekbanas",
        "Cotau",
        "krystian8207",
        "marcinkowskak"
      ) %>%
      get_repos(
        by = "team",
        print_out = FALSE
      )
  )

  expect_repos_table(test_gitstats$repos_dt)

  suppressMessages({
    expect_invisible(get_commits(
      gitstats_obj = test_gitstats,
      date_from = "2022-09-01",
      by = "team",
      print_out = FALSE
    ))
  })

  expect_commits_table(test_gitstats$commits_dt)
})
