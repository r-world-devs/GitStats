test_that("`perform_request()` returns proper status when token is empty or invalid", {
  wrong_tokens <- c("", "bad_token")
  purrr::walk(
    wrong_tokens,
    ~ expect_message(
      test_rest_github_priv$perform_request(
        endpoint = "https://api.github.com/org/openpharma",
        token = .
      ),
      "HTTP 401 Unauthorized."
    )
  )
})

test_that("`perform_request()` throws error on bad host", {
  bad_host <- "https://github.bad_host.com"
  expect_error(
    suppressMessages(
      test_rest_github_priv$perform_request(
        endpoint = paste0(bad_host),
        token = Sys.getenv("GITHUB_PAT")
      )
    ),
    "Could not resolve host"
  )
})

test_that("`perform_request()` returns proper status", {
  bad_endpoint <- "https://api.github.com/orgs/everybody_loves_somebody"
  expect_error(
    test_rest_github_priv$perform_request(
      endpoint = bad_endpoint,
      token = Sys.getenv("GITHUB_PAT")
    ),
    "HTTP 404 Not Found"
  )
})
