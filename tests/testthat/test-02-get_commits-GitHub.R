test_that("commits_by_repo GitHub query is built properly", {
  gh_commits_from_repo_query <-
    test_gqlquery_gh$commits_from_repo()
  expect_snapshot(
    gh_commits_from_repo_query
  )
})

test_that("error in GraphQL response is handled properly", {
  mockery::stub(
    test_graphql_github_priv$handle_gql_response_error,
    "private$is_query_error",
    TRUE
  )
  expect_snapshot_error(
    test_graphql_github_priv$handle_gql_response_error(
      response = list()
    )
  )
})

test_that("`get_commits_page_from_repo()` pulls commits page from repository", {
  mockery::stub(
    test_graphql_github_priv$get_commits_page_from_repo,
    "self$gql_response",
    test_fixtures$github_commits_response
  )
  commits_page <- test_graphql_github_priv$get_commits_page_from_repo(
    org = "r-world-devs",
    repo = "GitStats",
    since = "2023-01-01",
    until = "2023-02-28"
  )
  expect_gh_commit_gql_response(
    commits_page$data$repository$defaultBranchRef$target$history$edges[[1]]
  )
  test_mocker$cache(commits_page)
})

test_that("`get_commits_from_one_repo()` prepares formatted list", {
  mockery::stub(
    test_graphql_github_priv$get_commits_from_one_repo,
    "private$get_commits_page_from_repo",
    test_mocker$use("commits_page")
  )
  commits_from_repo <- test_graphql_github_priv$get_commits_from_one_repo(
    org = "r-world-devs",
    repo = "GitStats",
    since = "2023-01-01",
    until = "2023-02-28"
  )
  expect_gh_commit_gql_response(
    commits_from_repo[[1]]
  )
  test_mocker$cache(commits_from_repo)
})

test_that("`get_commits_from_repos()` pulls commits from repos", {
  mockery::stub(
    test_graphql_github$get_commits_from_repos,
    "private$get_commits_from_one_repo",
    test_mocker$use("commits_from_repo")
  )
  commits_from_repos <- test_graphql_github$get_commits_from_repos(
    org      = "r-world-devs",
    repo     = "GitStats",
    since    = "2023-01-01",
    until    = "2023-02-28",
    progress = FALSE
  )
  expect_gh_commit_gql_response(
    commits_from_repos[[1]][[1]]
  )
  test_mocker$cache(commits_from_repos)
})

test_that("`prepare_commits_table()` prepares commits table", {
  gh_commits_table <- test_graphql_github$prepare_commits_table(
    repos_list_with_commits = test_mocker$use("commits_from_repos"),
    org = "r-world-devs"
  )
  expect_commits_table(
    gh_commits_table
  )
  test_mocker$cache(gh_commits_table)
})

test_that("fill_empty_authors() works as expected", {
  commits_table <- test_mocker$use("gh_commits_table")
  commits_table$author_name <- NA
  commits_table <- test_graphql_github_priv$fill_empty_authors(
    commits_table = commits_table
  )
  expect_true(
    all(
      c("Bob Test", "Barbara Check", "John Test") %in% commits_table$author_name
    )
  )
})

test_that("`get_repos_names` works", {
  mockery::stub(
    github_testhost_priv$get_repos_names,
    "graphql_engine$get_repos_from_org",
    test_mocker$use("gh_repos_from_org")
  )
  github_testhost_priv$orgs_repos <- list("test_org" = "TestRepo")
  github_testhost_priv$searching_scope <- "org"
  gh_repos_names <- github_testhost_priv$get_repos_names(
    org = "test_org"
  )
  expect_type(gh_repos_names, "character")
  expect_gt(length(gh_repos_names), 0)
  test_mocker$cache(gh_repos_names)
})

test_that("get_commits_from_orgs for GitHub works", {
  mockery::stub(
    github_testhost_priv$get_commits_from_orgs,
    "graphql_engine$prepare_commits_table",
    test_mocker$use("gh_commits_table")
  )
  mockery::stub(
    github_testhost_priv$get_commits_from_orgs,
    "private$get_repos_names",
    test_mocker$use("gh_repos_names")
  )
  github_testhost_priv$searching_scope <- "org"
  gh_commits_from_orgs <- github_testhost_priv$get_commits_from_orgs(
    since    = "2023-03-01",
    until    = "2023-04-01",
    verbose  = FALSE,
    progress = FALSE
  )
  expect_commits_table(
    gh_commits_from_orgs
  )
  test_mocker$cache(gh_commits_from_orgs)
})


test_that("get_commits_from_repos for GitHub works", {
  mockery::stub(
    github_testhost_priv$get_commits_from_repos,
    "graphql_engine$prepare_commits_table",
    test_mocker$use("gh_commits_table")
  )
  github_testhost_priv$searching_scope <- "repo"
  github_testhost_priv$orgs_repos <- list("test_org" = "TestRepo")
  test_org <- "test_org"
  attr(test_org, "type") <- "organization"
  mockery::stub(
    github_testhost_priv$get_commits_from_repos,
    "graphql_engine$set_owner_type",
    test_org
  )
  gh_commits_from_repos <- github_testhost_priv$get_commits_from_repos(
    since    = "2023-03-01",
    until    = "2023-04-01",
    verbose  = FALSE,
    progress = FALSE
  )
  expect_commits_table(
    gh_commits_from_repos
  )
  test_mocker$cache(gh_commits_from_repos)
})

test_that("`get_commits()` retrieves commits in the table format", {
  mockery::stub(
    github_testhost$get_commits,
    "private$get_commits_from_orgs",
    test_mocker$use("gh_commits_from_orgs")
  )
  mockery::stub(
    github_testhost$get_commits,
    "private$get_commits_from_repos",
    test_mocker$use("gh_commits_from_repos")
  )
  gh_commits_table <- github_testhost$get_commits(
    since    = "2023-01-01",
    until    = "2023-02-28",
    verbose  = FALSE,
    progress = FALSE
  )
  expect_commits_table(
    gh_commits_table
  )
  test_mocker$cache(gh_commits_table)
})

test_that("`get_commits()` is set to scan whole git host", {
  github_testhost_all <- create_github_testhost_all(orgs = "test_org")
  mockery::stub(
    github_testhost_all$get_commits,
    "graphql_engine$get_orgs",
    "test_org"
  )
  mockery::stub(
    github_testhost_all$get_commits,
    "private$get_commits_from_orgs",
    test_mocker$use("gh_commits_from_orgs")
  )
  mockery::stub(
    github_testhost_all$get_commits,
    "private$get_commits_from_repos",
    test_mocker$use("gh_commits_from_repos")
  )
  expect_snapshot(
    gh_commits_table <- github_testhost_all$get_commits(
      since    = "2023-01-01",
      until    = "2023-02-28",
      verbose  = TRUE,
      progress = FALSE
    )
  )
})
