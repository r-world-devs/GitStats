test_rest <- EngineRest$new(rest_api_url = "https://api.github.com",
                            token = Sys.getenv("GITHUB_PAT"))

# private methods

test_rest_priv <- environment(test_rest$initialize)$private

test_that("`perform_request()` returns proper status when token is empty or invalid", {
  wrong_tokens <- c("","bad_token")

  purrr::walk(
    wrong_tokens,
    ~expect_message(
       test_rest_priv$perform_request(
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
    test_rest_priv$perform_request(
      endpoint = paste0(bad_host, "/orgs/good_org"),
      token = Sys.getenv("GITHUB_PAT")
    ),
    "Could not resolve host"
  )
})

test_that("`perform_request()` returns proper status", {
  bad_endpoint <- "https://api.github.com/orgs/everybody_loves_somebody"

  expect_message(
    test_rest_priv$perform_request(
      endpoint = bad_endpoint,
      token = Sys.getenv("GITHUB_PAT")
    ),
    "HTTP 404 No such address"
  )
})

# public methods

test_that("`response()` returns response from REST API", {
  search_endpoint <- "https://api.github.com/search/code?q='shiny'+user:r-world-devs"
  test_mock$mock(search_endpoint)
  search_repos_rest_response <- test_rest$response(search_endpoint)

  expect_gh_repos_list(
    search_repos_rest_response$items[[1]]
  )

  test_mock$mock(search_repos_rest_response)

})
