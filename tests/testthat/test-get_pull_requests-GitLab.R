test_that("pr_by_repo GitLab query is built properly", {
  gl_pr_from_repo_query <-
    test_gqlquery_gl$pull_requests_from_repo()
  expect_snapshot(
    gl_pr_from_repo_query
  )
})

test_that("`get_pr_page_from_repo()` pulls pr page from repository", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_gitlab_priv$get_pr_page_from_repo,
      "self$gql_response",
      test_fixtures_pr$gitlab_graphql_pr_response
    )
    org <- "test_org"
    repo <- "TestRepo"
  } else {
    org <- "mbtests"
    repo <- "gitstatstesting"
  }
  gl_pr_page <- test_graphql_gitlab_priv$get_pr_page_from_repo(
    org = org,
    repo = repo
  )

  expect_pr_gql_response(
    gl_pr_page$data$project$mergeRequests$edges[[1]]
  )
  test_mocker$cache(gl_pr_page)
})

test_that("`get_pr_from_one_repo()` prepares formatted list", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_gitlab_priv$get_pr_from_one_repo,
      "private$get_pr_page_from_repo",
      test_mocker$use("gl_pr_page")
    )
  }
  gl_pr_from_repo <- test_graphql_gitlab_priv$get_pr_from_one_repo(
    org = "mbtests",
    repo = "gitstatstesting"
  )
  expect_pr_full_list(
    gl_pr_from_repo
  )
  test_mocker$cache(gl_pr_from_repo)
})

test_that("`get_pr_from_repos()` pulls pr from repos", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_gitlab$get_pr_from_repos,
      "private$get_pr_from_one_repo",
      test_mocker$use("gl_pr_from_repo")
    )
  }
  pr_from_repos <- test_graphql_gitlab$get_pr_from_repos(
    org = "mbtests",
    repo = c("gitstatstesting", "graphql_tests")
  )
  expect_pr_full_list(
    pr_from_repos[[1]]
  )
  test_mocker$cache(pr_from_repos)
})

test_that("`prepare_pr_table()` prepares pr table", {
  gl_pr_table <- test_graphql_gitlab$prepare_pr_table(
    repos_list_with_pr = test_mocker$use("pr_from_repos"),
    org = "mbtests"
  )
  expect_pr_table(
    gl_pr_table
  )
  test_mocker$cache(gl_pr_table)
})

test_that("get_pr_from_orgs for GitLab works", {
  if (integration_tests_skipped) {
    mockery::stub(
      gitlab_testhost_priv$get_pr_from_orgs,
      "graphql_engine$prepare_pr_table",
      test_mocker$use("gl_pr_table")
    )
    mockery::stub(
      gitlab_testhost_priv$get_pr_from_orgs,
      "private$get_repos_names",
      test_mocker$use("gl_repos_names")
    )
  }
  gitlab_testhost_priv$searching_scope <- "org"
  gl_pr_from_orgs <- gitlab_testhost_priv$get_pr_from_orgs(
    verbose = FALSE,
    progress = FALSE
  )
  expect_pr_table(
    gl_pr_from_orgs
  )
  test_mocker$cache(gl_pr_from_orgs)
})

test_that("get_pr_from_repos for GitLab works", {
  if (integration_tests_skipped) {
    mockery::stub(
      gitlab_testhost_priv$get_pr_from_repos,
      "graphql_engine$prepare_pr_table",
      test_mocker$use("gl_pr_table")
    )
    gitlab_testhost_priv$orgs_repos <- list("test_org" = "TestRepo")
    test_org <- "test_org"
    attr(test_org, "type") <- "organization"
    mockery::stub(
      gitlab_testhost_priv$get_pr_from_repos,
      "graphql_engine$set_owner_type",
      test_org
    )
  } else {
    gitlab_testhost_priv$orgs_repos <- list("mbtests" = "gitstatstesting")
  }
  gitlab_testhost_priv$searching_scope <- "repo"
  gl_pr_from_repos <- gitlab_testhost_priv$get_pr_from_repos(
    verbose = FALSE,
    progress = FALSE
  )
  expect_pr_table(
    gl_pr_from_repos
  )
  test_mocker$cache(gl_pr_from_repos)
})

test_that("`get_pull_requests()` retrieves pr in the table format in a certain time span", {
  mockery::stub(
    gitlab_testhost$get_pull_requests,
    "private$get_pr_from_orgs",
    test_mocker$use("gl_pr_from_orgs")
  )
  mockery::stub(
    gitlab_testhost$get_pull_requests,
    "private$get_pr_from_repos",
    test_mocker$use("gl_pr_from_repos")
  )
  gl_pr_table <- gitlab_testhost$get_pull_requests(
    since = "2026-02-01",
    until = "2026-02-28",
    verbose = FALSE,
    progress = FALSE
  )
  expect_pr_table(
    gl_pr_table
  )
  gl_pr_table_shorter <- gitlab_testhost$get_pull_requests(
    since = "2026-02-01",
    until = "2026-02-24",
    verbose = FALSE,
    progress = FALSE
  )
  expect_true(
    nrow(gl_pr_table) > nrow(gl_pr_table_shorter)
  )
  expect_true(
    max(gl_pr_table_shorter$created_at) <= "2026-02-28"
  )
  expect_true(
    min(gl_pr_table_shorter$created_at) >= "2026-02-01"
  )
  test_mocker$cache(gl_pr_table)
})

test_that("`get_pull_requests()` retrieves open pr in the table format in a certain time span", {
  mockery::stub(
    gitlab_testhost$get_pull_requests,
    "private$get_pr_from_orgs",
    test_mocker$use("gl_pr_from_orgs")
  )
  mockery::stub(
    gitlab_testhost$get_pull_requests,
    "private$get_pr_from_repos",
    test_mocker$use("gl_pr_from_repos")
  )
  gl_open_pr_table <- gitlab_testhost$get_pull_requests(
    since = "2026-02-01",
    until = "2026-02-28",
    state = "open",
    verbose = FALSE,
    progress = FALSE
  )
  expect_pr_table(
    gl_open_pr_table
  )
  expect_true(
    all(gl_open_pr_table$state == "open")
  )
  gl_closed_pr_table <- gitlab_testhost$get_pull_requests(
    since = "2026-02-01",
    until = "2026-02-28",
    state = "closed",
    verbose = FALSE,
    progress = FALSE
  )
  expect_pr_table(
    gl_closed_pr_table
  )
  expect_true(
    all(gl_closed_pr_table$state == "closed")
  )
})
