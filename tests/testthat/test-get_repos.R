test_gitstats <- create_gitstats() %>%
  set_connection(
    api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = "r-world-devs"
  )

test_that("Get_repos returns repos table", {
  test_gitstats <- gs_mock(
    "get_repos_by_org",
    get_repos(
      gitstats_obj = test_gitstats,
      print_out = FALSE
    )
  )

  expect_repos_table(test_gitstats$repos_dt)
})


test_that("Setting language works correctly", {
  test_gitstats <- gs_mock(
    "get_repos_by_R",
    get_repos(
      gitstats_obj = test_gitstats,
      language = "R",
      print_out = FALSE
    )
  )

  expect_repos_table(test_gitstats$repos_dt)

  expect_message(
    get_repos(
      gitstats_obj = test_gitstats,
      language = "Python",
      print_out = FALSE
    ),
    "Empty object"
  )
})

test_that("Proper information pops out when one wants to get team stats without specifying team", {
  expect_error(
    get_repos(
      gitstats_obj = test_gitstats,
      by = "team"
    ),
    "You have to specify a team first"
  )
})

test_that("Proper information pops out when one wants to get stats by phrase without specifying phrase", {
  expect_error(
    get_repos(
      gitstats_obj = test_gitstats,
      by = "phrase"
    ),
    "You have to provide a phrase to look for"
  )
})

test_that("Get repos by phrase works correctly", {
  test_gitstats <- create_gitstats() %>%
    set_connection(
      api_url = "https://api.github.com",
      token = Sys.getenv("GITHUB_PAT"),
      orgs = "pharmaverse"
    )

  test_gitstats <- gs_mock(
    "get_repos_by_phrase",
    get_repos(
      gitstats_obj = test_gitstats,
      by = "phrase",
      phrase = "covid",
      language = "R",
      print_out = FALSE
    )
  )

  expect_message(
    get_repos(
      gitstats_obj = test_gitstats,
      by = "phrase",
      phrase = "pokemon",
      print_out = FALSE
    ),
    "Empty object"
  )
})

test_that("`get_repos()` by team in case when no `orgs` are specified", {

  suppressWarnings(
    test_gitstats <- create_gitstats() %>%
    set_connection(
      api_url = "https://api.github.com",
      token = Sys.getenv("GITHUB_PAT")
    )
  )

  get_repos_no_org <- expr(
    test_gitstats %>%
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

  wgs_no_orgs <- capture_warnings(
    suppressMessages(test_gitstats <- eval(get_repos_no_org))
  )

  msg_no_orgs <- capture_messages(
    suppressWarnings(eval(get_repos_no_org))
  )

  expect_match(wgs_no_orgs, "No organizations specified for GitHub.")
  expect_match(msg_no_orgs, "Pulling organizations by team.")

  expect_repos_table(test_gitstats$repos_dt)
})
