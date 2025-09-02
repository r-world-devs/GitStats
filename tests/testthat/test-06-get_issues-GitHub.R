test_that("issues_by_repo GitHub query is built properly", {
  gh_issues_from_repo_query <-
    test_gqlquery_gh$issues_from_repo()
  expect_snapshot(
    gh_issues_from_repo_query
  )
})

test_that("issues page is pulled from repository", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_github_priv$get_issues_page_from_repo,
      "self$gql_response",
      test_fixtures$github_graphql_issues_response
    )
    org <- "test_org"
    repo <- "TestRepo"
  } else {
    org <- "r-world-devs"
    repo <- "GitStats"
  }
  issues_page <- test_graphql_github_priv$get_issues_page_from_repo(
    org = org,
    repo = repo
  )
  expect_github_issues_page(issues_page)
  test_mocker$cache(issues_page)
})

test_that("issues page works when encounters error", {
  response_error <- ""
  class(response_error) <- "graphql_error"
  mockery::stub(
    test_graphql_github_priv$get_issues_page_from_repo,
    "self$gql_response",
    response_error
  )
  org <- "test_org"
  repo <- "TestRepo"
  expect_no_error(
    issues_page <- test_graphql_github_priv$get_issues_page_from_repo(
      org = org,
      repo = repo
    )
  )
})


test_that("issues page with cursor is pulled from repository", {
  if (!integration_tests_skipped) {
    issues_page <- test_graphql_github_priv$get_issues_page_from_repo(
      org = "r-world-devs",
      repo = "GitStats",
      issues_cursor = "Y3Vyc29yOnYyOpK5MjAyNC0xMS0wN1QxMzowNTowOSswMTowMM6dZ-dm"
    )
    expect_github_issues_page(issues_page)
  }
})

test_that("`get_issues_from_one_repo()` prepares formatted list", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_github_priv$get_issues_from_one_repo,
      "private$get_issues_page_from_repo",
      test_mocker$use("issues_page")
    )
  }
  issues_from_repo <- test_graphql_github_priv$get_issues_from_one_repo(
    org = "r-world-devs",
    repo = "GitStats"
  )
  expect_issues_full_list(
    issues_from_repo
  )
  test_mocker$cache(issues_from_repo)
})

test_that("`get_issues_from_repos()` pulls issues from repos", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_github$get_issues_from_repos,
      "private$get_issues_from_one_repo",
      test_mocker$use("issues_from_repo")
    )
  }
  issues_from_repos <- test_graphql_github$get_issues_from_repos(
    org = "r-world-devs",
    repo = c("GitStats", "GitAI"),
    progress = FALSE
  )
  expect_issues_full_list(
    issues_from_repos[[1]]
  )
  test_mocker$cache(issues_from_repos)
})

test_that("`prepare_issues_table()` prepares issues table", {
  gh_issues_table <- test_graphql_github$prepare_issues_table(
    repos_list_with_issues = test_mocker$use("issues_from_repos"),
    org = "r-world-devs"
  )
  expect_issues_table(
    gh_issues_table
  )
  test_mocker$cache(gh_issues_table)
})

test_that("get_issues_from_orgs for GitHub works", {
  if (integration_tests_skipped) {
    mockery::stub(
      github_testhost_priv$get_issues_from_orgs,
      "graphql_engine$prepare_issues_table",
      test_mocker$use("gh_issues_table")
    )
    mockery::stub(
      github_testhost_priv$get_issues_from_orgs,
      "private$get_repos_names",
      test_mocker$use("gh_repos_names")
    )
  }
  github_testhost_priv$searching_scope <- "org"
  gh_issues_from_orgs <- github_testhost_priv$get_issues_from_orgs(
    verbose = FALSE,
    progress = FALSE
  )
  expect_issues_table(
    gh_issues_from_orgs
  )
  test_mocker$cache(gh_issues_from_orgs)
})

test_that("get_issues_from_repos for GitHub works", {
  if (integration_tests_skipped) {
    mockery::stub(
      github_testhost_priv$get_issues_from_repos,
      "graphql_engine$prepare_issues_table",
      test_mocker$use("gh_issues_table")
    )
    github_testhost_priv$orgs_repos <- list("test_org" = "TestRepo")
    test_org <- "test_org"
    attr(test_org, "type") <- "organization"
    mockery::stub(
      github_testhost_priv$get_issues_from_repos,
      "graphql_engine$set_owner_type",
      test_org
    )
  } else {
    github_testhost_priv$orgs_repos <- list("r-world-devs" = "GitStats")
  }
  github_testhost_priv$searching_scope <- "repo"
  gh_issues_from_repos <- github_testhost_priv$get_issues_from_repos(
    verbose = FALSE,
    progress = FALSE
  )
  expect_issues_table(
    gh_issues_from_repos
  )
  test_mocker$cache(gh_issues_from_repos)
})

test_that("`get_issues()` retrieves issues in the table format in a certain time span", {
  mockery::stub(
    github_testhost$get_issues,
    "private$get_issues_from_orgs",
    test_mocker$use("gh_issues_from_orgs")
  )
  mockery::stub(
    github_testhost$get_issues,
    "private$get_issues_from_repos",
    test_mocker$use("gh_issues_from_repos")
  )
  gh_issues_table <- github_testhost$get_issues(
    since = "2023-01-01",
    until = "2025-03-06",
    verbose = FALSE,
    progress = FALSE
  )
  expect_issues_table(
    gh_issues_table
  )
  gh_issues_table_shorter <- github_testhost$get_issues(
    since = "2023-02-01",
    until = "2024-01-01",
    verbose = FALSE,
    progress = FALSE
  )
  expect_true(
   nrow(gh_issues_table) > nrow(gh_issues_table_shorter)
  )
  expect_true(
    max(gh_issues_table_shorter$created_at) <= "2024-01-01"
  )
  expect_true(
    min(gh_issues_table_shorter$created_at) >= "2023-02-01"
  )
  test_mocker$cache(gh_issues_table)
})

test_that("`get_issues()` retrieves open issues in the table format in a certain time span", {
  mockery::stub(
    github_testhost$get_issues,
    "private$get_issues_from_orgs",
    test_mocker$use("gh_issues_from_orgs")
  )
  mockery::stub(
    github_testhost$get_issues,
    "private$get_issues_from_repos",
    test_mocker$use("gh_issues_from_repos")
  )
  gh_open_issues_table <- github_testhost$get_issues(
    since = "2023-01-01",
    state = "open",
    verbose = FALSE,
    progress = FALSE
  )
  expect_issues_table(
    gh_open_issues_table
  )
  expect_true(
    all(gh_open_issues_table$state == "open")
  )
  gh_closed_issues_table <- github_testhost$get_issues(
    since = "2023-01-01",
    state = "closed",
    verbose = FALSE,
    progress = FALSE
  )
  expect_issues_table(
    gh_closed_issues_table
  )
  expect_true(
    all(gh_closed_issues_table$state == "closed")
  )
})
