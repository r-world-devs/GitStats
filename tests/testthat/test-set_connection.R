test_gitstats <- create_gitstats()

test_that("Set connection returns appropriate messages", {
  msgs <- capture_messages(
    set_connection(
      gitstats_obj = test_gitstats,
      api_url = "https://api.github.com",
      token = Sys.getenv("GITHUB_PAT"),
      orgs = c("openpharma", "r-world-devs")
    ) %>%
    set_connection(
      api_url = "https://gitlab.com/api/v4",
      token = Sys.getenv("GITLAB_PAT"),
      orgs = c("mbtests")
    )
  )

  exp_msgs <- c("v Set connection to GitHub.\n",
                "v Set connection to GitLab.\n")

  expect_true(all(msgs %in% exp_msgs))
})

test_that("Adequate condition shows if organizations are not specified", {
  expect_warning(
    create_gitstats() %>%
      set_connection(
        api_url = "https://api.github.com",
        token = Sys.getenv("GITHUB_PAT")
      ),
    "No organizations specified."
  )

  expect_warning(
    create_gitstats() %>%
      set_connection(
        api_url = "https://gitlab.com/api/v4",
        token = Sys.getenv("GITLAB_PAT")
      ),
    "No organizations specified."
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
    "This connection is not supported by GitStats class object."
  )
})

test_that("Error pops out, when two clients of the same url api are passed as input", {
  test_gitstats <- create_gitstats()

  cons <- list(
    api_url = c("https://api.github.com", "https://api.github.com"),
    token = c(Sys.getenv("GITHUB_PAT"), Sys.getenv("GITHUB_PAT")),
    orgs = list(c("pharmaverse"), c("openpharma"))
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

test_that("When token is empty throw error and do not pass connection", {
  test_gitstats$clients <- list()

  expect_error(
    set_connection(
      gitstats_obj = test_gitstats,
      api_url = "https://api.github.com",
      token = Sys.getenv("TOKEN_THAT_DOES_NOT_EXIST"),
      orgs = "r-world-devs"
    ),
    "No token provided for `https://api.github.com`."
  )

  expect_length(
    test_gitstats$clients,
    0
  )

})

test_that("Warning shows up, when token is invalid", {

  expect_error(
    set_connection(
      gitstats_obj = test_gitstats,
      api_url = "https://api.github.com",
      token = "INVALID_TOKEN",
      orgs = "r-world-devs"
    ),
    "Token provided for `https://api.github.com` is invalid."
  )

  expect_length(
    test_gitstats$clients,
    0
  )

})

test_that("`Org` name is not passed to the object if it does not exist", {

  expect_message(
    test_gitstats <- create_gitstats() %>%
      set_connection(
        api_url = "https://api.github.com",
        token = Sys.getenv("GITHUB_PAT"),
        orgs = c("openparma")
      ),
    "Organization you provided does not exist. Check spelling in: openparma"
  )

  expect_null(
    test_gitstats$clients[[1]]$orgs
  )

  expect_message(
    test_gitstats <- create_gitstats() %>%
      set_connection(
        api_url = "https://gitlab.com/api/v4",
        token = Sys.getenv("GITLAB_PAT"),
        orgs = c("openparma", "mbtests")
      ),
    "Organization you provided does not exist. Check spelling in: openparma"
  )

  expect_equal(
    test_gitstats$clients[[1]]$orgs,
    "mbtests"
  )

})

test_that("Error with message pops out, when you pass to your `GitLab` connection group name as you see it on the page (not from url)", {

  testthat::skip_on_ci()

  expect_message(
    test_gitstats <- create_gitstats() %>%
      set_connection(
        api_url = "https://gitlab.com/api/v4",
        token = Sys.getenv("GITLAB_PAT"),
        orgs = "MB Tests"
      ),
    "Group name passed in a wrong way."
  )

  expect_null(
    test_gitstats$clients[[1]]$orgs
  )

  expect_message(
    test_gitstats <- create_gitstats() %>%
      set_connection(
        api_url = "https://gitlab.com/api/v4",
        token = Sys.getenv("GITLAB_PAT"),
        orgs = c("mbtests", "MB Tests")
      ),
    "Group name passed in a wrong way."
  )

  expect_equal(
    test_gitstats$clients[[1]]$orgs,
    "mbtests"
  )
})
