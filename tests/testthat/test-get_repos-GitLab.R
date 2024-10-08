test_that("repos queries are built properly", {
  gl_repos_by_org_query <-
    test_gqlquery_gl$repos_by_org()
  expect_snapshot(
    gl_repos_by_org_query
  )
  test_mocker$cache(gl_repos_by_org_query)
})

test_that("GitLab repos response to query works", {
  gl_repos_by_org_gql_response <- test_graphql_gitlab$gql_response(
    gql_query = test_mocker$use("gl_repos_by_org_query"),
    vars = list(org = "mbtests")
  )
  expect_gl_repos_gql_response(
    gl_repos_by_org_gql_response
  )
  test_mocker$cache(gl_repos_by_org_gql_response)
})

test_that("`get_repos_page()` pulls repos page from GitLab group", {
  mockery::stub(
    test_graphql_gitlab_priv$get_repos_page,
    "self$gql_response",
    test_mocker$use("gl_repos_by_org_gql_response")
  )
  gl_repos_page <- test_graphql_gitlab_priv$get_repos_page(
    org = "mbtests"
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
    org = "mbtests"
  )
  expect_equal(
    names(gl_repos_from_org[[1]]$node),
    c(
      "repo_id", "repo_name", "repo_path", "repository",
      "stars", "forks", "created_at", "last_activity_at",
      "languages", "issues", "group", "repo_url"
    )
  )
  test_mocker$cache(gl_repos_from_org)
})

test_that("`get_repos_from_org()` does not fail when GraphQL response is not complete", {
  mockery::stub(
    test_graphql_gitlab$get_repos_from_org,
    "private$get_repos_page",
    test_fixtures$empty_gql_response
  )
  gl_repos_from_org <- test_graphql_gitlab$get_repos_from_org(
    org = "mbtests"
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
    org = "mbtests"
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

test_that("`map_search_into_repos()` works", {
  gl_search_response <- test_fixtures$gitlab_search_response
  test_mocker$cache(gl_search_response)
  gl_search_repos_by_code <- test_rest_gitlab_priv$map_search_into_repos(
    gl_search_response,
    progress = FALSE
  )
  expect_gl_repos_rest_response(
    gl_search_repos_by_code
  )
  test_mocker$cache(gl_search_repos_by_code)
})

test_that("`pull_repos_languages` works", {
  repos_list <- test_mocker$use("gl_search_repos_by_code")
  repos_list[[1]]$id <- "45300912"
  suppressMessages(
    repos_list_with_languages <- test_rest_gitlab_priv$pull_repos_languages(
      repos_list = repos_list,
      progress   = FALSE
    )
  )
  purrr::walk(repos_list_with_languages, ~ expect_list_contains(., "languages"))
})

test_that("`prepare_repos_table()` prepares repos table", {
  gl_repos_table <- gitlab_testhost_priv$prepare_repos_table_from_graphql(
    repos_list = test_mocker$use("gl_repos_from_org")
  )
  expect_repos_table(
    gl_repos_table
  )
  test_mocker$cache(gl_repos_table)
})

test_that("GitHost adds `repo_api_url` column to GitLab repos table", {
  repos_table <- test_mocker$use("gl_repos_table")
  gl_repos_table_with_api_url <- gitlab_testhost_priv$add_repo_api_url(repos_table)
  expect_true(all(grepl("gitlab.com/api/v4", gl_repos_table_with_api_url$api_url)))
  test_mocker$cache(gl_repos_table_with_api_url)
})

test_that("`tailor_repos_response()` tailors precisely `repos_list`", {
  gl_repos_by_code <- test_mocker$use("gl_search_repos_by_code")

  gl_repos_by_code_tailored <-
    gitlab_testhost_priv$tailor_repos_response(gl_repos_by_code)

  gl_repos_by_code_tailored %>%
    expect_type("list") %>%
    expect_length(length(gl_repos_by_code))

  expect_list_contains_only(
    gl_repos_by_code_tailored[[1]],
    c(
      "repo_id", "repo_name", "created_at", "last_activity_at",
      "forks", "stars", "languages", "issues_open",
      "issues_closed", "organization"
    )
  )
  expect_lt(
    length(gl_repos_by_code_tailored[[1]]),
    length(gl_repos_by_code[[1]])
  )
  test_mocker$cache(gl_repos_by_code_tailored)
})

test_that("GitHost prepares table from GitLab repositories response", {
  expect_snapshot(
    gl_repos_by_code_table <- gitlab_testhost_priv$prepare_repos_table_from_rest(
      repos_list = test_mocker$use("gl_repos_by_code_tailored")
    )
  )
  expect_repos_table(
    gl_repos_by_code_table
  )
  gl_repos_by_code_table <- gitlab_testhost_priv$add_repo_api_url(gl_repos_by_code_table)
  test_mocker$cache(gl_repos_by_code_table)
})

test_that("`get_repos_issues()` adds issues to repos table", {
  gl_repos_by_code_table <- test_mocker$use("gl_repos_by_code_table")
  gl_repos_by_code_table <- test_rest_gitlab$get_repos_issues(
    gl_repos_by_code_table,
    progress = FALSE
  )
  expect_gt(
    length(gl_repos_by_code_table$issues_open),
    0
  )
  expect_gt(
    length(gl_repos_by_code_table$issues_closed),
    0
  )
  test_mocker$cache(gl_repos_by_code_table)
})

test_that("`get_repos_contributors()` adds contributors to repos table", {
  gl_repos_table_with_contributors <- test_rest_gitlab$get_repos_contributors(
    test_mocker$use("gl_repos_table_with_api_url"),
    progress = FALSE
  )
  expect_repos_table(
    gl_repos_table_with_contributors,
    with_cols = c("api_url", "contributors")
  )
  expect_gt(
    length(gl_repos_table_with_contributors$contributors),
    0
  )
  test_mocker$cache(gl_repos_table_with_contributors)
})
