test_github <- GitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = "pharmaverse"
)

test_github_priv <- environment(test_github$initialize)$private

test_that("`search_by_keyword()` for GitHub prepares a list of repositories", {

  mocked_search_result <- readRDS("test_files/github_repos_searched_by_phrase_medium.rds")

  mockery::stub(
    test_github_priv$search_by_keyword,
    'search_request',
    mocked_search_result
  )

  expect_type(
    test_github_priv$search_by_keyword(
      phrase = "covid",
      org = "pharmaverse",
      language = "R"
    ),
    "list"
  )
})

test_gitlab <- GitLab$new(
  rest_api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT"),
  orgs = c("erasmusmc-public-health")
)

test_gitlab_priv <- environment(test_gitlab$initialize)$private

test_that("`search_by_keyword()` for GitLab prepares a list of repositories", {

  expect_type(
    test_gitlab_priv$search_by_keyword(
      phrase = "covid",
      org = "erasmusmc-public-health"
    ),
    "list"
  )
})
