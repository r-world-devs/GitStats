test_gitstats <- GitStats$new()

test_that("Set connection method", {
  expect_message(
    test_gitstats$set_connection(
      api_url = "https://api.github.com",
      token = Sys.getenv("GITHUB_PAT"),
      orgs = c("avengers", "cocktail_party")
    ),
    "Set connection to GitHub."
  )

  expect_message(
    test_gitstats$set_connection(
      api_url = "https://github.company.com",
      token = Sys.getenv("GITHUB_PAT"),
      orgs = "owner_1"
    ),
    "Set connection to GitHub."
  )

  expect_message(
    test_gitstats$set_connection(
      api_url = "https://code.pharma.com",
      token = Sys.getenv("GITLAB_PAT"),
      orgs = c("good_drugs", "vaccine_science")
    ),
    "Set connection to GitLab."
  )
})

test_that("Errors pop out, when wrong input is passed in set_connection method", {
  test_gitstats$clients <- list()

  expect_error(
    test_gitstats$set_connection(
      api_url = "https://avengers.com",
      token = Sys.getenv("GITLAB_PAT")
    ),
    "You need to specify organisations of the repositories."
  )

  expect_error(
    test_gitstats$set_connection(
      api_url = "https://avengers.com",
      token = Sys.getenv("GITLAB_PAT"),
      orgs = c("good_drugs", "vaccine_science")
    ),
    "This connection is not supported by GitStats class object."
  )
})

test_that("Error pops out, when two clients of the same url api are passed as input", {
  test_gitstats$clients <- list()

  cons <- list(
    api_url = c("https://api.github.com", "https://api.github.com"),
    token = c(Sys.getenv("GITHUB_PAT"), Sys.getenv("GITHUB_PAT")),
    orgs = list(c("justice_league"), c("avengers"))
  )


  expect_error(
    purrr::pwalk(cons, function(api_url, token, orgs) {
      test_gitstats$set_connection(
        api_url = api_url,
        token = token,
        orgs = orgs
      )
    }),
    "You can not provide two clients of the same API urls."
  )
})

test_that("Warning shows up, when token is empty", {
  test_gitstats$clients <- list()

  expect_warning(
    test_gitstats$set_connection(
      api_url = "https://api.github.com",
      token = Sys.getenv("TOKEN_THAT_DOES_NOT_EXIST"),
      orgs = "r-world-devs"
    ),
    "No token provided for `https://api.github.com`. Your access to API will be unauthorized."
  )
})

test_that("Get_repos method returns invisible object", {
  test_gitstats$clients <- list()

  test_gitstats$set_connection(
    api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = "r-world-devs"
  )

  expect_invisible(test_gitstats$get_repos())
})

test_that("Proper information pops out when one wants to get team stats without specifying team", {
  expect_error(
    test_gitstats$get_repos(by = "team"),
    "You have to specify a team first"
  )
})

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

  expect_invisible(test_gitstats$get_repos(by = "team"))
  suppressMessages({
    expect_invisible(test_gitstats$get_commits(date_from = "2022-06-01", by = "team"))
  })
})

test_that("Error shows when no `date_from` input to `get_commits`", {
  expect_error(
    test_gitstats$get_commits(),
    "You need to define"
  )
})
