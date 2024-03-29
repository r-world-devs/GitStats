test_rest <- TestEngineRest$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT")
)

# private methods

test_rest_priv <- environment(test_rest$response)$private

test_that("When token is empty throw error", {
  expect_snapshot(
    error = TRUE,
    test_rest_priv$check_token("")
  )
})

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
    suppressMessages(
      test_rest_priv$perform_request(
        endpoint = paste0(bad_host),
        token = Sys.getenv("GITHUB_PAT")
      )
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

test_that("check_endpoint returns repo or org if they are correct", {
  expect_equal(
    test_rest_priv$check_endpoint(
      repo = "r-world-devs/GitStats"
    ),
    "r-world-devs/GitStats"
  )
  expect_equal(
    test_rest_priv$check_endpoint(
      org = "openpharma"
    ),
    "openpharma"
  )
})

test_that("check_endpoint returns warning and NULL if they are not correct", {
  expect_snapshot(
    object <- test_rest_priv$check_endpoint(
      repo = "r-worlddevs/GitStats"
    )
  )
  expect_null(
    object
  )
})

# public methods

test_that("`response()` returns search response from GitHub's REST API", {
  search_endpoint <- "https://api.github.com/search/code?q=shiny+user:openpharma"
  test_mocker$cache(search_endpoint)
  gh_search_response <- test_rest$response(search_endpoint)
  expect_gh_search_response(
    gh_search_response$items[[1]]
  )
  test_mocker$cache(gh_search_response)
})

test_rest <- create_testrest(
  rest_api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT_PUBLIC")
)

test_that("`response()` returns commits response from GitLab's REST API", {
  gl_search_response <- test_rest$response(
    "https://gitlab.com/api/v4/groups/9970/search?scope=blobs&search=git"
  )
  expect_gl_search_response(gl_search_response[[1]])
  test_mocker$cache(gl_search_response)

  gl_commits_rest_response_repo_1 <- test_rest$response(
    "https://gitlab.com/api/v4/projects/44293594/repository/commits?since='2023-01-01T00:00:00'&until='2023-04-20T00:00:00'&with_stats=true"
  )
  expect_gl_commit_rest_response(
    gl_commits_rest_response_repo_1
  )
  test_mocker$cache(gl_commits_rest_response_repo_1)

  gl_commits_rest_response_repo_2 <- test_rest$response(
    "https://gitlab.com/api/v4/projects/44346961/repository/commits?since='2023-01-01T00:00:00'&until='2023-04-20T00:00:00'&with_stats=true"
  )
  expect_gl_commit_rest_response(
    gl_commits_rest_response_repo_2
  )
  test_mocker$cache(gl_commits_rest_response_repo_2)
})

test_that("check_organizations returns orgs if they are correct", {
  expect_equal(
    test_rest$check_organizations("mbtests"),
    "mbtests"
  )
})

test_that("check_organizations returns orgs if GitLab subroups are passed", {
  expect_equal(
    test_rest$check_organizations("mbtests%2fsubgroup"),
    "mbtests%2fsubgroup"
  )
})

test_that("check_organizations returns NULL if orgs are wrong", {
  expect_snapshot(
    org <- test_rest$check_organizations("does_not_exist")
  )
  expect_null(org)
})

test_that("check_repositories returns repos names if they are correct", {
  expect_equal(
    test_rest$check_repositories(
      c("mbtests%2fgitstatstesting", "mbtests%2fsubgroup%2ftest-project-in-subgroup")
    ),
    c("mbtests%2fgitstatstesting", "mbtests%2fsubgroup%2ftest-project-in-subgroup")
  )
})

test_rest <- TestEngineRest$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT")
)

test_that("check_repositories returns repos if they are correct", {
  expect_equal(
    test_rest$check_repositories("r-world-devs/GitStats"),
    "r-world-devs/GitStats"
  )
})
