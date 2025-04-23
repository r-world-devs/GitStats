test_that("repos_by_org query is built properly", {
  gh_repos_by_org_query <-
    test_gqlquery_gh$repos_by_org(repo_cursor = "")
  expect_snapshot(
    gh_repos_by_org_query
  )
  test_mocker$cache(gh_repos_by_org_query)
})

test_that("repos_by_user query is built properly", {
  gh_repos_by_user_query <-
    test_gqlquery_gh$repos_by_user(repo_cursor = "")
  expect_snapshot(
    gh_repos_by_user_query
  )
  test_mocker$cache(gh_repos_by_user_query)
})

test_that("repos_by_ids query is built properly", {
  gh_repos_by_ids_query <-
    test_gqlquery_gh$repos_by_ids()
  expect_snapshot(
    gh_repos_by_ids_query
  )
  test_mocker$cache(gh_repos_by_ids_query)
})


if (integration_tests_skipped) {
  gh_org <- "test_org"
  gh_user <- "test_user"
  gh_repo <- "TestRepo"
  gh_code <- "test_code"
  gh_file <- "test_file"
} else {
  gh_org <- "r-world-devs"
  gh_repo <- "GitStats"
  gh_user <- "maciekbanas"
  gh_code <- "dplyr"
  gh_file <- "DESCRIPTION"
}

test_that("`get_repos_page()` pulls repos page from GitHub organization", {
  mockery::stub(
    test_graphql_github_priv$get_repos_page,
    "self$gql_response",
    test_fixtures$github_repos_by_org_response
  )
  gh_repos_page <- test_graphql_github_priv$get_repos_page(
    login = gh_org,
    type = "organization"
  )
  expect_gh_repos_gql_response(
    gh_repos_page$data$repositoryOwner$repositories$nodes[[1]]
  )
  test_mocker$cache(gh_repos_page)
})

test_that("get_repos() pulls repositories by ids", {
  mockery::stub(
    test_graphql_github$get_repos,
    "self$gql_response",
    test_fixtures$github_repos_by_ids_response
  )
  gh_repos_by_ids <- test_graphql_github$get_repos(
    repos_ids = c("repo_1", "repo_2", "repo_3")
  )
  expect_gh_repos_gql_response(
    gh_repos_by_ids[[1]]
  )
  test_mocker$cache(gh_repos_by_ids)
})

test_that("`get_repos_from_org()` prepares formatted list", {
  mockery::stub(
    test_graphql_github$get_repos_from_org,
    "private$get_repos_page",
    test_mocker$use("gh_repos_page")
  )
  gh_repos_from_org <- test_graphql_github$get_repos_from_org(
    org = gh_org,
    owner_type = "organization"
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
    login = gh_user,
    type = "user"
  )
  expect_gh_repos_gql_response(
    gh_repos_user_page$data$user$repositories$nodes[[1]]
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
    org = gh_user,
    owner_type = "user"
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

test_that("`search_for_code()` returns repos output for code search in files", {
  mockery::stub(
    test_rest_github$search_for_code,
    "self$response",
    list("total_count" = 3L)
  )
  mockery::stub(
    test_rest_github$search_for_code,
    "private$search_response",
    test_fixtures$github_search_response
  )
  gh_search_for_code <- test_rest_github$search_for_code(
    code = gh_code,
    filename = gh_file,
    in_path = FALSE,
    org = gh_org,
    verbose = FALSE
  )
  expect_gh_search_response(gh_search_for_code$items)
  test_mocker$cache(gh_search_for_code)
})

test_that("`search_repos_for_code()` returns repos output for code search in files", {
  mockery::stub(
    test_rest_github$search_repos_for_code,
    "self$response",
    list("total_count" = 3L)
  )
  mockery::stub(
    test_rest_github$search_repos_for_code,
    "private$search_response",
    test_fixtures$github_search_response
  )
  gh_search_repos_for_code <- test_rest_github$search_repos_for_code(
    code = gh_code,
    filename = gh_file,
    in_path = FALSE,
    repos = gh_org,
    verbose = FALSE
  )
  expect_gh_search_response(gh_search_repos_for_code$items)
  test_mocker$cache(gh_search_repos_for_code)
})

test_that("`prepare_repos_table()` prepares repos table", {
  gh_repos_by_code_table <- test_graphql_github$prepare_repos_table(
      repos_list = test_mocker$use("gh_repos_from_org"),
      org = gh_org
  )
  expect_repos_table(
    gh_repos_by_code_table
  )
  test_mocker$cache(gh_repos_by_code_table)
})

test_that("get_repos_ids", {
  repos_ids <- github_testhost_priv$get_repos_ids(
    search_response = test_mocker$use("gh_search_repos_for_code")[["items"]]
  )
  expect_type(
    repos_ids,
    "character"
  )
  expect_gt(
    length(repos_ids), 0
  )
})

test_that("parse_search_response parses search response into repositories output", {
  mockery::stub(
    github_testhost_priv$parse_search_response,
    "graphql_engine$get_repos",
    test_mocker$use("gh_repos_by_ids")
  )
  gh_repos_raw_output <- github_testhost_priv$parse_search_response(
    search_response = test_mocker$use("gh_search_repos_for_code")[["items"]],
    output = "raw"
  )
  expect_gh_repos_gql_response(gh_repos_raw_output[[1]])
  test_mocker$cache(gh_repos_raw_output)
})

test_that("parse_search_response parses search response into repositories output", {
  mockery::stub(
    github_testhost_priv$parse_search_response,
    "graphql_engine$get_repos_from_org",
    test_mocker$use("gh_repos_from_org")
  )
  gh_repos_by_code_table <- github_testhost_priv$parse_search_response(
    search_response = test_mocker$use("gh_search_repos_for_code")[["items"]],
    org = gh_org,
    output = "table"
  )
  expect_repos_table(gh_repos_by_code_table)
  test_mocker$cache(gh_repos_by_code_table)
})

test_that("`get_repos_with_code_from_orgs()` works", {
  mockery::stub(
    github_testhost_priv$get_repos_with_code_from_orgs,
    "rest_engine$search_for_code",
    test_mocker$use("gh_search_repos_for_code")[["items"]]
  )
  mockery::stub(
    github_testhost_priv$get_repos_with_code_from_orgs,
    "private$parse_search_response",
    test_mocker$use("gh_repos_by_code_table")
  )
  repos_with_code_from_orgs_full <- github_testhost_priv$get_repos_with_code_from_orgs(
    code = "shiny",
    output = "table",
    verbose = FALSE
  )
  expect_repos_table(repos_with_code_from_orgs_full)
  test_mocker$cache(repos_with_code_from_orgs_full)
})

test_that("`get_repos_with_code_from_orgs()` pulls raw response", {
  mockery::stub(
    github_testhost_priv$get_repos_with_code_from_orgs,
    "rest_engine$search_for_code",
    test_mocker$use("gh_search_repos_for_code")[["items"]]
  )
  mockery::stub(
    github_testhost_priv$get_repos_with_code_from_orgs,
    "private$parse_search_response",
    test_mocker$use("gh_repos_raw_output")
  )
  github_testhost_priv$orgs <- gh_org
  expect_snapshot(
    repos_with_code_from_orgs_raw <- github_testhost_priv$get_repos_with_code_from_orgs(
      code = "shiny",
      in_files = c("DESCRIPTION", "NAMESPACE"),
      output = "raw",
      verbose = TRUE
    )
  )
  expect_type(repos_with_code_from_orgs_raw, "list")
  expect_gt(length(repos_with_code_from_orgs_raw), 0)
})

test_that("`get_repos_with_code_from_host()` pulls and parses output into table", {
  mockery::stub(
    github_testhost_priv$get_repos_with_code_from_host,
    "rest_engine$search_for_code",
    test_mocker$use("gh_search_repos_for_code")[["items"]]
  )
  mockery::stub(
    github_testhost_priv$get_repos_with_code_from_host,
    "private$parse_search_response",
    test_mocker$use("gh_repos_by_code_table")
  )
  github_testhost_priv$searching_scope <- "all"
  expect_snapshot(
    repos_with_code_from_host_table <- github_testhost_priv$get_repos_with_code_from_host(
      code = "DESCRIPTION",
      in_path = TRUE,
      output = "table_full",
      verbose = TRUE
    )
  )
  expect_repos_table(repos_with_code_from_host_table)
})

test_that("`get_repos_with_code_from_repos()` works", {
  github_testhost_priv <- create_github_testhost(
    repos = c("TestRepo1", "TestRepo2"),
    mode = "private"
  )
  mockery::stub(
    github_testhost_priv$get_repos_with_code_from_repos,
    "rest_engine$search_repos_for_code",
    test_mocker$use("gh_search_repos_for_code")[["items"]]
  )
  mockery::stub(
    github_testhost_priv$get_repos_with_code_from_repos,
    "private$parse_search_response",
    test_mocker$use("gh_repos_by_code_table")
  )
  github_testhost_priv$searching_scope <- c("repo")
  expect_snapshot(
    repos_with_code_from_repos_full <- github_testhost_priv$get_repos_with_code_from_repos(
      code = "tests",
      output = "table",
      verbose = TRUE
    )
  )
  expect_repos_table(repos_with_code_from_repos_full)
})

test_that("`get_repos_with_code_from_host()` pulls raw response", {
  mockery::stub(
    github_testhost_priv$get_repos_with_code_from_host,
    "rest_engine$search_repos_for_code",
    test_mocker$use("gh_search_repos_for_code")[["items"]]
  )
  expect_snapshot(
    repos_with_code_from_host_raw <- github_testhost_priv$get_repos_with_code_from_host(
      code = "shiny",
      in_files = c("DESCRIPTION", "NAMESPACE"),
      output = "raw",
      verbose = TRUE
    )
  )
})

test_that("`get_repos_with_code_from_host()` pulls raw response", {
  mockery::stub(
    github_testhost_priv$get_repos_with_code_from_host,
    "rest_engine$search_for_code",
    test_mocker$use("gh_search_repos_for_code")[["items"]]
  )
  mockery::stub(
    github_testhost_priv$get_repos_with_code_from_host,
    "private$parse_search_response",
    test_mocker$use("gh_repos_raw_output")
  )
  repos_with_code_from_host_raw <- github_testhost_priv$get_repos_with_code_from_host(
    code = "shiny",
    in_files = c("DESCRIPTION", "NAMESPACE"),
    output = "raw",
    verbose = FALSE
  )
  expect_type(repos_with_code_from_host_raw, "list")
  expect_gt(length(repos_with_code_from_host_raw), 0)
  test_mocker$cache(repos_with_code_from_host_raw)
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

test_that("get_repos_with_code() scans whole host", {
  github_testhost_priv <- create_github_testhost(
    mode = "private"
  )
  mockery::stub(
    github_testhost_priv$get_repos_with_code,
    "private$get_repos_with_code_from_host",
    test_mocker$use("repos_with_code_from_host_raw")
  )
  github_repos_with_code_raw <- github_testhost_priv$get_repos_with_code(
    code = "test-code",
    output = "raw",
    verbose = FALSE,
    progress = FALSE
  )
  expect_type(github_repos_with_code_raw, "list")
  expect_gt(length(github_repos_with_code_raw), 0)
  github_testhost_priv$scan_all <- FALSE
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

test_that("get_repos_from_orgs works", {
  mockery::stub(
    github_testhost_priv$get_repos_from_orgs,
    "graphql_engine$get_repos_from_org",
    test_mocker$use("gh_repos_from_org")
  )
  github_testhost_priv$orgs <- gh_org
  gh_repos_from_orgs <- github_testhost_priv$get_repos_from_orgs(
    verbose = FALSE,
    progress = FALSE
  )
  expect_repos_table(
    gh_repos_from_orgs
  )
  test_mocker$cache(gh_repos_from_orgs)
})

test_that("get_repos_from_repos works", {
  test_org <- "test_org"
  attr(test_org, "type") <- "organization"
  mockery::stub(
    github_testhost_priv$get_repos_from_repos,
    "graphql_engine$set_owner_type",
    test_org
  )
  mockery::stub(
    github_testhost_priv$get_repos_from_repos,
    "graphql_engine$get_repos_from_org",
    test_mocker$use("gh_repos_from_orgs")
  )
  mockery::stub(
    github_testhost_priv$get_repos_from_repos,
    "graphql_engine$prepare_repos_table",
    test_mocker$use("gh_repos_table")
  )
  github_testhost_priv$searching_scope <- c("org", "repo")
  github_testhost_priv$orgs_repos <- list("test_org" = "TestRepo")
  expect_snapshot(
    gh_repos_individual <- github_testhost_priv$get_repos_from_repos(
      verbose = TRUE,
      progress = FALSE
    )
  )
  expect_repos_table(
    gh_repos_individual
  )
  test_mocker$cache(gh_repos_individual)
})

test_that("`get_all_repos()` works as expected", {
  mockery::stub(
    github_testhost_priv$get_all_repos,
    "private$get_repos_from_orgs",
    test_mocker$use("gh_repos_from_orgs")
  )
  mockery::stub(
    github_testhost_priv$get_all_repos,
    "private$get_repos_from_repos",
    test_mocker$use("gh_repos_individual")
  )
  gh_repos_table <- github_testhost_priv$get_all_repos(
    verbose = FALSE,
    progress = FALSE
  )
  expect_repos_table(
    gh_repos_table
  )
  test_mocker$cache(gh_repos_table)
})

test_that("`get_all_repos()` is set to scan whole git host", {
  github_testhost_all_priv <- create_github_testhost_all(
    orgs = "test_org",
    mode = "private"
  )
  mockery::stub(
    github_testhost_all_priv$get_all_repos,
    "private$get_orgs_from_host",
    "test_org"
  )
  mockery::stub(
    github_testhost_all_priv$get_all_repos,
    "private$get_repos_from_orgs",
    test_mocker$use("gh_repos_from_orgs")
  )
  mockery::stub(
    github_testhost_all_priv$get_all_repos,
    "private$get_repos_from_repos",
    test_mocker$use("gh_repos_individual")
  )
  expect_repos_table(
    github_testhost_all_priv$get_all_repos(
      verbose  = TRUE,
      progress = FALSE
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
    progress = FALSE
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
  expect_snapshot(
    gh_repos_with_contributors <- github_testhost_priv$get_repos_contributors(
      repos_table = test_mocker$use("gh_repos_table_with_platform"),
      verbose = TRUE,
      progress = FALSE
    )
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
    test_mocker$use("gh_repos_table_with_platform")
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
    test_mocker$use("gh_repos_table_with_platform")
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
