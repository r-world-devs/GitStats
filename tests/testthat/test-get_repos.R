test_gitstats <- create_gitstats() %>%
  set_connection(
    api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = "r-world-devs"
  )

test_that("Get_repos returns repos table", {
  expect_invisible(get_repos(
    gitstats_obj = test_gitstats,
    print_out = FALSE
  ))

  expect_repos_table(test_gitstats$repos_dt)
})


test_that("Setting language works correctly", {
  expect_invisible(get_repos(
    gitstats_obj = test_gitstats,
    language = "R",
    print_out = FALSE
  ))

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

  expect_invisible(
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
