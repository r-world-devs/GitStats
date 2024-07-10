test_rest <- EngineRestGitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT")
)

# private methods

test_rest_priv <- environment(test_rest$initialize)$private

test_that("`search_response()` performs search with limit under 100", {
  total_n <- test_mocker$use("gh_search_response_raw")[["total_count"]]
  mockery::stub(
    test_rest_priv$search_response,
    "private$rest_response",
    test_mocker$use("gh_search_response_raw")
  )
  gh_search_repos_response <- test_rest_priv$search_response(
    search_endpoint = test_mocker$use("search_endpoint"),
    total_n = total_n,
    byte_max = 384000
  )
  expect_gh_search_response(gh_search_repos_response)
  test_mocker$cache(gh_search_repos_response)
})

test_that("Mapping search result to repositories works", {
  suppressMessages(
    result <- test_rest_priv$map_search_into_repos(
      search_response = test_mocker$use("gh_search_repos_response")
    )
  )
  expect_gh_repos_rest_response(result)
})

# public methods

test_that("`pull_repos_by_code()` returns repos output for code search in files", {
  mockery::stub(
    test_rest$pull_repos_by_code,
    "private$search_response",
    test_mocker$use("gh_search_response_in_file")
  )
  gh_repos_by_code <- test_rest$pull_repos_by_code(
    code = "shiny",
    filename = "DESCRIPTION",
    org = "openpharma",
    verbose = FALSE
  )
  expect_gh_repos_rest_response(gh_repos_by_code)
  test_mocker$cache(gh_repos_by_code)
})

test_that("`pull_repos_by_code()` for GitHub prepares a raw (raw_output = TRUE) search response", {
  mockery::stub(
    test_rest$pull_repos_by_code,
    "private$search_response",
    test_mocker$use("gh_search_repos_response")
  )
  gh_repos_by_code_raw <- test_rest$pull_repos_by_code(
    code = "shiny",
    org = "openpharma",
    raw_output = TRUE,
    verbose = FALSE
  )
  expect_gh_search_response(gh_repos_by_code_raw)
  test_mocker$cache(gh_repos_by_code_raw)
})
