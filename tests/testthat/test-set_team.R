test_that("Setting team works", {
  test_gitstats <-
    create_gitstats() %>%
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
