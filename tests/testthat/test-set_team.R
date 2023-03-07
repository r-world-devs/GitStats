test_that("Setting team works", {
  test_gitstats <-
    create_gitstats() %>%
      set_connection(
        api_url = "https://api.github.com",
        token = Sys.getenv("GITHUB_PAT"),
        orgs = c("r-world-devs")
      ) %>%
      set_team(
        team_name = "RWD-IE",
        "galachad",
        "kalimu",
        "maciekbanas",
        "Cotau",
        "krystian8207",
        "marcinkowskak"
      )
  expect_type(
    test_gitstats$team,
    "list"
  )
  expect_type(
    test_gitstats$team[[1]],
    "character"
  )
})
