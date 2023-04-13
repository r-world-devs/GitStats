test_host <- create_testhost(rest_api_url = "https://api.github.com",
                             mode = "private")

test_that("when token is proper token is passed", {

  expect_equal(
    test_host$check_token(Sys.getenv("GITHUB_PAT")),
    Sys.getenv("GITHUB_PAT")
  )

})

test_that("When token is empty throw error and do not pass connection", {

  expect_snapshot(
    error = TRUE,
    test_host$check_token('')
  )

})

test_that("Warning shows up, when token is invalid", {

  expect_snapshot(
    error = TRUE,
    test_host$check_token('INVALID_TOKEN')
  )

})
