test_that("repos_by_org query is built properly", {
  gh_repos_by_org_query <-
    test_gqlquery_gh$repos_by_org()
  expect_snapshot(
    gh_repos_by_org_query
  )
  test_mocker$cache(gh_repos_by_org_query)
})

test_that("GitHub repos response to query works", {
  gh_repos_by_org_gql_response <- test_graphql_github$gql_response(
    test_mocker$use("gh_repos_by_org_query"),
    vars = list(org = "r-world-devs")
  )
  expect_gh_repos_gql_response(
    gh_repos_by_org_gql_response
  )
  test_mocker$cache(gh_repos_by_org_gql_response)
})

test_that("`get_repos_page()` pulls repos page from GitHub organization", {
  mockery::stub(
    test_graphql_github_priv$get_repos_page,
    "self$gql_response",
    test_mocker$use("gh_repos_by_org_gql_response")
  )
  gh_repos_page <- test_graphql_github_priv$get_repos_page(
    org = "r-world-devs"
  )
  expect_gh_repos_gql_response(
    gh_repos_page
  )
  test_mocker$cache(gh_repos_page)
})

test_that("`get_repos_from_org()` prepares formatted list", {
  mockery::stub(
    test_graphql_github$get_repos_from_org,
    "private$get_repos_page",
    test_mocker$use("gh_repos_page")
  )
  gh_repos_from_org <- test_graphql_github$get_repos_from_org(
    org = "r-world-devs"
  )
  expect_list_contains(
    gh_repos_from_org[[1]],
    c(
      "id", "name", "stars", "forks", "created_at",
      "last_activity_at", "languages", "issues_open", "issues_closed",
      "contributors", "repo_url"
    )
  )
  test_mocker$cache(gh_repos_from_org)
})

# REST Engine search repos by code

test_that("`response()` returns search response from GitHub's REST API", {
  # search_endpoint <- "https://api.github.com/search/code?q=shiny+user:r-world-devs"
  # test_mocker$cache(search_endpoint)
  # gh_search_response_raw <- test_rest_github$response(search_endpoint)
  gh_search_response_raw <- test_fixtures$github_search_response
  expect_gh_search_response(gh_search_response_raw[["items"]])
  test_mocker$cache(gh_search_response_raw)
})

test_that("`response()` returns search response from GitHub's REST API", {
  search_endpoint <- "https://api.github.com/search/code?q=shiny+user:openpharma+in:file+filename:DESCRIPTION"
  gh_search_response_in_file <- test_rest_github$response(search_endpoint)[["items"]]
  expect_gh_search_response(gh_search_response_in_file)
  test_mocker$cache(gh_search_response_in_file)
})

test_that("`search_response()` performs search with limit under 100", {
  total_n <- test_mocker$use("gh_search_response_raw")[["total_count"]]
  mockery::stub(
    test_rest_github_priv$search_response,
    "self$response",
    test_mocker$use("gh_search_response_raw")
  )
  gh_search_repos_response <- test_rest_github_priv$search_response(
    search_endpoint = test_mocker$use("search_endpoint"),
    total_n = total_n,
    byte_max = 384000
  )
  expect_gh_search_response(gh_search_repos_response)
  test_mocker$cache(gh_search_repos_response)
})

test_that("Mapping search result to repositories works", {
  result <- test_rest_github_priv$map_search_into_repos(
    search_response = test_mocker$use("gh_search_repos_response"),
    progress = FALSE
  )
  expect_gh_repos_rest_response(result)
})

test_that("`get_repos_by_code()` returns repos output for code search in files", {
  mockery::stub(
    test_rest_github$get_repos_by_code,
    "private$search_response",
    test_mocker$use("gh_search_response_in_file")
  )
  gh_repos_by_code <- test_rest_github$get_repos_by_code(
    code = "shiny",
    filename = "DESCRIPTION",
    org = "openpharma",
    verbose = FALSE
  )
  expect_gh_repos_rest_response(gh_repos_by_code)
  test_mocker$cache(gh_repos_by_code)
})

test_that("`get_repos_by_code()` for GitHub prepares a raw (raw_output = TRUE) search response", {
  mockery::stub(
    test_rest_github$get_repos_by_code,
    "private$search_response",
    test_mocker$use("gh_search_repos_response")
  )
  gh_repos_by_code_raw <- test_rest_github$get_repos_by_code(
    code = "shiny",
    org = "openpharma",
    raw_output = TRUE,
    verbose = FALSE
  )
  expect_gh_search_response(gh_repos_by_code_raw)
  test_mocker$cache(gh_repos_by_code_raw)
})

test_that("GitHub tailors precisely `repos_list`", {
  gh_repos_by_code <- test_mocker$use("gh_repos_by_code")
  gh_repos_by_code_tailored <-
    github_testhost_priv$tailor_repos_response(gh_repos_by_code)
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
  expect_snapshot(
    gh_repos_by_code_table <- github_testhost_priv$prepare_repos_table_from_rest(
      repos_list = test_mocker$use("gh_repos_by_code_tailored")
    )
  )
  expect_repos_table(
    gh_repos_by_code_table
  )
  gh_repos_by_code_table <- github_testhost_priv$add_repo_api_url(gh_repos_by_code_table)
  test_mocker$cache(gh_repos_by_code_table)
})

test_that("`get_repos_with_code_from_orgs()` works", {
  mockery::stub(
    github_testhost_priv$get_repos_with_code_from_orgs,
    "private$get_repos_response_with_code",
    test_mocker$use("gh_repos_by_code")
  )
  mockery::stub(
    github_testhost_priv$get_repos_with_code_from_orgs,
    "private$prepare_repos_table_from_rest",
    test_mocker$use("gh_repos_by_code_table")
  )
  repos_with_code <- github_testhost_priv$get_repos_with_code_from_orgs(
    code = "shiny",
    verbose = FALSE
  )
  expect_repos_table(repos_with_code, with_cols = "api_url")
})

test_that("GitHub prepares repos table from repositories response", {
  gh_repos_table <- github_testhost_priv$prepare_repos_table_from_graphql(
    repos_list = test_mocker$use("gh_repos_from_org")
  )
  expect_repos_table(
    gh_repos_table
  )
  test_mocker$cache(gh_repos_table)
})

test_that("GitHost adds `repo_api_url` column to GitHub repos table", {
  repos_table <- test_mocker$use("gh_repos_table")
  gh_repos_table_with_api_url <- github_testhost_priv$add_repo_api_url(repos_table)
  expect_true(all(grepl("api.github.com", gh_repos_table_with_api_url$api_url)))
  test_mocker$cache(gh_repos_table_with_api_url)
})

test_that("`get_all_repos()` works as expected", {
  mockery::stub(
    github_testhost_priv$get_all_repos,
    "private$prepare_repos_table_from_graphql",
    test_mocker$use("gh_repos_table_with_api_url")
  )
  expect_snapshot(
    gh_repos_table <- github_testhost_priv$get_all_repos()
  )
  expect_repos_table(
    gh_repos_table,
    with_cols = "api_url"
  )
  test_mocker$cache(gh_repos_table)
})

test_that("`get_repos_issues()` adds issues to repos table", {
  gh_repos_by_code_table <- test_mocker$use("gh_repos_by_code_table")
  suppressMessages(
    gh_repos_by_code_table <- test_rest_github$get_repos_issues(
      gh_repos_by_code_table,
      progress = FALSE
    )
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

test_that("`get_repos_contributors()` adds contributors to repos table", {
  expect_snapshot(
    gh_repos_by_code_table <- test_rest_github$get_repos_contributors(
      repos_table = test_mocker$use("gh_repos_by_code_table"),
      progress    = FALSE
    )
  )
  expect_repos_table(
    gh_repos_by_code_table,
    with_cols = c("api_url", "contributors")
  )
  expect_gt(
    length(gh_repos_by_code_table$contributors),
    0
  )
  test_mocker$cache(gh_repos_by_code_table)
})
