test_that("pr_by_repo GitHub query is built properly", {
  gh_pr_from_repo_query <-
    test_gqlquery_gh$pull_requests_from_repo()
  expect_snapshot(
    gh_pr_from_repo_query
  )
})

test_that("`get_pr_page_from_repo()` pulls pr page from repository", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_github_priv$get_pr_page_from_repo,
      "self$gql_response",
      test_fixtures_pr$github_graphql_pr_response
    )
  }
  pr_page <- test_graphql_github_priv$get_pr_page_from_repo(
    org = "r-world-devs",
    repo = "GitStats"
  )
  expect_pr_gql_response(
    pr_page$data$repository$pullRequests$edges[[1]]
  )
  test_mocker$cache(pr_page)
})

test_that("`get_pr_from_one_repo()` prepares formatted list", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_github_priv$get_pr_from_one_repo,
      "private$get_pr_page_from_repo",
      test_mocker$use("pr_page")
    )
  }
  pr_from_repo <- test_graphql_github_priv$get_pr_from_one_repo(
    org = "r-world-devs",
    repo = "GitStats"
  )
  if (!integration_tests_skipped) {
    expect_gt(length(pr_from_repo), 100)
  }
  expect_pr_full_list(
    pr_from_repo
  )
  test_mocker$cache(pr_from_repo)
})

test_that("`get_pr_from_repos()` pulls pr from repos", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_github$get_pr_from_repos,
      "private$get_pr_from_one_repo",
      test_mocker$use("pr_from_repo")
    )
  }
  pr_from_repos <- test_graphql_github$get_pr_from_repos(
    org = "r-world-devs",
    repo = c("GitStats", "GitAI")
  )
  expect_pr_full_list(
    pr_from_repos[[1]]
  )
  test_mocker$cache(pr_from_repos)
})

test_that("`prepare_pr_table()` prepares pr table", {
  gh_pr_table <- test_graphql_github$prepare_pr_table(
    repos_list_with_pr = test_mocker$use("pr_from_repos"),
    org = "r-world-devs"
  )
  expect_pr_table(
    gh_pr_table
  )
  test_mocker$cache(gh_pr_table)
})

test_that("get_pr_from_orgs for GitHub works", {
  if (integration_tests_skipped) {
    mockery::stub(
      github_testhost_priv$get_pr_from_orgs,
      "graphql_engine$prepare_pr_table",
      test_mocker$use("gh_pr_table")
    )
    mockery::stub(
      github_testhost_priv$get_pr_from_orgs,
      "private$get_repos_names",
      test_mocker$use("gh_repos_names")
    )
  }
  github_testhost_priv$searching_scope <- "org"
  gh_pr_from_orgs <- github_testhost_priv$get_pr_from_orgs(
    verbose = FALSE,
    progress = FALSE
  )
  expect_pr_table(
    gh_pr_from_orgs
  )
  test_mocker$cache(gh_pr_from_orgs)
})

test_that("get_pr_from_orgs for GitHub prints messages", {
  mockery::stub(
    github_testhost_priv$get_pr_from_orgs,
    "graphql_engine$prepare_pr_table",
    test_mocker$use("gh_pr_table")
  )
  mockery::stub(
    github_testhost_priv$get_pr_from_orgs,
    "private$get_repos_data",
    test_mocker$use("gh_repos_data")
  )
  github_testhost_priv$searching_scope <- "org"
  expect_snapshot(
    gh_pr_from_orgs <- github_testhost_priv$get_pr_from_orgs(
      verbose = TRUE,
      progress = FALSE
    )
  )
})

test_that("get_pr_from_repos for GitHub works", {
  if (integration_tests_skipped) {
    mockery::stub(
      github_testhost_priv$get_pr_from_repos,
      "graphql_engine$prepare_pr_table",
      test_mocker$use("gh_pr_table")
    )
    github_testhost_priv$orgs_repos <- list("test_org" = "TestRepo")
    test_org <- "test_org"
    attr(test_org, "type") <- "organization"
    mockery::stub(
      github_testhost_priv$get_pr_from_repos,
      "graphql_engine$set_owner_type",
      test_org
    )
  } else {
    github_testhost_priv$orgs_repos <- list("r-world-devs" = "GitStats")
  }
  github_testhost_priv$searching_scope <- "repo"
  gh_pr_from_repos <- github_testhost_priv$get_pr_from_repos(
    verbose = FALSE,
    progress = FALSE
  )
  expect_pr_table(
    gh_pr_from_repos
  )
  test_mocker$cache(gh_pr_from_repos)
})

test_that("get_pr_from_repos for GitHub prints messages", {
  mockery::stub(
    github_testhost_priv$get_pr_from_repos,
    "graphql_engine$prepare_pr_table",
    test_mocker$use("gh_pr_table")
  )
  github_testhost_priv$orgs_repos <- list("test_org" = "TestRepo")
  test_org <- "test_org"
  attr(test_org, "type") <- "organization"
  mockery::stub(
    github_testhost_priv$get_pr_from_repos,
    "graphql_engine$set_owner_type",
    test_org
  )
  github_testhost_priv$searching_scope <- "repo"
  expect_snapshot(
    gh_pr_from_repos <- github_testhost_priv$get_pr_from_repos(
      verbose = TRUE,
      progress = FALSE
    )
  )
})

test_that("`get_pull_requests()` retrieves pr in the table format in a certain time span", {
  mockery::stub(
    github_testhost$get_pull_requests,
    "private$get_pr_from_orgs",
    test_mocker$use("gh_pr_from_orgs")
  )
  mockery::stub(
    github_testhost$get_pull_requests,
    "private$get_pr_from_repos",
    test_mocker$use("gh_pr_from_repos")
  )
  gh_pr_table <- github_testhost$get_pull_requests(
    since = "2024-01-01",
    until = "2026-03-06",
    verbose = FALSE,
    progress = FALSE
  )
  expect_pr_table(
    gh_pr_table
  )
  if (!integration_tests_skipped) {
    gh_pr_table_shorter <- github_testhost$get_pull_requests(
      since = "2024-02-01",
      until = "2025-01-01",
      verbose = FALSE,
      progress = FALSE
    )
    expect_true(
      nrow(gh_pr_table) > nrow(gh_pr_table_shorter)
    )
    expect_true(
      max(gh_pr_table_shorter$created_at) <= "2025-01-01"
    )
    expect_true(
      min(gh_pr_table_shorter$created_at) >= "2024-02-01"
    )
  }
  test_mocker$cache(gh_pr_table)
})

test_that("`get_pull_requests()` retrieves closed and open pr in the table format in a certain time span", {
  mockery::stub(
    github_testhost$get_pull_requests,
    "private$get_pr_from_orgs",
    test_mocker$use("gh_pr_from_orgs")
  )
  mockery::stub(
    github_testhost$get_pull_requests,
    "private$get_pr_from_repos",
    test_mocker$use("gh_pr_from_repos")
  )
  if (integration_tests_skipped) {
    gh_open_pr_table <- github_testhost$get_pull_requests(
      since = "2024-01-01",
      until = "2025-01-01",
      state = "open",
      verbose = FALSE,
      progress = FALSE
    )
    expect_pr_table(
      gh_open_pr_table
    )
    expect_true(
      all(gh_open_pr_table$state == "open")
    )
  }
  gh_closed_pr_table <- github_testhost$get_pull_requests(
    since = "2024-01-01",
    until = "2025-01-01",
    state = "closed",
    verbose = FALSE,
    progress = FALSE
  )
  expect_pr_table(
    gh_closed_pr_table
  )
  expect_true(
    all(gh_closed_pr_table$state == "closed")
  )
})
