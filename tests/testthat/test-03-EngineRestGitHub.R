test_rest <- EngineRestGitHub$new(rest_api_url = "https://api.github.com",
                                  token = Sys.getenv("GITHUB_PAT"))

# private methods

test_rest_priv <- environment(test_rest$initialize)$private

test_that("`search_response()` performs search with limit under 100", {

  total_n <- test_mock$mocker$search_repos_rest_response[["total_count"]]

  mockery::stub(
    test_rest_priv$search_response,
    'private$rest_response',
    test_mock$mocker$search_repos_rest_response
  )
  search_repos_response <- test_rest_priv$search_response(
    search_endpoint = test_mock$mocker$search_endpoint,
    total_n = total_n,
    byte_max = 384000
  )

  expect_gh_repos_list(
    search_repos_response[[1]]
  )
  test_mock$mock(search_repos_response)
})

test_that("`search_repos_by_phrase()` for GitHub prepares a list of repositories", {

  mockery::stub(
    test_rest_priv$search_repos_by_phrase,
    'private$search_response',
    test_mock$mocker$search_repos_response
  )
  expect_snapshot(
    repos_by_phrase <- test_rest_priv$search_repos_by_phrase(
      phrase = "shiny",
      org = "r-world-devs",
      language = "R"
    )
  )
  expect_gh_repos_list(
    repos_by_phrase[[1]]
  )
})
