test_that("repos_by_org query is built properly", {
  gh_repos_by_org_query <-
    test_gqlquery_gh$repos_by_org()
  expect_snapshot(
    gh_repos_by_org_query
  )
  test_mocker$cache(gh_repos_by_org_query)
})

test_that("`get_repos_page()` pulls repos page from GitHub organization", {
  mockery::stub(
    test_graphql_github_priv$get_repos_page,
    "self$gql_response",
    test_fixtures$github_repos_by_org_response
  )
  gh_repos_page <- test_graphql_github_priv$get_repos_page(
    login = "test_org",
    type = "organization"
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
    org = "test_org",
    type = "organization"
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

test_that("`get_repos_page()` pulls repos page from GitHub user", {
  mockery::stub(
    test_graphql_github_priv$get_repos_page,
    "self$gql_response",
    test_fixtures$github_repos_by_user_response
  )
  gh_repos_user_page <- test_graphql_github_priv$get_repos_page(
    login = "test_user",
    type = "user"
  )
  expect_gh_repos_gql_response(
    gh_repos_user_page,
    type = "user"
  )
  test_mocker$cache(gh_repos_user_page)
})

test_that("`get_repos_from_org()` prepares formatted list", {
  mockery::stub(
    test_graphql_github$get_repos_from_org,
    "private$get_repos_page",
    test_mocker$use("gh_repos_user_page")
  )
  gh_repos_from_user <- test_graphql_github$get_repos_from_org(
    org = "test_user",
    type = "user"
  )
  expect_list_contains(
    gh_repos_from_user[[1]],
    c(
      "id", "name", "stars", "forks", "created_at",
      "last_activity_at", "languages", "issues_open", "issues_closed",
      "contributors", "repo_url"
    )
  )
  test_mocker$cache(gh_repos_from_user)
})

# REST Engine search repos by code

test_that("`search_response()` performs search with limit under 1000", {
  total_n <- test_fixtures$github_search_response[["total_count"]]
  mockery::stub(
    test_rest_github_priv$search_response,
    "self$response",
    test_fixtures$github_search_response
  )
  gh_search_repos_response <- test_rest_github_priv$search_response(
    search_endpoint = test_mocker$use("search_endpoint"),
    total_n = total_n
  )
  expect_gh_search_response(gh_search_repos_response)
  test_mocker$cache(gh_search_repos_response)
})

test_that("`search_response()` performs search with limit over 1000", {
  total_n <- test_fixtures$github_search_response_large[["total_count"]]
  mockery::stub(
    test_rest_github_priv$search_response,
    "self$response",
    test_fixtures$github_search_response_large
  )
  gh_search_repos_response <- test_rest_github_priv$search_response(
    search_endpoint = test_mocker$use("search_endpoint"),
    total_n = total_n
  )
  expect_gh_search_response(gh_search_repos_response)
  test_mocker$cache(gh_search_repos_response)
})

test_that("Mapping search result to repositories works", {
  mockery::stub(
    test_rest_github_priv$map_search_into_repos,
    "self$response",
    test_fixtures$github_repository_rest_response
  )
  gh_mapped_repos <- test_rest_github_priv$map_search_into_repos(
    search_response = test_mocker$use("gh_search_repos_response"),
    progress = FALSE
  )
  expect_gh_repos_rest_response(gh_mapped_repos)
  test_mocker$cache(gh_mapped_repos)
})

test_that("`get_repos_by_code()` returns repos output for code search in files", {
  mockery::stub(
    test_rest_github$get_repos_by_code,
    "self$response",
    list("total_count" = 3L)
  )
  mockery::stub(
    test_rest_github$get_repos_by_code,
    "private$search_response",
    test_fixtures$github_search_response
  )
  mockery::stub(
    test_rest_github$get_repos_by_code,
    "private$map_search_into_repos",
    test_mocker$use("gh_mapped_repos")
  )
  gh_repos_by_code <- test_rest_github$get_repos_by_code(
    code     = "test_code",
    filename = "test_file",
    org      = "test_org",
    verbose  = FALSE
  )
  expect_gh_repos_rest_response(gh_repos_by_code)
  test_mocker$cache(gh_repos_by_code)
})

test_that("`get_repos_by_code()` for GitHub prepares a raw search response", {
  mockery::stub(
    test_rest_github$get_repos_by_code,
    "self$response",
    list("total_count" = 3L)
  )
  mockery::stub(
    test_rest_github$get_repos_by_code,
    "private$search_response",
    test_fixtures$github_search_response
  )
  mockery::stub(
    test_rest_github$get_repos_by_code,
    "private$map_search_into_repos",
    test_mocker$use("gh_mapped_repos")
  )
  gh_repos_by_code_raw <- test_rest_github$get_repos_by_code(
    code    = "test_code",
    org     = "test_org",
    output  = "raw",
    verbose = FALSE
  )
  expect_gh_search_response(gh_repos_by_code_raw$items)
  test_mocker$cache(gh_repos_by_code_raw)
})

test_that("GitHub tailors precisely `repos_list`", {
  gh_repos_by_code <- test_mocker$use("gh_repos_by_code")
  gh_repos_by_code_tailored <-
    test_rest_github$tailor_repos_response(gh_repos_by_code)
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

test_that("GitHub tailors `repos_list` to minimal version of table", {
  gh_repos_by_code <- test_mocker$use("gh_repos_by_code")
  gh_repos_by_code_tailored_min <-
    test_rest_github$tailor_repos_response(
      repos_response = gh_repos_by_code,
      output = "table_min"
    )
  gh_repos_by_code_tailored_min %>%
    expect_type("list") %>%
    expect_length(length(gh_repos_by_code))
  expect_list_contains_only(
    gh_repos_by_code_tailored_min[[1]],
    c(
      "repo_id", "repo_name", "created_at", "organization"
    )
  )
  expect_lt(
    length(gh_repos_by_code_tailored_min[[1]]),
    length(gh_repos_by_code[[1]])
  )
  test_mocker$cache(gh_repos_by_code_tailored_min)
})

test_that("`prepare_repos_table()` prepares repos table", {
  gh_repos_by_code_table <- test_rest_github$prepare_repos_table(
      repos_list = test_mocker$use("gh_repos_by_code_tailored"),
      verbose = FALSE
  )
  expect_repos_table(
    gh_repos_by_code_table
  )
  test_mocker$cache(gh_repos_by_code_table)
})

test_that("`prepare_repos_table()` prepares minimum version of repos table", {
  gh_repos_by_code_table_min <- test_rest_github$prepare_repos_table(
    repos_list = test_mocker$use("gh_repos_by_code_tailored_min"),
    output = "table_min",
    verbose = FALSE
  )
  expect_repos_table(
    gh_repos_by_code_table_min,
    repo_cols = repo_min_colnames
  )
  test_mocker$cache(gh_repos_by_code_table_min)
})

test_that("`get_repos_issues()` adds issues to repos table", {
  mockery::stub(
    test_rest_github$get_repos_issues,
    "self$response",
    test_fixtures$github_issues_response
  )
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

test_that("`get_repos_with_code_from_orgs()` works", {
  mockery::stub(
    github_testhost_priv$get_repos_with_code_from_orgs,
    "rest_engine$get_repos_by_code",
    test_mocker$use("gh_repos_by_code")
  )
  mockery::stub(
    github_testhost_priv$get_repos_with_code_from_orgs,
    "rest_engine$get_repos_issues",
    test_mocker$use("gh_repos_by_code_table")
  )
  repos_with_code_from_orgs_full <- github_testhost_priv$get_repos_with_code_from_orgs(
    code = "shiny",
    output = "table_full",
    verbose = FALSE
  )
  expect_repos_table(repos_with_code_from_orgs_full)
  test_mocker$cache(repos_with_code_from_orgs_full)
})

test_that("`get_repos_with_code_from_orgs()` pulls minimum version of table", {
  mockery::stub(
    github_testhost_priv$get_repos_with_code_from_orgs,
    "rest_engine$get_repos_by_code",
    test_mocker$use("gh_repos_by_code")
  )
  mockery::stub(
    github_testhost_priv$get_repos_with_code_from_orgs,
    "rest_engine$prepare_repos_table",
    test_mocker$use("gh_repos_by_code_table_min")
  )
  repos_with_code_from_orgs_min <- github_testhost_priv$get_repos_with_code_from_orgs(
    code = "shiny",
    output = "table_min",
    verbose = FALSE
  )
  expect_repos_table(repos_with_code_from_orgs_min,
                     repo_cols = repo_min_colnames)
  test_mocker$cache(repos_with_code_from_orgs_min)
})

test_that("`get_repos_with_code_from_orgs()` pulls raw response", {
  mockery::stub(
    github_testhost_priv$get_repos_with_code_from_orgs,
    "rest_engine$get_repos_by_code",
    test_mocker$use("gh_repos_by_code_raw")
  )
  repos_with_code_from_orgs_raw <- github_testhost_priv$get_repos_with_code_from_orgs(
    code = "shiny",
    in_files = c("DESCRIPTION", "NAMESPACE"),
    output = "raw",
    verbose = FALSE
  )
  expect_type(repos_with_code_from_orgs_raw, "list")
  expect_gt(length(repos_with_code_from_orgs_raw), 0)
})

test_that("`get_repos_with_code_from_host()` pulls raw response", {
  mockery::stub(
    github_testhost_priv$get_repos_with_code_from_host,
    "rest_engine$get_repos_by_code",
    test_mocker$use("gh_repos_by_code_raw")
  )
  repos_with_code_from_host_raw <- github_testhost_priv$get_repos_with_code_from_host(
    code = "shiny",
    in_files = c("DESCRIPTION", "NAMESPACE"),
    output = "raw",
    verbose = FALSE
  )
  expect_type(repos_with_code_from_host_raw, "list")
  expect_gt(length(repos_with_code_from_host_raw), 0)
})

test_that("get_repos_with_code() works", {
  mockery::stub(
    github_testhost_priv$get_repos_with_code,
    "private$get_repos_with_code_from_orgs",
    test_mocker$use("repos_with_code_from_orgs_full")
  )
  github_repos_with_code <- github_testhost_priv$get_repos_with_code(
    code = "test-code",
    verbose = FALSE,
    progress = FALSE
  )
  expect_repos_table(
    github_repos_with_code
  )
})

test_that("get_repos_with_code() works", {
  mockery::stub(
    github_testhost_priv$get_repos_with_code,
    "private$get_repos_with_code_from_orgs",
    test_mocker$use("repos_with_code_from_orgs_min")
  )
  github_repos_with_code_min <- github_testhost_priv$get_repos_with_code(
    code = "test-code",
    output = "table_min",
    verbose = FALSE,
    progress = FALSE
  )
  expect_repos_table(
    github_repos_with_code_min,
    repo_cols = repo_min_colnames
  )
  test_mocker$cache(github_repos_with_code_min)
})

test_that("GitHub prepares repos table from repositories response", {
  gh_repos_table <- test_graphql_github$prepare_repos_table(
    repos_list = test_mocker$use("gh_repos_from_org")
  )
  expect_repos_table(
    gh_repos_table
  )
  test_mocker$cache(gh_repos_table)
})

test_that("`get_all_repos()` works as expected", {
  mockery::stub(
    github_testhost_priv$get_all_repos,
    "graphql_engine$prepare_repos_table",
    test_mocker$use("gh_repos_table")
  )
  gh_repos_table <- github_testhost_priv$get_all_repos(
    verbose = FALSE
  )
  expect_repos_table(
    gh_repos_table
  )
  test_mocker$cache(gh_repos_table)
})

test_that("`get_all_repos()` prints proper message", {
  mockery::stub(
    github_testhost_priv$get_all_repos,
    "graphql_engine$prepare_repos_table",
    test_mocker$use("gh_repos_table")
  )
  expect_snapshot(
    gh_repos_table <- github_testhost_priv$get_all_repos(
      verbose = TRUE
    )
  )
})

test_that("GitHost adds `repo_api_url` column to GitHub repos table", {
  repos_table <- test_mocker$use("gh_repos_table")
  gh_repos_table_with_api_url <- github_testhost_priv$add_repo_api_url(repos_table)
  expect_true(all(grepl("api.github.com", gh_repos_table_with_api_url$api_url)))
  test_mocker$cache(gh_repos_table_with_api_url)
})

test_that("add_platform adds data on Git platform to repos table", {
  gh_repos_table_with_platform <- github_testhost_priv$add_platform(
    repos_table = test_mocker$use("gh_repos_table_with_api_url")
  )
  expect_repos_table(
    gh_repos_table_with_platform,
    with_cols = c("api_url", "platform")
  )
  test_mocker$cache(gh_repos_table_with_platform)
})


test_that("get_contributors_from_repo", {
  mockery::stub(
    test_rest_github_priv$get_contributors_from_repo,
    "private$paginate_results",
    test_fixtures$github_contributors_response
  )
  github_contributors <- test_rest_github_priv$get_contributors_from_repo(
    contributors_endpoint = "test_endpoint",
    user_name = "test_user"
  )
  expect_type(github_contributors, "character")
  expect_gt(length(github_contributors), 0)
  test_mocker$cache(github_contributors)
})

test_that("`get_repos_contributors()` adds contributors to repos table", {
  mockery::stub(
    test_rest_github$get_repos_contributors,
    "private$get_contributors_from_repo",
    test_mocker$use("github_contributors")
  )
  gh_repos_with_contributors <- test_rest_github$get_repos_contributors(
    repos_table = test_mocker$use("gh_repos_table_with_platform"),
    progress    = FALSE
  )
  expect_repos_table(
    gh_repos_with_contributors,
    with_cols = c("api_url", "platform", "contributors")
  )
  expect_gt(
    length(gh_repos_with_contributors$contributors),
    0
  )
  test_mocker$cache(gh_repos_with_contributors)
})

test_that("`get_repos_contributors()` works on GitHost level", {
  mockery::stub(
    github_testhost_priv$get_repos_contributors,
    "rest_engine$get_repos_contributors",
    test_mocker$use("gh_repos_with_contributors")
  )
  gh_repos_with_contributors <- github_testhost_priv$get_repos_contributors(
    repos_table = test_mocker$use("gh_repos_table_with_platform"),
    verbose     = FALSE,
    progress    = FALSE
  )
  expect_repos_table(
    gh_repos_with_contributors,
    with_cols = c("api_url", "platform", "contributors")
  )
  expect_gt(
    length(gh_repos_with_contributors$contributors),
    0
  )
  test_mocker$cache(gh_repos_with_contributors)
})

test_that("`get_repos()` works as expected", {
  mockery::stub(
    github_testhost$get_repos,
    "private$get_all_repos",
    test_mocker$use("gh_repos_table")
  )
  gh_repos_table <- github_testhost$get_repos(
    add_contributors = FALSE,
    verbose = FALSE
  )
  expect_repos_table(
    gh_repos_table,
    with_cols = c("api_url", "platform")
  )
  test_mocker$cache(gh_repos_table)
})

test_that("`get_repos()` works as expected", {
  mockery::stub(
    github_testhost$get_repos,
    "private$get_all_repos",
    test_mocker$use("gh_repos_table")
  )
  mockery::stub(
    github_testhost$get_repos,
    "private$get_repos_contributors",
    test_mocker$use("gh_repos_with_contributors")
  )
  gh_repos_table_full <- github_testhost$get_repos(
    add_contributors = TRUE,
    verbose = FALSE
  )
  expect_repos_table(
    gh_repos_table_full,
    with_cols = c("api_url", "platform", "contributors")
  )
  test_mocker$cache(gh_repos_table_full)
})

test_that("`get_repos()` pulls table in minimalist version", {
  mockery::stub(
    github_testhost$get_repos,
    "private$get_repos_with_code",
    test_mocker$use("github_repos_with_code_min")
  )
  gh_repos_table_min <- github_testhost$get_repos(
    add_contributors = FALSE,
    with_code = "test_code",
    output = "table_min",
    verbose = FALSE
  )
  expect_repos_table(
    gh_repos_table_min,
    repo_cols = repo_min_colnames,
    with_cols = c("api_url", "platform")
  )
  test_mocker$cache(gh_repos_table_min)
})
