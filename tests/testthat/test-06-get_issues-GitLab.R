test_that("issues_by_repo GitLab query is built properly", {
  gl_issues_from_repo_query <-
    test_gqlquery_gl$issues_from_repo()
  expect_snapshot(
    gl_issues_from_repo_query
  )
})

test_that("issues page is pulled from repository", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_gitlab_priv$get_issues_page_from_repo,
      "self$gql_response",
      test_fixtures$gitlab_graphql_issues_response
    )
    org <- "test_org"
    repo <- "TestRepo"
  } else {
    org <- "mbtests"
    repo <- "gitstatstesting"
  }
  issues_page <- test_graphql_gitlab_priv$get_issues_page_from_repo(
    org = org,
    repo = repo
  )
  expect_gitlab_issues_page(issues_page)
  test_mocker$cache(issues_page)
})

test_that("`get_issues_from_one_repo()` prepares formatted list", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_gitlab_priv$get_issues_from_one_repo,
      "private$get_issues_page_from_repo",
      test_mocker$use("issues_page")
    )
  }
  issues_from_repo <- test_graphql_gitlab_priv$get_issues_from_one_repo(
    org = "mbtests",
    repo = "gitstatstesting"
  )
  expect_issues_full_list(
    issues_from_repo
  )
  test_mocker$cache(issues_from_repo)
})

test_that("`get_issues_from_repos()` pulls issues from repos", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_gitlab$get_issues_from_repos,
      "private$get_issues_from_one_repo",
      test_mocker$use("issues_from_repo")
    )
  }
  issues_from_repos <- test_graphql_gitlab$get_issues_from_repos(
    org = "mbtests",
    repo = c("gitstatstesting", "graphql_tests"),
    progress = FALSE
  )
  expect_issues_full_list(
    issues_from_repos[[1]]
  )
  test_mocker$cache(issues_from_repos)
})

test_that("`prepare_issues_table()` prepares issues table", {
  gl_issues_table <- test_graphql_gitlab$prepare_issues_table(
    repos_list_with_issues = test_mocker$use("issues_from_repos"),
    org = "r-world-devs"
  )
  expect_issues_table(
    gl_issues_table
  )
  test_mocker$cache(gl_issues_table)
})

test_that("get_issues_from_orgs for GitLab works", {
  if (integration_tests_skipped) {
    mockery::stub(
      gitlab_testhost_priv$get_issues_from_orgs,
      "graphql_engine$prepare_issues_table",
      test_mocker$use("gl_issues_table")
    )
    mockery::stub(
      gitlab_testhost_priv$get_issues_from_orgs,
      "private$get_repos_names",
      test_mocker$use("gl_repos_names")
    )
  }
  gitlab_testhost_priv$searching_scope <- "org"
  gl_issues_from_orgs <- gitlab_testhost_priv$get_issues_from_orgs(
    verbose = FALSE,
    progress = FALSE
  )
  expect_issues_table(
    gl_issues_from_orgs
  )
  test_mocker$cache(gl_issues_from_orgs)
})

test_that("get_issues_from_repos for GitLab works", {
  if (integration_tests_skipped) {
    mockery::stub(
      gitlab_testhost_priv$get_issues_from_repos,
      "graphql_engine$prepare_issues_table",
      test_mocker$use("gl_issues_table")
    )
    gitlab_testhost_priv$orgs_repos <- list("test_org" = "TestRepo")
    test_org <- "test_org"
    attr(test_org, "type") <- "organization"
    mockery::stub(
      gitlab_testhost_priv$get_issues_from_repos,
      "graphql_engine$set_owner_type",
      test_org
    )
  } else {
    gitlab_testhost_priv$orgs_repos <- list("mbtests" = "gitstatstesting")
  }
  gitlab_testhost_priv$searching_scope <- "repo"
  gl_issues_from_repos <- gitlab_testhost_priv$get_issues_from_repos(
    verbose = FALSE,
    progress = FALSE
  )
  expect_issues_table(
    gl_issues_from_repos
  )
  test_mocker$cache(gl_issues_from_repos)
})

test_that("`get_issues()` retrieves issues in the table format in a certain time span", {
  mockery::stub(
    gitlab_testhost$get_issues,
    "private$get_issues_from_orgs",
    test_mocker$use("gl_issues_from_orgs")
  )
  mockery::stub(
    gitlab_testhost$get_issues,
    "private$get_issues_from_repos",
    test_mocker$use("gl_issues_from_repos")
  )
  gl_issues_table <- gitlab_testhost$get_issues(
    since = "2023-01-01",
    until = "2025-03-06",
    verbose = FALSE,
    progress = FALSE
  )
  expect_issues_table(
    gl_issues_table
  )
  gl_issues_table_shorter <- gitlab_testhost$get_issues(
    since = "2023-02-01",
    until = "2024-01-01",
    verbose = FALSE,
    progress = FALSE
  )
  expect_true(
    nrow(gl_issues_table) > nrow(gl_issues_table_shorter)
  )
  expect_true(
    max(gl_issues_table_shorter$created_at) <= "2024-01-01"
  )
  expect_true(
    min(gl_issues_table_shorter$created_at) >= "2023-02-01"
  )
  test_mocker$cache(gl_issues_table)
})

test_that("`get_issues()` retrieves open issues in the table format in a certain time span", {
  mockery::stub(
    gitlab_testhost$get_issues,
    "private$get_issues_from_orgs",
    test_mocker$use("gl_issues_from_orgs")
  )
  mockery::stub(
    gitlab_testhost$get_issues,
    "private$get_issues_from_repos",
    test_mocker$use("gl_issues_from_repos")
  )
  gl_open_issues_table <- gitlab_testhost$get_issues(
    since = "2023-01-01",
    state = "open",
    verbose = FALSE,
    progress = FALSE
  )
  expect_issues_table(
    gl_open_issues_table
  )
  expect_true(
    all(gl_open_issues_table$state == "open")
  )
  gl_closed_issues_table <- gitlab_testhost$get_issues(
    since = "2023-01-01",
    state = "closed",
    verbose = FALSE,
    progress = FALSE
  )
  expect_issues_table(
    gl_closed_issues_table
  )
  expect_true(
    all(gl_closed_issues_table$state == "closed")
  )
})
