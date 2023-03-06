test_gitstats <- create_gitstats()

test_that("`get_repos()` returns repos table", {

  test_gitstats$clients[[1]] <- GitHub$new(
    rest_api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = "r-world-devs"
  )

  mockery::stub(
    get_repos,
    'private$pull_repos_from_org',
    readRDS("test_files/pulled_repos_by_org.rds")
  )

  expect_message(
    get_repos(
      gitstats_obj = test_gitstats,
      print_out = FALSE
    ),
    "Pulling repositories..."
  )

  expect_repos_table(test_gitstats$repos_dt)
})


test_that("Getting repos by language works correctly", {

  mockery::stub(
    get_repos,
    'private$search_by_keyword',
    readRDS("test_files/pulled_repos_by_lang.rds")
  )

  expect_snapshot(
    get_repos(
      gitstats_obj = test_gitstats,
      language = "R",
      print_out = FALSE
    )
  )
  expect_repos_table(test_gitstats$repos_dt)

  expect_snapshot(
    get_repos(
      gitstats_obj = test_gitstats,
      language = "Python",
      print_out = FALSE
    )
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
  expect_snapshot(
    error = TRUE,
    get_repos(
      gitstats_obj = test_gitstats,
      by = "phrase"
    )
  )
})

test_that("`get_repos()` by team in case when no `orgs` are specified", {

  suppressMessages(
    test_gitstats$clients[[1]] <- GitHub$new(
      rest_api_url = "https://api.github.com",
      token = Sys.getenv("GITHUB_PAT")
    )
  )

  expect_snapshot(
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
  expect_repos_table(test_gitstats$repos_dt)
})
