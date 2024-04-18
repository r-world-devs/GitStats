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

test_that("Mapping search result to repositories works", {
  result <- test_rest_priv$map_search_into_repos(
    search_response = test_mocker$use("gh_search_repos_response"),
    verbose = FALSE
  )
  expect_list_contains(
    result[[1]],
    c("id", "node_id", "name", "full_name")
  )
})

test_that("`pull_repos_by_code()` for GitHub prepares a list of repositories", {
  mockery::stub(
    test_rest_priv$pull_repos_by_code,
    "private$search_response",
    test_mocker$use("gh_search_repos_response")
  )
  gh_repos_by_code <- test_rest_priv$pull_repos_by_code(
    code = "shiny",
    org = "openpharma",
    settings = test_settings_silence
  )
  expect_gh_search_response(
    gh_repos_by_code[[1]]
  )
  test_mocker$cache(gh_repos_by_code)
})

test_that("`pull_repos_by_code()` filters responses for specific files in GitHub", {
  settings_with_file <- test_settings_silence
  settings_with_file$files <- "DESCRIPTION"
  gh_repos_by_code <- test_rest_priv$pull_repos_by_code(
    code = "shiny",
    org = "openpharma",
    settings = settings_with_file
  )
  purrr::walk(gh_repos_by_code, function(repo) {
    expect_gh_search_response(repo)
  })
})

test_that("`tailor_repos_info()` tailors precisely `repos_list`", {
  gh_repos_by_code <- test_mocker$use("gh_repos_by_code")

  gh_repos_by_code_tailored <-
    test_rest_priv$tailor_repos_info(gh_repos_by_code)

  gh_repos_by_code_tailored %>%
    expect_type("list") %>%
    expect_length(length(gh_repos_by_code))

  expect_list_contains_only(
    gh_repos_by_code_tailored[[1]],
    c(
      "repo_id", "repo_name", "created_at", "last_activity_at",
      "forks", "stars", "issues_open", "issues_closed",
      "organization"
    )
  )

  expect_lt(
    length(gh_repos_by_code_tailored[[1]]),
    length(gh_repos_by_code[[1]])
  )

  test_mocker$cache(gh_repos_by_code_tailored)
})

test_that("`prepare_repos_table()` prepares repos table", {
  gh_repos_by_code_table <- test_rest_priv$prepare_repos_table(
    repos_list = test_mocker$use("gh_repos_by_code_tailored"),
    settings = test_settings_silence
  )
  expect_repos_table(
    gh_repos_by_code_table
  )
  test_mocker$cache(gh_repos_by_code_table)
})

test_that("`pull_repos_issues()` adds issues to repos table", {
  gh_repos_by_code_table <- test_mocker$use("gh_repos_by_code_table")

  gh_repos_by_code_table <- test_rest_priv$pull_repos_issues(
    gh_repos_by_code_table,
    settings = test_settings_silence
  )
  expect_gt(
    length(gh_repos_by_code_table$issues_open),
    0
  )
  expect_gt(
    length(gh_repos_by_code_table$issues_closed),
    0
  )
  test_mocker$cache(gh_repos_by_code_table)
})

# public methods

test_that("`pull_repos_contributors()` adds contributors to repos table", {
  expect_snapshot(
    gh_repos_by_code_table <- test_rest$pull_repos_contributors(
      test_mocker$use("gh_repos_by_code_table"),
      settings = test_settings
    )
  )
  expect_repos_table(
    gh_repos_by_code_table,
    add_col = "contributors"
  )
  expect_gt(
    length(gh_repos_by_code_table$contributors),
    0
  )
  test_mocker$cache(gh_repos_by_code_table)
})

test_that("`pull_repos()` works", {
  mockery::stub(
    test_rest$pull_repos,
    "private$pull_repos_by_code",
    test_mocker$use("gh_repos_by_code")
  )

  suppressMessages(
    result <- test_rest$pull_repos(
      org = "r-world-devs",
      with_code = "Shiny",
      settings = test_settings
    )
  )

  expect_repos_table(result)
})
