test_that("`perform_request()` returns proper status when token is empty or invalid", {
  testthat::skip_on_cran()
  wrong_tokens <- c("", "bad_token")
  purrr::walk(
    wrong_tokens,
    ~ expect_message(
      test_rest_github$perform_request(
        endpoint = "https://api.github.com",
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
      test_rest_github$perform_request(
        endpoint = paste0(bad_host),
        token = Sys.getenv("GITHUB_PAT")
      )
    ),
    "Could not resolve host"
  )
})

test_that("403 error is handled", {
  testthat::skip_on_cran()
  mockery::stub(
    test_rest_github$perform_request,
    "httr2::req_perform",
    httr2::response(status_code = 403)
  )
  expect_no_error(
    response <- test_rest_github$perform_request(
      endpoint =  "https://example.com",
      token = Sys.getenv("GITHUB_PAT")
    )
  )
})

test_that("`perform_request()` returns proper status", {
  skip_if(Sys.getenv("GITHUB_PAT") == "")
  bad_endpoint <- "https://api.github.com/orgs/everybody_loves_somebody"
  expect_message(
    test_rest_github$perform_request(
      endpoint = bad_endpoint,
      token = Sys.getenv("GITHUB_PAT")
    ),
    "HTTP 404 Not Found"
  )
})

test_that("`paginate_results()` works properly", {
  if (!integration_tests_skipped) {
    expect_no_error(
      test_rest_github_priv$paginate_results(
        endpoint = "https://api.github.com/orgs/pharmaverse/repos"
      )
    )
  }
})

test_that("`perform_request()` returns status 200", {
  skip_if(Sys.getenv("GITHUB_PAT") == "")
  response <- test_rest_github$perform_request(
    endpoint = "https://api.github.com/repos/r-world-devs/GitStats",
    token = Sys.getenv("GITHUB_PAT")
  )
  expect_equal(
    response$status_code,
    200
  )
})

test_that("`perform_request()` for GraphQL returns status 200", {
  skip_if(Sys.getenv("GITHUB_PAT") == "")
  response <- test_graphql_github_priv$perform_request(
    gql_query = "{
      viewer {
        login
      }
    }",
    vars = NULL,
    token = Sys.getenv("GITHUB_PAT")
  )
  expect_equal(
    response$status_code,
    200
  )
})

test_that("`perform_request()` for GraphQL handles error 400", {
  skip_if(Sys.getenv("GITHUB_PAT") == "")
  testthat::skip_on_cran()
  mockery::stub(
    test_graphql_github_priv$perform_request,
    "httr2::req_perform",
    httr2::response(status_code = 400)
  )
  response <- test_graphql_github_priv$perform_request(
    gql_query = "{
      viewer {
        login
      }
    }",
    vars = NULL,
    token = Sys.getenv("GITHUB_PAT")
  )
  expect_equal(
    response$status_code,
    400
  )
})

test_that("`perform_request()` for GraphQL handles error 503", {
  skip_if(Sys.getenv("GITHUB_PAT") == "")
  mockery::stub(
    test_graphql_github_priv$perform_request,
    "httr2::req_perform",
    httr2::response(status_code = 503)
  )
  expect_snapshot(
    response <- test_graphql_github_priv$perform_request(
      gql_query = "{
      viewer {
        login
      }
    }",
      vars = NULL,
      token = Sys.getenv("GITHUB_PAT")
    )
  )
})
