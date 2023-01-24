test_that("Set connection returns appropriate messages", {
  test_gitstats <- create_gitstats()

  expect_message(
    set_connection(
      gitstats_obj = test_gitstats,
      api_url = "https://api.github.com",
      token = Sys.getenv("GITHUB_PAT"),
      orgs = c("avengers", "cocktail_party")
    ),
    "Set connection to GitHub."
  )

  expect_message(
    set_connection(
      gitstats_obj = test_gitstats,
      api_url = "https://github.company.com",
      token = Sys.getenv("GITHUB_PAT"),
      orgs = "owner_1"
    ),
    "Set connection to GitHub."
  )

  expect_message(
    set_connection(
      gitstats_obj = test_gitstats,
      api_url = "https://code.pharma.com",
      token = Sys.getenv("GITLAB_PAT"),
      orgs = c("good_drugs", "vaccine_science")
    ),
    "Set connection to GitLab."
  )
})

test_that("Errors pop out, when wrong input is passed when setting connection", {
  test_gitstats$clients <- list()

  expect_error(
    set_connection(
      gitstats_obj = test_gitstats,
      api_url = "https://avengers.com",
      token = Sys.getenv("GITLAB_PAT")
    ),
    "You need to specify organisations of the repositories."
  )

  expect_error(
    set_connection(
      gitstats_obj = test_gitstats,
      api_url = "https://avengers.com",
      token = Sys.getenv("GITLAB_PAT"),
      orgs = c("good_drugs", "vaccine_science")
    ),
    "This connection is not supported by GitStats class object."
  )
})

test_that("Error pops out, when two clients of the same url api are passed as input", {
  test_gitstats <- create_gitstats()

  cons <- list(
    api_url = c("https://api.github.com", "https://api.github.com"),
    token = c(Sys.getenv("GITHUB_PAT"), Sys.getenv("GITHUB_PAT")),
    orgs = list(c("justice_league"), c("avengers"))
  )


  expect_error(
    purrr::pwalk(cons, function(api_url, token, orgs) {
      set_connection(
        gitstats_obj = test_gitstats,
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
    set_connection(
      gitstats_obj = test_gitstats,
      api_url = "https://api.github.com",
      token = Sys.getenv("TOKEN_THAT_DOES_NOT_EXIST"),
      orgs = "r-world-devs"
    ),
    "No token provided for `https://api.github.com`. Your access to API will be unauthorized."
  )
})
