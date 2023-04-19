test_rest <- EngineRest$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT")
)

# private methods

test_rest_priv <- environment(test_rest$initialize)$private

test_that("`perform_request()` returns proper status when token is empty or invalid", {
  wrong_tokens <- c("", "bad_token")

  purrr::walk(
    wrong_tokens,
    ~ expect_message(
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

test_that("Private `find_by_id()` returns proper repo list", {
  ids <- c("208896481", "402384343", "483601371")
  names <- c("visR", "DataFakeR", "shinyGizmo")

  result <- test_rest_priv$find_by_id(
    ids = ids,
    objects = "repositories"
  )

  expect_type(result, "list")

  expect_equal(purrr::map_chr(result, ~ .$name), names)
})

# public methods

test_that("`response()` returns search response from GitHub's REST API", {
  search_endpoint <- "https://api.github.com/search/code?q='shiny'+user:r-world-devs"
  test_mock$mock(search_endpoint)
  gh_search_repos_rest_response <- test_rest$response(search_endpoint)

  expect_gh_repos_list(
    gh_search_repos_rest_response$items[[1]]
  )

  test_mock$mock(gh_search_repos_rest_response)
})

test_rest <- EngineRest$new(
  rest_api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT_PUBLIC")
)

test_that("`response()` returns commits response from GitLab's REST API", {

  gl_commits_rest_response_repo_1 <- test_rest$response(
    "https://gitlab.com/api/v4/projects/44293594/repository/commits?since='2023-01-01T00:00:00'&until='2023-04-20T00:00:00'&with_stats=true"
  )
  expect_gl_commit(
    gl_commits_rest_response_repo_1
  )
  test_mock$mock(gl_commits_rest_response_repo_1)

  gl_commits_rest_response_repo_2 <- test_rest$response(
    "https://gitlab.com/api/v4/projects/44346961/repository/commits?since='2023-01-01T00:00:00'&until='2023-04-20T00:00:00'&with_stats=true"
  )
  expect_gl_commit(
    gl_commits_rest_response_repo_2
  )
  test_mock$mock(gl_commits_rest_response_repo_2)

})
