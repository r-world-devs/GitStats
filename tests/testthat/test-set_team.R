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
      get_repos(by = "team",
                print_out = FALSE)
  )

  # suppressMessages({
  #   expect_invisible(test_gitstats$get_commits(date_from = "2022-06-01", by = "team", print_out = FALSE))
  # })
})
