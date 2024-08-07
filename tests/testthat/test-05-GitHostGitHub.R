# public methods

test_host <- create_github_testhost(
  orgs = c("openpharma", "r-world-devs")
)

test_that("GitHost gets users tables", {
  users_table <- test_host$get_users(
    users = c("maciekbanas", "kalimu", "galachad")
  )
  expect_users_table(users_table)
  test_mocker$cache(users_table)
})

# private methods

test_host <- create_github_testhost(
  orgs = c("openpharma", "r-world-devs"),
  mode = "private"
)

test_that("When token is empty throw error", {
  expect_snapshot(
    error = TRUE,
    test_host$check_token("")
  )
})

test_that("`check_token()` prints error when token exists but does not grant access", {
  token <- "does_not_grant_access"
  expect_snapshot_error(
    test_host$check_token(token)
  )
})

test_that("when token is proper token is passed", {
  expect_equal(
    test_host$check_token(Sys.getenv("GITHUB_PAT")),
    Sys.getenv("GITHUB_PAT")
  )
})

test_that("check_endpoint returns TRUE if they are correct", {
  expect_true(
    test_host$check_endpoint(
      endpoint = "https://api.github.com/repos/r-world-devs/GitStats",
      type = "Repository"
    )
  )
  expect_true(
    test_host$check_endpoint(
      endpoint = "https://api.github.com/orgs/openpharma",
    )
  )
})

test_that("check_endpoint returns error if they are not correct", {
  expect_snapshot_error(
    check <- test_host$check_endpoint(
      endpoint = "https://api.github.com/repos/r-worlddevs/GitStats",
      type = "Repository"
    )
  )
})

test_that("`check_if_public` works correctly", {
  expect_true(
    test_host$check_if_public("api.github.com")
  )
  expect_false(
    test_host$check_if_public("github.internal.com")
  )
})

test_that("`set_default_token` sets default token for public GitHub", {
  expect_snapshot(
    default_token <- test_host$set_default_token()
  )
  test_rest <- create_testrest(token = default_token,
                               mode = "private")
  expect_equal(
    test_rest$perform_request(
      endpoint = "https://api.github.com",
      token = default_token
    )$status,
    200
  )
})

test_that("`test_token` works properly", {
  expect_true(
    test_host$test_token(Sys.getenv("GITHUB_PAT"))
  )
  expect_false(
    test_host$test_token("false_token")
  )
})

test_that("`extract_repos_and_orgs` extracts fullnames vector into a list of GitHub organizations with assigned repositories", {
  repos_fullnames <- c(
    "r-world-devs/GitStats", "r-world-devs/shinyCohortBuilder",
    "openpharma/DataFakeR", "openpharma/GithubMetrics"
  )
  expect_equal(
    test_host$extract_repos_and_orgs(repos_fullnames),
    list(
      "r-world-devs" = c("GitStats", "shinyCohortBuilder"),
      "openpharma" = c("DataFakeR", "GithubMetrics")
    )
  )
})

test_that("GitHub prepares repos table from repositories response", {
  gh_repos_table <- test_host$prepare_repos_table_from_graphql(
    repos_list = test_mocker$use("gh_repos_from_org")
  )
  expect_repos_table(
    gh_repos_table
  )
  test_mocker$cache(gh_repos_table)
})

test_that("GitHost adds `repo_api_url` column to GitHub repos table", {
  repos_table <- test_mocker$use("gh_repos_table")
  gh_repos_table_with_api_url <- test_host$add_repo_api_url(repos_table)
  expect_true(all(grepl("api.github.com", gh_repos_table_with_api_url$api_url)))
  test_mocker$cache(gh_repos_table_with_api_url)
})

test_that("`get_all_repos()` works as expected", {
  mockery::stub(
    test_host$get_all_repos,
    "private$prepare_repos_table_from_graphql",
    test_mocker$use("gh_repos_table_with_api_url")
  )
  expect_snapshot(
    gh_repos_table <- test_host$get_all_repos()
  )
  expect_repos_table(
    gh_repos_table,
    with_cols = "api_url"
  )
  test_mocker$cache(gh_repos_table)
})

test_that("get_repo_url_from_response retrieves repositories URLS", {
  gh_repo_api_urls <- test_host$get_repo_url_from_response(
    search_response = test_mocker$use("gh_search_repos_response"),
    type = "api"
  )
  expect_type(gh_repo_api_urls, "character")
  expect_gt(length(gh_repo_api_urls), 0)
  test_mocker$cache(gh_repo_api_urls)
  gh_repo_web_urls <- test_host$get_repo_url_from_response(
    search_response = test_mocker$use("gh_search_response_in_file"),
    type = "web"
  )
  expect_type(gh_repo_web_urls, "character")
  expect_gt(length(gh_repo_web_urls), 0)
  test_mocker$cache(gh_repo_web_urls)
})

test_that("get_commits_from_host for GitHub works", {
  test_host <- create_github_testhost(
    repos = c("openpharma/DataFakeR", "r-world-devs/GitStats", "r-world-devs/cohortBuilder"),
    mode = "private"
  )
  mockery::stub(
    test_host$get_commits_from_host,
    "private$prepare_commits_table",
    test_mocker$use("gh_commits_table")
  )
  suppressMessages(
    gh_commits_table <- test_host$get_commits_from_host(
      since = "2023-03-01",
      until = "2023-04-01",
      settings = test_settings_repo
    )
  )
  expect_commits_table(
    gh_commits_table
  )
  test_mocker$cache(gh_commits_table)
})

test_that("get_files_from_orgs for GitHub works", {
  mockery::stub(
    test_host$get_files_from_orgs,
    "private$prepare_files_table",
    test_mocker$use("gh_files_table")
  )
  gh_files_table <- test_host$get_files_from_orgs(
    file_path = "DESCRIPTION",
    verbose = FALSE
  )
  expect_files_table(
    gh_files_table,
    with_cols = "api_url"
  )
  test_mocker$cache(gh_files_table)
})

# public methods

test_host <- create_github_testhost(
  orgs = c("openpharma", "r-world-devs")
)

test_that("get_commits for GitHub works", {
  test_host <- create_github_testhost(
    repos = c("openpharma/DataFakeR", "r-world-devs/GitStats", "r-world-devs/cohortBuilder")
  )
  mockery::stub(
    test_host$get_commits,
    "private$get_commits_from_host",
    test_mocker$use("gh_commits_table")
  )
  suppressMessages(
    gh_commits_table <- test_host$get_commits(
      since = "2023-03-01",
      until = "2023-04-01",
      settings = test_settings_repo
    )
  )
  expect_commits_table(
    gh_commits_table
  )
})

test_that("get_files for GitHub works", {
  mockery::stub(
    test_host$get_files,
    "private$get_files_from_orgs",
    test_mocker$use("gh_files_table")
  )
  suppressMessages(
    gh_files_table <- test_host$get_files(
      file_path = "DESCRIPTION"
    )
  )
  expect_files_table(
    gh_files_table,
    with_cols = "api_url"
  )
})

test_that("get_repos_urls returns repositories URLS", {
  mockery::stub(
    test_host$get_repos_urls,
    "private$get_repo_url_from_response",
    test_mocker$use("gh_repo_web_urls")
  )
  gh_repos_urls_with_code_in_files <- test_host$get_repos_urls(
    type = "web",
    with_code = "shiny",
    in_files = "DESCRIPTION",
    verbose = FALSE
  )
  expect_type(gh_repos_urls_with_code_in_files, "character")
  expect_gt(length(gh_repos_urls_with_code_in_files), 0)
  test_mocker$cache(gh_repos_urls_with_code_in_files)
})
