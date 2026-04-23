test_that("repos queries are built properly", {
  gl_repos_by_org_query <-
    test_gqlquery_gl$repos_by_org()
  expect_snapshot(
    gl_repos_by_org_query
  )
  test_mocker$cache(gl_repos_by_org_query)
})

test_that("repos queries are built properly", {
  gl_repos_query <-
    test_gqlquery_gl$repos("")
  expect_snapshot(
    gl_repos_query
  )
})

test_that("repo_by_fullpath query is built properly", {
  gl_repo_by_fullpath_query <-
    test_gqlquery_gl$repo_by_fullpath()
  expect_snapshot(
    gl_repo_by_fullpath_query
  )
})

test_that("`get_repos_page()` pulls repos page from GitLab group", {
  mockery::stub(
    test_graphql_gitlab_priv$get_repos_page,
    "self$gql_response",
    test_fixtures$gitlab_repos_by_org_response
  )
  gl_repos_page <- test_graphql_gitlab_priv$get_repos_page(
    org = "mbtests",
    type = "organization"
  )
  expect_repos_gitlab_gql_response(
    gl_repos_page
  )
  test_mocker$cache(gl_repos_page)
})

test_that("`get_repos_from_org()` prepares formatted list", {
  mockery::stub(
    test_graphql_gitlab$get_repos_from_org,
    "private$get_repos_page",
    test_mocker$use("gl_repos_page")
  )
  gl_repos_from_org <- test_graphql_gitlab$get_repos_from_org(
    org = "mbtests",
    owner_type = "organization"
  )
  expect_equal(
    names(gl_repos_from_org[[1]]$node),
    c(
      "repo_id", "repo_name", "repo_path", "repo_fullpath", "repository",
      "stars", "forks", "created_at", "last_activity_at",
      "languages", "issues", "namespace", "repo_url"
    )
  )
  test_mocker$cache(gl_repos_from_org)
})

test_that("`get_repos_page()` pulls repos page from GitLab user", {
  mockery::stub(
    test_graphql_gitlab_priv$get_repos_page,
    "self$gql_response",
    test_fixtures$gitlab_repos_by_user_response
  )
  gl_repos_user_page <- test_graphql_gitlab_priv$get_repos_page(
    org = "test_user",
    type = "user"
  )
  expect_repos_gitlab_gql_response(
    gl_repos_user_page,
    type = "user"
  )
  test_mocker$cache(gl_repos_user_page)
})

test_that("`get_repos_from_org()` prepares formatted list", {
  mockery::stub(
    test_graphql_gitlab$get_repos_from_org,
    "private$get_repos_page",
    test_mocker$use("gl_repos_user_page")
  )
  gl_repos_from_user <- test_graphql_gitlab$get_repos_from_org(
    org = "test_user",
    owner_type = "user"
  )
  expect_equal(
    names(gl_repos_from_user[[1]]$node),
    c(
      "repo_id", "repo_name", "repo_path", "repo_fullpath", "repository",
      "stars", "forks", "created_at", "last_activity_at",
      "languages", "issues", "namespace", "repo_url"
    )
  )
  test_mocker$cache(gl_repos_from_user)
})

test_that("`get_repos_by_fullpath()` queries repos directly by path", {
  mockery::stub(
    test_graphql_gitlab$get_repos_by_fullpath,
    "self$gql_response",
    test_fixtures$gitlab_repo_by_fullpath_response
  )
  gl_repos_by_path <- test_graphql_gitlab$get_repos_by_fullpath(
    full_paths = c("mbtests/gitstatstesting")
  )
  expect_type(gl_repos_by_path, "list")
  expect_length(gl_repos_by_path, 1)
  expect_equal(
    names(gl_repos_by_path[[1]]$node),
    c(
      "repo_id", "repo_name", "repo_path", "repo_fullpath", "repository",
      "stars", "forks", "created_at", "last_activity_at",
      "languages", "issues", "namespace", "repo_url"
    )
  )
  test_mocker$cache(gl_repos_by_path)
})

test_that("`get_repos_by_fullpath()` skips repos that return NULL", {
  null_response <- list("data" = list("project" = NULL))
  mockery::stub(
    test_graphql_gitlab$get_repos_by_fullpath,
    "self$gql_response",
    null_response
  )
  gl_repos_by_path <- test_graphql_gitlab$get_repos_by_fullpath(
    full_paths = c("nonexistent/repo")
  )
  expect_type(gl_repos_by_path, "list")
  expect_length(gl_repos_by_path, 0)
})

test_that("`get_repos_from_org()` does not fail when GraphQL response is not complete", {
  mockery::stub(
    test_graphql_gitlab$get_repos_from_org,
    "private$get_repos_page",
    test_fixtures$empty_gql_response
  )
  gl_repos_from_org <- test_graphql_gitlab$get_repos_from_org(
    org = "mbtests",
    owner_type = "organization"
  )
  expect_type(
    gl_repos_from_org,
    "list"
  )
  expect_length(
    gl_repos_from_org,
    0
  )
  mockery::stub(
    test_graphql_gitlab$get_repos_from_org,
    "private$get_repos_page",
    test_fixtures$half_empty_gql_response
  )
  gl_repos_from_org <- test_graphql_gitlab$get_repos_from_org(
    org = "mbtests",
    owner_type = "organization"
  )
  expect_type(
    gl_repos_from_org,
    "list"
  )
  expect_length(
    gl_repos_from_org,
    0
  )
})

test_that("get_repos_page handles properly a GraphQL query error", {
  mockery::stub(
    test_graphql_gitlab_priv$get_repos_page,
    "self$gql_response",
    test_error_fixtures$graphql_error_no_count_languages |>
      test_graphql_gitlab_priv$set_graphql_error_class()
  )
  repos_graphql_error <- test_graphql_gitlab_priv$get_repos_page()
  expect_s3_class(repos_graphql_error, "graphql_error")
  test_mocker$cache(repos_graphql_error)
})


test_that("get_repos_page handles properly a GraphQL query error", {
  mockery::stub(
    test_graphql_gitlab_priv$get_repos_page,
    "self$gql_response",
    test_error_fixtures$graphql_server_error |>
      test_graphql_gitlab_priv$set_graphql_error_class()
  )
  internal_server_error <- test_graphql_gitlab_priv$get_repos_page()
  expect_s3_class(internal_server_error, "graphql_error")
  test_mocker$cache(internal_server_error)
})

test_that("error handler works correctly", {
  output <- test_graphql_gitlab_priv$handle_graphql_error(
    responses_list = test_mocker$use("repos_graphql_error"),
    verbose = FALSE
  )
  expect_s3_class(output, "graphql_error")
})

test_that("error handler prints proper messages", {
  expect_snapshot(
    output <- test_graphql_gitlab_priv$handle_graphql_error(
      responses_list = test_mocker$use("repos_graphql_error"),
      verbose = TRUE
    )
  )
})

test_that("get_repos returns empty list when data is flawed (edges and nextPage is NULL)", {
  flawed_repos_response <- test_fixtures$gitlab_repos_response_flawed
  mockery::stub(
    test_graphql_gitlab$get_repos,
    "private$get_repos_page",
    flawed_repos_response
  )
  repos_response <- test_graphql_gitlab$get_repos(
    repos_ids = c("test_id_1", "test_id_2"),
    verbose = TRUE
  )
  expect_equal(
    repos_response,
    list()
  )
})

test_that("get_repos tries one more time pull data when encounters GraphQL query error", {
  standard_graphql_error <- test_fixtures$gitlab_repos_by_user_response
  class(standard_graphql_error) <- c(class(standard_graphql_error), "graphql_error")
  mockery::stub(
    test_graphql_gitlab$get_repos,
    "private$get_repos_page",
    standard_graphql_error
  )
  repos_response <- test_graphql_gitlab$get_repos(
    repos_ids = c("test_id_1", "test_id_2"),
    verbose = TRUE
  )
  expect_named(
    repos_response[[1]]$node,
    c("repo_id", "repo_name", "repo_path", "repo_fullpath", "repository", "stars",
      "forks", "created_at", "last_activity_at", "languages", "issues", "namespace",
      "repo_url")
  )
})

test_that("get_repos breaks when response is a GraphQL 'no fields' error", {
  mockery::stub(
    test_graphql_gitlab$get_repos,
    "private$get_repos_page",
    test_mocker$use("repos_graphql_error")
  )
  response <- test_graphql_gitlab$get_repos(
    repos_ids = c("test_id_1", "test_id_2"),
    verbose = FALSE
  )
  expect_s3_class(response, "graphql_error")
  expect_s3_class(response, "graphql_no_fields_error")
})

test_that("get_repos falls back to batching on GraphQL limit error", {
  limit_error <- test_error_fixtures$graphql_limit_error
  class(limit_error) <- c(class(limit_error), "graphql_error", "graphql_limit_error")
  mockery::stub(
    test_graphql_gitlab$get_repos,
    "private$get_repos_page",
    limit_error
  )
  mockery::stub(
    test_graphql_gitlab$get_repos,
    "private$get_repos_in_batches",
    test_fixtures$gitlab_repos_by_user_response$data$projects$edges
  )
  repos_response <- test_graphql_gitlab$get_repos(
    repos_ids = c("test_id_1", "test_id_2"),
    verbose = FALSE
  )
  expect_type(repos_response, "list")
  expect_gt(length(repos_response), 0)
  expect_named(
    repos_response[[1]]$node,
    c("repo_id", "repo_name", "repo_path", "repo_fullpath", "repository", "stars",
      "forks", "created_at", "last_activity_at", "languages", "issues", "namespace",
      "repo_url")
  )
})

test_that("get_repos prints messages when falling back to batching", {
  limit_error <- test_error_fixtures$graphql_limit_error
  class(limit_error) <- c(class(limit_error), "graphql_error", "graphql_limit_error")
  mockery::stub(
    test_graphql_gitlab$get_repos,
    "private$get_repos_page",
    limit_error
  )
  mockery::stub(
    test_graphql_gitlab$get_repos,
    "private$get_repos_in_batches",
    test_fixtures$gitlab_repos_by_user_response$data$projects$edges
  )
  expect_snapshot(
    gitlab_repos <- test_graphql_gitlab$get_repos(
      repos_ids = c("test_id_1", "test_id_2"),
      verbose = TRUE
    )
  )
  expect_type(gitlab_repos, "list")
  expect_gt(length(gitlab_repos), 0)
  expect_list_contains(
    gitlab_repos[[1]]$node,
    c("repo_id", "repo_name", "repository", "stars", "forks", "created_at", "last_activity_at")
  )
})

test_that("get_repos_in_batches pulls repos in smaller chunks", {
  mock_response <- httr2::response_json(
    status_code = 200,
    body = test_fixtures$gitlab_repos_by_user_response
  )
  mockery::stub(
    test_graphql_gitlab_priv$get_repos_in_batches,
    "graphql_response",
    test_fixtures$gitlab_repos_by_user_response
  )
  repos_response <- test_graphql_gitlab_priv$get_repos_in_batches(
    repos_ids = as.character(1:120),
    batch_size = 50,
    verbose = FALSE
  )
  expect_type(repos_response, "list")
  expect_gt(length(repos_response), 0)
})

test_that("get_repos_in_batches dispatches via gitstats_map", {
  mockery::stub(
    test_graphql_gitlab_priv$get_repos_in_batches,
    "graphql_response",
    test_fixtures$gitlab_repos_by_user_response
  )
  gitstats_map_called <- FALSE
  mockery::stub(
    test_graphql_gitlab_priv$get_repos_in_batches,
    "gitstats_map",
    function(.x, .f, ...) {
      gitstats_map_called <<- TRUE
      purrr::map(.x, .f, ...)
    }
  )
  repos_response <- test_graphql_gitlab_priv$get_repos_in_batches(
    repos_ids = as.character(1:120),
    batch_size = 50,
    verbose = FALSE
  )
  expect_true(gitstats_map_called)
  expect_type(repos_response, "list")
  expect_gt(length(repos_response), 0)
})

test_that("get_repos_from_org handles properly a GraphQL query error", {
  mockery::stub(
    test_graphql_gitlab$get_repos_from_org,
    "private$get_repos_page",
    test_mocker$use("repos_graphql_error")
  )
  gitlab_repos_error <- test_graphql_gitlab$get_repos_from_org(
    org = "mbtests",
    owner_type = "organization",
    verbose = FALSE
  )
  expect_s3_class(gitlab_repos_error, "graphql_error")
  test_mocker$cache(gitlab_repos_error)
})

test_that("`get_repos_languages()` works", {
  repos_list <- test_fixtures$gitlab_repositories_rest_response
  mockery::stub(
    test_rest_gitlab_priv$get_repos_languages,
    "self$response",
    test_fixtures$gitlab_languages_response
  )
  gl_repos_list_with_languages <- test_rest_gitlab_priv$get_repos_languages(
    repos_list = repos_list,
    verbose = FALSE,
    progress = FALSE
  )
  purrr::walk(gl_repos_list_with_languages, ~ expect_list_contains(., "languages"))
  expect_equal(gl_repos_list_with_languages[[1]]$languages, c("Python", "R"))
  test_mocker$cache(gl_repos_list_with_languages)
})

test_that("REST engine pulls repositories from organization", {
  mockery::stub(
    test_rest_gitlab$get_repos_from_org,
    "private$paginate_results",
    test_fixtures$gitlab_repositories_rest_response
  )
  mockery::stub(
    test_rest_gitlab$get_repos_from_org,
    "private$get_repos_languages",
    test_mocker$use("gl_repos_list_with_languages")
  )
  test_org <- "mbtests"
  attr(test_org, "type") <- "organization"
  gitlab_rest_repos_from_org_raw <- test_rest_gitlab$get_repos_from_org(
    org = test_org,
    repos =  c("test_repo_1", "test_repo_2"),
    output = "raw"
  )
  expect_length(gitlab_rest_repos_from_org_raw, 2L)
  test_mocker$cache(gitlab_rest_repos_from_org_raw)
  gitlab_rest_repos_from_org <- test_rest_gitlab$get_repos_from_org(
    org = test_org,
    output = "full_table"
  )
  purrr::walk(gitlab_rest_repos_from_org, ~ expect_in("languages", names(.)))
  test_mocker$cache(gitlab_rest_repos_from_org)
})

test_that("REST engine prepares repositories table", {
  gitlab_rest_repos_table <- test_rest_gitlab$prepare_repos_table(
    repos_list = test_mocker$use("gitlab_rest_repos_from_org"),
    org = "mbtests"
  )
  expect_repos_table(gitlab_rest_repos_table)
  test_mocker$cache(gitlab_rest_repos_table)
})

test_that("GitLab build_search_query builds query with code only", {
  query <- test_rest_gitlab_priv$build_search_query(code = "test")
  expect_equal(query, utils::URLencode("test", reserved = TRUE))
})

test_that("GitLab build_search_query builds query with in_path", {
  query <- test_rest_gitlab_priv$build_search_query(code = "src/main", in_path = TRUE)
  expect_match(query, "^path:")
})

test_that("GitLab build_search_query builds query with filename", {
  query <- test_rest_gitlab_priv$build_search_query(
    code = "test",
    filename = "DESCRIPTION"
  )
  expect_match(query, "filename:DESCRIPTION$")
})

test_that("`search_for_code()` works", {
  mockery::stub(
    test_rest_gitlab$search_for_code,
    "self$response",
    list() # output not mocked as falls into infinite loop
  )
  expect_snapshot(
    gl_search_repos_by_code <- test_rest_gitlab$search_for_code(
      code = "test",
      filename = "TESTFILE",
      verbose = TRUE,
      page_max = 2
    )
  )
})

test_that("`search_for_code()` handles the 1000 response limit", {
  limit_rest_error <- function() stop("test")
  mockery::stub(
    test_rest_gitlab$search_for_code,
    "self$response",
    limit_rest_error
  )
  mockery::stub(
    test_rest_gitlab$search_for_code,
    "list",
    rep(1, 1e4)
  )
  expect_snapshot(
    gl_search_repos_by_code <- test_rest_gitlab$search_for_code(
      code = "test",
      filename = "TESTFILE",
      verbose = TRUE,
      page_max = 2
    )
  )
  expect_s3_class(gl_search_repos_by_code, "rest_error")
  expect_s3_class(gl_search_repos_by_code, "rest_error_response_limit")
})

test_that("`search_repos_for_code()` works", {
  mockery::stub(
    test_rest_gitlab$search_repos_for_code,
    "self$response",
    list()
  )
  expect_snapshot(
    gl_search_repos_by_code <- test_rest_gitlab$search_repos_for_code(
      code = "test",
      repos = "TestRepo",
      filename = "TESTFILE",
      verbose = TRUE,
      page_max = 2
    )
  )
})

test_that("GraphQL engine prepares repos table", {
  gl_repos_table <- test_graphql_gitlab$prepare_repos_table(
    repos_list = test_mocker$use("gl_repos_from_org"),
    org = "mbtests"
  )
  expect_repos_table(
    gl_repos_table
  )
  test_mocker$cache(gl_repos_table)
})

test_that("GraphQL engine prepares repos table with no org specified", {
  gl_repos_table <- test_graphql_gitlab$prepare_repos_table(
    repos_list = test_mocker$use("gl_repos_from_org"),
    org = NULL
  )
  expect_repos_table(
    gl_repos_table
  )
})

test_that("GraphQL engine prepares repos table with no info on org at all", {
  repos_from_org <- test_mocker$use("gl_repos_from_org") |>
    purrr::map(function(x) {
      x$node$namespace$path <- NULL
      x
    })
  gl_repos_table <- test_graphql_gitlab$prepare_repos_table(
    repos_list = repos_from_org,
    org = NULL
  )
  expect_repos_table(
    gl_repos_table
  )
  expect_true(
    all(gl_repos_table$org == "mbtests")
  )
})

test_that("get_repos_from_org prints proper message", {
  if (integration_tests_skipped) {
    mockery::stub(
      gitlab_testhost_priv$get_repos_from_orgs,
      "graphql_engine$get_repos_from_org",
      test_mocker$use("gl_repos_from_org")
    )
  }
  gitlab_testhost_priv$orgs <- "mbtests"
  expect_snapshot(
    gl_repos_from_orgs <- gitlab_testhost_priv$get_repos_from_orgs(
      add_languages = TRUE,
      verbose = TRUE,
      progress = FALSE
    )
  )
  expect_repos_table(
    gl_repos_from_orgs
  )
  test_mocker$cache(gl_repos_from_orgs)
})

test_that("GitLab Host turns to REST if GraphQL fails with error (org setup)", {
  mockery::stub(
    gitlab_testhost_priv$get_repos_from_orgs,
    "graphql_engine$get_repos_from_org",
    test_mocker$use("gitlab_repos_error")
  )
  mockery::stub(
    gitlab_testhost_priv$get_repos_from_orgs,
    "rest_engine$prepare_repos_table",
    test_mocker$use("gitlab_rest_repos_table")
  )
  gl_repos_from_orgs <- gitlab_testhost_priv$get_repos_from_orgs(
    add_languages = TRUE,
    verbose = FALSE,
    progress = FALSE
  )
  expect_repos_table(gl_repos_from_orgs)
})

test_that("`get_repos_from_repos()` queries repos directly by fullpath", {
  mockery::stub(
    gitlab_testhost_priv$get_repos_from_repos,
    "graphql_engine$get_repos_by_fullpath",
    test_mocker$use("gl_repos_by_path")
  )
  mockery::stub(
    gitlab_testhost_priv$get_repos_from_repos,
    "graphql_engine$prepare_repos_table",
    test_mocker$use("gl_repos_table")
  )
  gitlab_testhost_priv$searching_scope <- "repo"
  gitlab_testhost_priv$orgs_repos <- list("mbtests" = "gitstatstesting")
  gl_repos_from_repos <- gitlab_testhost_priv$get_repos_from_repos(
    add_languages = TRUE,
    verbose = FALSE,
    progress = FALSE
  )
  expect_repos_table(gl_repos_from_repos)
  test_mocker$cache(gl_repos_from_repos)
})

test_that("`get_repos_from_repos()` returns NULL when no repos found", {
  mockery::stub(
    gitlab_testhost_priv$get_repos_from_repos,
    "graphql_engine$get_repos_by_fullpath",
    list()
  )
  gitlab_testhost_priv$searching_scope <- "repo"
  gitlab_testhost_priv$orgs_repos <- list("mbtests" = "nonexistent")
  gl_repos_from_repos <- gitlab_testhost_priv$get_repos_from_repos(
    add_languages = TRUE,
    verbose = FALSE,
    progress = FALSE
  )
  expect_null(gl_repos_from_repos)
})

test_that("GitLab Host prints message when turning to REST engine (from orgs)", {
  mockery::stub(
    gitlab_testhost_priv$get_repos_from_orgs,
    "graphql_engine$get_repos_from_org",
    test_mocker$use("gitlab_repos_error")
  )
  mockery::stub(
    gitlab_testhost_priv$get_repos_from_orgs,
    "rest_engine$prepare_repos_table",
    test_mocker$use("gitlab_rest_repos_table")
  )
  gitlab_testhost_priv$searching_scope <- "org"
  expect_snapshot(
    gl_repos_from_orgs <- gitlab_testhost_priv$get_repos_from_orgs(
      add_languages = TRUE,
      verbose = TRUE,
      progress = FALSE
    )
  )
})

test_that("`get_repos_from_repos()` prints proper message", {
  mockery::stub(
    gitlab_testhost_priv$get_repos_from_repos,
    "graphql_engine$get_repos_by_fullpath",
    test_mocker$use("gl_repos_by_path")
  )
  mockery::stub(
    gitlab_testhost_priv$get_repos_from_repos,
    "graphql_engine$prepare_repos_table",
    test_mocker$use("gl_repos_table")
  )
  gitlab_testhost_priv$searching_scope <- "repo"
  gitlab_testhost_priv$orgs_repos <- list("mbtests" = "gitstatstesting")
  expect_snapshot(
    gl_repos_from_repos <- gitlab_testhost_priv$get_repos_from_repos(
      add_languages = TRUE,
      verbose = TRUE,
      progress = FALSE
    )
  )
})

test_that("get_repos_ids", {
  repos_ids <- gitlab_testhost_priv$get_repos_ids(
    search_response = test_fixtures$gitlab_search_response
  )
  expect_type(
    repos_ids,
    "double"
  )
  expect_gt(
    length(repos_ids), 0
  )
})

test_that("parse_search_response works", {
  mockery::stub(
    gitlab_testhost_priv$parse_search_response,
    "api_engine$get_repos_from_org",
    test_mocker$use("gl_repos_from_org")
  )
  gl_repos_raw_output <- gitlab_testhost_priv$parse_search_response(
    search_response = test_fixtures$gitlab_search_response,
    org = "test_group",
    output = "raw",
    verbose = FALSE
  )
  expect_type(
    gl_repos_raw_output,
    "list"
  )
  expect_true(
    all(names(gl_repos_raw_output[[1]]$node) %in% c("repo_id", "repo_name", "repo_path",
                                                    "repo_fullpath",
                                                    "repository", "stars", "forks", "created_at",
                                                    "last_activity_at", "languages", "issues",
                                                    "namespace", "repo_url"))
  )
  test_mocker$cache(gl_repos_raw_output)
})

test_that("GitHost adds `repo_api_url` column to GitLab repos table", {
  repos_table <- test_mocker$use("gl_repos_table")
  gl_repos_table_with_api_url <- gitlab_testhost_priv$add_repo_api_url(repos_table)
  expect_true(all(grepl("gitlab.com/api/v4", gl_repos_table_with_api_url$api_url)))
  test_mocker$cache(gl_repos_table_with_api_url)
})


test_that("add_githost_info adds data on Git platform to repos table", {
  gl_repos_table_with_platform <- gitlab_testhost_priv$add_githost_info(
    repos_table = test_mocker$use("gl_repos_table_with_api_url")
  )
  expect_repos_table(
    gl_repos_table_with_platform,
    with_cols = c("api_url", "githost")
  )
  test_mocker$cache(gl_repos_table_with_platform)
})

test_that("`get_repos_contributors()` adds contributors to repos table", {
  mockery::stub(
    test_rest_gitlab$get_repos_contributors,
    "private$get_contributors_from_repo",
    "Maciej Banas"
  )
  gl_repos_table_full <- test_rest_gitlab$get_repos_contributors(
    test_mocker$use("gl_repos_table_with_platform"),
    progress = FALSE
  )
  expect_repos_table(
    gl_repos_table_full,
    with_cols = c("api_url", "githost", "contributors")
  )
  expect_gt(
    length(gl_repos_table_full$contributors),
    0
  )
  test_mocker$cache(gl_repos_table_full)
})

test_that("`get_repos_data` pulls data from org", {
  if (integration_tests_skipped) {
    mockery::stub(
      gitlab_testhost_priv$get_repos_data,
      "graphql_engine$get_repos_from_org",
      test_mocker$use("gl_repos_from_org")
    )
  }
  gitlab_testhost_priv$searching_scope <- "org"
  gl_repos_data <- gitlab_testhost_priv$get_repos_data(
    org = "mbtests",
    verbose = FALSE
  )
  expect_type(gl_repos_data, "list")
  expect_type(gl_repos_data[["paths"]], "character")
  expect_gt(length(gl_repos_data[["paths"]]), 0)
  test_mocker$cache(gl_repos_data)
})

test_that("`get_repos_data` uses cached data from org", {
  if (integration_tests_skipped) {
    mockery::stub(
      gitlab_testhost_priv$get_repos_data,
      "graphql_engine$get_repos_from_org",
      test_mocker$use("gl_repos_from_org")
    )
  }
  expect_gt(
    length(gitlab_testhost_priv$cached_repos),
    0
  )
  gitlab_testhost_priv$searching_scope <- "org"
  expect_snapshot(
    gl_repos_data <- gitlab_testhost_priv$get_repos_data(
      org = "mbtests",
      verbose = TRUE
    )
  )
  expect_type(gl_repos_data, "list")
  expect_type(gl_repos_data[["paths"]], "character")
  expect_gt(length(gl_repos_data[["paths"]]), 0)
})

test_that("`get_repos_data` pulls data from repos", {
  mockery::stub(
    gitlab_testhost_priv$get_repos_data,
    "graphql_engine$get_repos_from_org",
    test_mocker$use("gl_repos_from_org")
  )
  gitlab_testhost_priv$searching_scope <- "repo"
  gitlab_testhost_priv$cached_repos <- list()
  gl_repos_data <- gitlab_testhost_priv$get_repos_data(
    org = "mbtests",
    repos = "gitstatstesting",
    verbose = FALSE
  )
  expect_type(gl_repos_data, "list")
  expect_type(gl_repos_data[["paths"]], "character")
  expect_gt(length(gl_repos_data[["paths"]]), 0)
})

test_that("get_repos_data turns to REST if GraphQL fails with error", {
  mockery::stub(
    gitlab_testhost_priv$get_repos_data,
    "graphql_engine$get_repos_from_org",
    test_mocker$use("gitlab_repos_error")
  )
  mockery::stub(
    gitlab_testhost_priv$get_repos_data,
    "rest_engine$get_repos_from_org",
    test_mocker$use("gitlab_rest_repos_from_org_raw")
  )
  gitlab_testhost_priv$searching_scope <- "org"
  gl_repos_data <- gitlab_testhost_priv$get_repos_data(
    org = "test_org",
    verbose = FALSE
  )
  expect_type(gl_repos_data, "list")
  expect_type(gl_repos_data[["paths"]], "character")
  expect_gt(length(gl_repos_data[["paths"]]), 0)
})

test_that("get_repos_data prints message when turns to REST engine", {
  mockery::stub(
    gitlab_testhost_priv$get_repos_data,
    "graphql_engine$get_repos_from_org",
    test_mocker$use("gitlab_repos_error")
  )
  mockery::stub(
    gitlab_testhost_priv$get_repos_data,
    "rest_engine$get_repos_from_org",
    test_mocker$use("gitlab_rest_repos_from_org_raw")
  )
  gitlab_testhost_priv$searching_scope <- "org"
  gitlab_testhost_priv$cached_repos <- list()
  expect_snapshot(
    gl_repos_data <- gitlab_testhost_priv$get_repos_data(
      org = "test_org",
      verbose = TRUE
    )
  )
})

# ---- commit_sha fallback for archived projects ----

test_that("GraphQL engine returns NA commit_sha for archived projects with null lastCommit", {
  repos_with_archived <- list(
    gitlab_project_node,
    gitlab_archived_project_node
  )
  gl_repos_table <- test_graphql_gitlab$prepare_repos_table(
    repos_list = repos_with_archived,
    org = "mbtests"
  )
  expect_repos_table(gl_repos_table)
  expect_equal(gl_repos_table$commit_sha[1], "1a2bc3d4e5")
  expect_true(is.na(gl_repos_table$commit_sha[2]))
})

test_that("`get_commit_sha_from_branch()` retrieves SHA from branches API", {
  mockery::stub(
    test_rest_gitlab$get_commit_sha_from_branch,
    "self$response",
    test_fixtures$gitlab_branch_response
  )
  commit_sha <- test_rest_gitlab$get_commit_sha_from_branch(
    project_id = "99999999",
    default_branch = "main"
  )
  expect_equal(commit_sha, "abcdef1234567890")
  test_mocker$cache(commit_sha)
})

test_that("`get_commit_sha_from_branch()` returns NA when branch is empty", {
  sha <- test_rest_gitlab$get_commit_sha_from_branch(
    project_id = "99999999",
    default_branch = ""
  )
  expect_true(is.na(sha))
})

test_that("`get_commit_sha_from_branch()` returns NA when branch is NULL", {
  sha <- test_rest_gitlab$get_commit_sha_from_branch(
    project_id = "99999999",
    default_branch = NULL
  )
  expect_true(is.na(sha))
})

test_that("`get_commit_sha_from_branch()` returns NA on API error", {
  rest_error_response <- list("message" = "404 Not Found")
  class(rest_error_response) <- c("rest_error", "404_not_found", class(rest_error_response))
  mockery::stub(
    test_rest_gitlab$get_commit_sha_from_branch,
    "self$response",
    rest_error_response
  )
  sha <- test_rest_gitlab$get_commit_sha_from_branch(
    project_id = "99999999",
    default_branch = "main"
  )
  expect_true(is.na(sha))
})

test_that("get_commit_sha works on host level", {
  gitlab_testhost_fill <- create_gitlab_testhost(
    orgs = "mbtests",
    mode = "private"
  )
  mockery::stub(
    gitlab_testhost_fill$get_commit_sha,
    "rest_engine$get_commit_sha_from_branch",
    test_mocker$use("commit_sha")
  )
  commit_sha <- gitlab_testhost_fill$get_commit_sha(
    project_id = "99999999",
    default_branch = "main"
  )
  expect_equal(commit_sha, "abcdef1234567890")
})

test_that("fill_repos_commit_sha() returns empty table",{
  gitlab_testhost_fill <- create_gitlab_testhost(
    orgs = "mbtests",
    mode = "private"
  )
  repos_table <- data.frame()
  expect_equal(
    gitlab_testhost_fill$fill_repos_commit_sha(repos_table, verbose = FALSE),
    data.frame()
  )
})

test_that("`fill_repos_commit_sha()` fills missing commit_sha via REST", {
  gitlab_testhost_fill <- create_gitlab_testhost(
    orgs = "mbtests",
    mode = "private"
  )
  repos_table <- data.frame(
    repo_id = c("61399846", "99999999"),
    repo_name = c("gitstatstesting", "archived-project"),
    repo_fullpath = c("mbtests/gitstatstesting", "mbtests/archived-project"),
    default_branch = c("main", "main"),
    stars = c(8L, 2L),
    forks = c(3L, 0L),
    created_at = as.POSIXct(c("2023-09-18", "2022-01-10")),
    last_activity_at = as.POSIXct(c("2024-09-18", "2023-06-15")),
    languages = c("Python, R", "R"),
    issues_open = c(2L, 0L),
    issues_closed = c(8L, 3L),
    organization = c("mbtests", "mbtests"),
    repo_url = c("https://gitlab.com/mbtests/gitstatstesting",
                 "https://gitlab.com/mbtests/archived-project"),
    commit_sha = c("1a2bc3d4e5", NA_character_),
    stringsAsFactors = FALSE
  )
  mockery::stub(
    gitlab_testhost_fill$fill_repos_commit_sha,
    "private$get_commit_sha",
    test_mocker$use("commit_sha")
  )
  expect_snapshot(
    repos_commit_sha <- gitlab_testhost_fill$fill_repos_commit_sha(repos_table, verbose = TRUE)
  )
  expect_equal(repos_commit_sha$commit_sha[1], "1a2bc3d4e5")
  expect_equal(repos_commit_sha$commit_sha[2], "abcdef1234567890")
  test_mocker$cache(repos_commit_sha)
})

test_that("`fill_repos_commit_sha()` skips repos with empty default_branch", {
  gitlab_testhost_fill <- create_gitlab_testhost(
    orgs = "mbtests",
    mode = "private"
  )
  repos_table <- data.frame(
    repo_id = c("99999999"),
    repo_name = c("empty-repo"),
    repo_fullpath = c("mbtests/empty-repo"),
    default_branch = c(""),
    stars = 0L,
    forks = 0L,
    created_at = as.POSIXct("2022-01-10"),
    last_activity_at = as.POSIXct("2023-06-15"),
    languages = "",
    issues_open = 0L,
    issues_closed = 0L,
    organization = "mbtests",
    repo_url = "https://gitlab.com/mbtests/empty-repo",
    commit_sha = NA_character_,
    stringsAsFactors = FALSE
  )
  result <- gitlab_testhost_fill$fill_repos_commit_sha(repos_table, verbose = FALSE)
  expect_true(is.na(result$commit_sha[1]))
})

test_that("get_all_repos() works", {
  gitlab_testhost_fill <- create_gitlab_testhost(
    orgs = "mbtests",
    mode = "private"
  )
  mockery::stub(
    gitlab_testhost_fill$get_all_repos,
    "private$get_repos_from_orgs",
    test_mocker$use("gl_repos_from_orgs")
  )
  mockery::stub(
    gitlab_testhost_fill$get_all_repos,
    "private$get_repos_from_repos",
    test_mocker$use("gl_repos_from_repos")
  )
  mockery::stub(
    gitlab_testhost_fill$get_all_repos,
    "private$fill_repos_commit_sha",
    test_mocker$use("repos_commit_sha")
  )
  gitlab_repos <- gitlab_testhost_fill$get_all_repos(add_languages = TRUE, fill_empty_sha = TRUE)
  expect_repos_table(gitlab_repos)
  expect_equal(gitlab_repos$commit_sha[1], "1a2bc3d4e5")
  expect_equal(gitlab_repos$commit_sha[2], "abcdef1234567890")
})

# ---- EngineGraphQLGitLab: get_repo_name_from_url ----

test_that("`get_repo_name_from_url()` extracts repo name from URL", {
  expect_equal(
    test_graphql_gitlab_priv$get_repo_name_from_url(
      "https://gitlab.com/mbtests/gitstatstesting"
    ),
    "gitstatstesting"
  )
})

test_that("`get_repo_name_from_url()` handles nested group paths", {
  expect_equal(
    test_graphql_gitlab_priv$get_repo_name_from_url(
      "https://gitlab.com/group/subgroup/my-repo"
    ),
    "my-repo"
  )
})

# ---- EngineGraphQLGitLab: prepare_files_table_row ----

test_that("`prepare_files_table_row()` builds files data.frame from project", {
  project <- test_fixtures$gitlab_file_repo_response$data$project
  files_row <- test_graphql_gitlab_priv$prepare_files_table_row(
    project = project,
    org = "mbtests"
  )
  expect_s3_class(files_row, "data.frame")
  expect_gt(nrow(files_row), 0)
  expect_in(c("repo_name", "file_path", "file_content", "repo_url"), names(files_row))
  expect_equal(files_row$organization[1], "mbtests")
})

# ---- EngineGraphQLGitLab: set_owner_type ----

test_that("`set_owner_type()` identifies organization (group) type", {
  gl_group_response <- list(
    "data" = list(
      "user" = NULL,
      "group" = list("__typename" = "Group", "fullPath" = "mbtests")
    )
  )
  mockery::stub(
    test_graphql_gitlab$set_owner_type,
    "self$gql_response",
    gl_group_response
  )
  result <- test_graphql_gitlab$set_owner_type(
    owners = "mbtests_org_test",
    verbose = FALSE
  )
  expect_equal(attr(result[[1]], "type"), "organization")
})

test_that("`set_owner_type()` identifies user type", {
  gl_user_response <- list(
    "data" = list(
      "user" = list("__typename" = "User", "username" = "test_user"),
      "group" = NULL
    )
  )
  mockery::stub(
    test_graphql_gitlab$set_owner_type,
    "self$gql_response",
    gl_user_response
  )
  result <- test_graphql_gitlab$set_owner_type(
    owners = "test_user_type_test",
    verbose = FALSE
  )
  expect_equal(attr(result[[1]], "type"), "user")
})

test_that("`set_owner_type()` returns 'not found' when owner does not exist", {
  mockery::stub(
    test_graphql_gitlab$set_owner_type,
    "self$gql_response",
    list("data" = list("user" = NULL, "group" = NULL))
  )
  result <- test_graphql_gitlab$set_owner_type(
    owners = "nonexistent_owner_test",
    verbose = FALSE
  )
  expect_equal(attr(result[[1]], "type"), "not found")
})

# ---- GitHostGitLab: get_repo_url_from_response with type "api" ----

test_that("`get_repo_url_from_response()` returns api URLs", {
  gl_repo_api_urls <- gitlab_testhost_priv$get_repo_url_from_response(
    search_response = test_mocker$use("gl_repos_raw_output"),
    type = "api",
    progress = FALSE
  )
  expect_gt(length(gl_repo_api_urls), 0)
  expect_type(gl_repo_api_urls, "character")
  expect_true(all(grepl("api", gl_repo_api_urls)))
})

# ---- GitHostGitLab: check_if_public ----

test_that("`check_if_public()` sets TRUE for public gitlab.com", {
  gitlab_testhost_priv$check_if_public(NULL)
  expect_true(gitlab_testhost_priv$is_public)
  gitlab_testhost_priv$check_if_public("https://gitlab.com")
  expect_true(gitlab_testhost_priv$is_public)
})

test_that("`check_if_public()` sets FALSE for custom host", {
  gitlab_testhost_priv$check_if_public("https://internal-gitlab.company.com")
  expect_false(gitlab_testhost_priv$is_public)
  # Reset to default
  gitlab_testhost_priv$check_if_public(NULL)
})

