test_that("`private$rest_response()` returns proper status when token is empty or invalid", {
  testthat::skip_on_ci()

  wrong_tokens <- c("","bad_token")

  purrr::walk(
    wrong_tokens,
    ~expect_message(
       private$rest_response(
         endpoint = "https://api.github.com/org/openpharma",
         token = .
       ),
       "HTTP 401 Unauthorized."
    )
  )

})

test_that("`private$rest_response()` throws error on bad host", {
  bad_host <- "https://github.bad_host.com"

  expect_error(
    private$rest_response(
      endpoint = paste0(bad_host, "/orgs/good_org"),
      token = Sys.getenv("GITHUB_PAT")
    ),
    "Could not resolve host"
  )
})

test_that("`private$rest_response()` returns proper status", {
  bad_endpoint <- "https://api.github.com/orgs/everybody_loves_somebody"

  expect_message(
    private$rest_response(
      endpoint = bad_endpoint,
      token = Sys.getenv("GITHUB_PAT")
    ),
    "HTTP 404 No such address"
  )
})

test_that("`gql_response()` returns list", {
  gql_query <- GraphQL$new()
  query <- gql_query$groups_by_user("maciekbanas")

  expect_type(
    gql_response(api_url = "https://gitlab.com/api/graphql",
                 gql_query = query,
                 token = Sys.getenv("GITLAB_PAT")),
    "list"
  )
})
