test_rest <- EngineRestGitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT")
)

# private methods

test_rest_priv <- environment(test_rest$initialize)$private

test_that("`search_response()` performs search with limit under 100", {
  total_n <- test_mocker$use("gh_search_response")[["total_count"]]

  mockery::stub(
    test_rest_priv$search_response,
    "private$rest_response",
    test_mocker$use("gh_search_response")
  )
  gh_search_repos_response <- test_rest_priv$search_response(
    search_endpoint = test_mocker$use("search_endpoint"),
    total_n = total_n,
    byte_max = 384000
  )

  expect_gh_search_response(
    gh_search_repos_response[[1]]
  )
  test_mocker$cache(gh_search_repos_response)
})

test_that("Private `find_by_id()` works", {

  result <- test_rest_priv$find_repos_by_id(
    repos_list = test_mocker$use("gh_search_repos_response")
  )
  expect_list_contains(result[[1]],
                       c("id", "node_id", "name", "full_name"))

})

test_that("`search_repos_by_phrase()` for GitHub prepares a list of repositories", {
  mockery::stub(
    test_rest_priv$search_repos_by_phrase,
    "private$search_response",
    test_mocker$use("gh_search_repos_response")
  )
  gh_repos_by_phrase <- test_rest_priv$search_repos_by_phrase(
    phrase = "shiny",
    org = "r-world-devs",
    language = "R"
  )
  expect_gh_search_response(
    gh_repos_by_phrase[[1]]
  )
  test_mocker$cache(gh_repos_by_phrase)
})

test_that("`tailor_repos_info()` tailors precisely `repos_list`", {
  gh_repos_by_phrase <- test_mocker$use("gh_repos_by_phrase")

  gh_repos_by_phrase_tailored <-
    test_rest_priv$tailor_repos_info(gh_repos_by_phrase)

  gh_repos_by_phrase_tailored %>%
    expect_type("list") %>%
    expect_length(length(gh_repos_by_phrase))

  expect_list_contains_only(
    gh_repos_by_phrase_tailored[[1]],
    c("id", "name", "created_at", "last_activity_at", "last_push",
      "forks", "stars", "contributors", "issues_open", "issues_closed",
      "organization"
    ))

  expect_lt(length(gh_repos_by_phrase_tailored[[1]]),
            length(gh_repos_by_phrase[[1]]))

  test_mocker$cache(gh_repos_by_phrase_tailored)
})

test_that("`prepare_repos_table()` prepares repos table", {
  gh_repos_by_phrase_table <- test_rest_priv$prepare_repos_table(
    repos_list = test_mocker$use("gh_repos_by_phrase_tailored")
  )

  expect_repos_table(
    gh_repos_by_phrase_table
  )
  test_mocker$cache(gh_repos_by_phrase_table)
})

# public methods

test_that("`get_repos_contributors()` adds contributors to repos table", {

  gh_repos_by_phrase_table <- test_rest$get_repos_contributors(
    test_mocker$use("gh_repos_by_phrase_table")
  )
  expect_gt(
    length(gh_repos_by_phrase_table$contributors),
    0
  )
  test_mocker$cache(gh_repos_by_phrase_table)
})


test_that("`get_repos_issues()` adds issues to repos table", {

  gh_repos_by_phrase_table <- test_mocker$use("gh_repos_by_phrase_table")

  gh_repos_by_phrase_table <- test_rest$get_repos_issues(
    gh_repos_by_phrase_table
  )
  expect_gt(
    length(gh_repos_by_phrase_table$issues_open),
    0
  )
  expect_gt(
    length(gh_repos_by_phrase_table$issues_closed),
    0
  )
  test_mocker$cache(gh_repos_by_phrase_table)
})

test_that("`get_repos()` works", {

  mockery::stub(
    test_rest$get_repos,
    "private$search_repos_by_phrase",
    test_mocker$use("gh_repos_by_phrase")
  )

  settings <- list(search_param = "phrase",
                   phrase = "shiny")

  expect_snapshot(
    result <- test_rest$get_repos(
      org = "r-world-devs",
      settings = settings
    )
  )

  expect_repos_table(result)

})
