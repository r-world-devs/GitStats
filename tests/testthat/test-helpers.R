test_that("`perform_request()` returns proper status when token is empty or invalid", {
  testthat::skip_on_ci()

  wrong_tokens <- c("","bad_token")

  purrr::walk(
    wrong_tokens,
    ~expect_message(
       perform_request(
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
    perform_request(
      endpoint = paste0(bad_host, "/orgs/good_org"),
      token = Sys.getenv("GITHUB_PAT")
    ),
    "Could not resolve host"
  )
})

test_that("`perform_request()` returns proper status", {
  bad_endpoint <- "https://api.github.com/orgs/everybody_loves_somebody"

  expect_message(
    perform_request(
      endpoint = bad_endpoint,
      token = Sys.getenv("GITHUB_PAT")
    ),
    "HTTP 404 No such address"
  )
})

test_githost <- GitLab$new(rest_api_url = "https://gitlab.com/api",
                           gql_api_url = "https://gitlab.com/api/graphql",
                           token = Sys.getenv("GITLAB_PAT"))
test_githost_priv <- environment(test_githost$initialize)$private

test_that("`gql_response()` returns list", {
  gql_query <- GraphQLQueryGitLab$new()
  query <- gql_query$groups_by_user("maciekbanas")

  expect_type(
    test_githost_priv$gql_response(
      gql_query = query),
    "list"
  )
})
