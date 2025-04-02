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

test_that("`get_repos_page()` pulls repos page from GitLab group", {
  mockery::stub(
    test_graphql_gitlab_priv$get_repos_page,
    "self$gql_response",
    test_fixtures$gitlab_repos_by_org_response
  )
  gl_repos_page <- test_graphql_gitlab_priv$get_repos_page(
    org = "test_org",
    type = "organization"
  )
  expect_gl_repos_gql_response(
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
    org = "test_org",
    type = "organization"
  )
  expect_equal(
    names(gl_repos_from_org[[1]]$node),
    c(
      "repo_id", "repo_name", "repo_path", "repository",
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
  expect_gl_repos_gql_response(
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
    org  = "test_user",
    type = "user"
  )
  expect_equal(
    names(gl_repos_from_user[[1]]$node),
    c(
      "repo_id", "repo_name", "repo_path", "repository",
      "stars", "forks", "created_at", "last_activity_at",
      "languages", "issues", "namespace", "repo_url"
    )
  )
  test_mocker$cache(gl_repos_from_user)
})

test_that("`get_repos_from_org()` does not fail when GraphQL response is not complete", {
  mockery::stub(
    test_graphql_gitlab$get_repos_from_org,
    "private$get_repos_page",
    test_fixtures$empty_gql_response
  )
  gl_repos_from_org <- test_graphql_gitlab$get_repos_from_org(
    org = "test_org",
    type = "organization"
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
    org = "test_org",
    type = "organization"
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

test_that("`get_repos_languages()` works", {
  repos_list <- test_mocker$use("gl_repos_from_org")
  repos_list[[1]]$id <- "45300912"
  mockery::stub(
    test_rest_gitlab_priv$get_repos_languages,
    "self$response",
    test_fixtures$gitlab_languages_response
  )
  gl_repos_list_with_languages <- test_rest_gitlab_priv$get_repos_languages(
    repos_list = repos_list,
    progress   = FALSE
  )
  purrr::walk(gl_repos_list_with_languages, ~ expect_list_contains(., "languages"))
  expect_equal(gl_repos_list_with_languages[[1]]$languages, c("Python", "R"))
  test_mocker$cache(gl_repos_list_with_languages)
})

test_that("`prepare_repos_table()` prepares repos table", {
  gl_repos_table <- test_graphql_gitlab$prepare_repos_table(
    repos_list = test_mocker$use("gl_repos_from_org"),
    org = "test_group"
  )
  expect_repos_table(
    gl_repos_table
  )
  test_mocker$cache(gl_repos_table)
})

test_that("get_repos_from_org prints proper message", {
  mockery::stub(
    gitlab_testhost_priv$get_repos_from_orgs,
    "graphql_engine$get_repos_from_org",
    test_mocker$use("gl_repos_from_org")
  )
  gitlab_testhost_priv$orgs <- "test_group"
  expect_snapshot(
    gl_repos_from_orgs <- gitlab_testhost_priv$get_repos_from_orgs(
      verbose = TRUE,
      progress = FALSE
    )
  )
  expect_repos_table(
    gl_repos_from_orgs
  )
  test_mocker$cache(gl_repos_from_orgs)
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
    "graphql_engine$get_repos_from_org",
    test_mocker$use("gl_repos_from_org")
  )
  gl_repos_raw_output <- gitlab_testhost_priv$parse_search_response(
    search_response = test_fixtures$gitlab_search_response,
    output = "raw"
  )
  expect_type(
    gl_repos_raw_output,
    "list"
  )
  expect_true(
    all(names(gl_repos_raw_output[[1]]$node) %in% c("repo_id", "repo_name", "repo_path",
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


test_that("add_platform adds data on Git platform to repos table", {
  gl_repos_table_with_platform <- gitlab_testhost_priv$add_platform(
    repos_table = test_mocker$use("gl_repos_table_with_api_url")
  )
  expect_repos_table(
    gl_repos_table_with_platform,
    with_cols = c("api_url", "platform")
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
    with_cols = c("api_url", "platform", "contributors")
  )
  expect_gt(
    length(gl_repos_table_full$contributors),
    0
  )
  test_mocker$cache(gl_repos_table_full)
})
