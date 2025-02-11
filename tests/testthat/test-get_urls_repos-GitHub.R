test_that("get_repos_urls() works for whole orgs", {
  mockery::stub(
    test_rest_github$get_repos_urls,
    "private$paginate_results",
    test_fixtures$github_repositories_rest_response
  )
  gh_repos_urls <- test_rest_github$get_repos_urls(
    type = "web",
    org = "test_org",
    repos = NULL
  )
  expect_length(
    gh_repos_urls,
    3
  )
  test_mocker$cache(gh_repos_urls)
})

test_that("get_repos_urls() works for individual repos", {
  mockery::stub(
    test_rest_github$get_repos_urls,
    "private$paginate_results",
    test_fixtures$github_repositories_rest_response
  )
  gh_repos_urls <- test_rest_github$get_repos_urls(
    type = "web",
    org = "test_org",
    repos = c("testRepo", "testRepo2")
  )
  expect_length(
    gh_repos_urls,
    2
  )
  test_mocker$cache(gh_repos_urls)
})

test_that("get_repos_urls prepares api repo_urls vector", {
  mockery::stub(
    test_rest_github$get_repos_urls,
    "private$paginate_results",
    test_fixtures$github_repositories_rest_response
  )
  gh_api_repos_urls <- test_rest_github$get_repos_urls(
    org = "test_org",
    repos = NULL,
    type = "api"
  )
  expect_gt(length(gh_api_repos_urls), 0)
  expect_true(any(grepl("test-org", gh_api_repos_urls)))
  expect_true(all(grepl("api", gh_api_repos_urls)))
  test_mocker$cache(gh_api_repos_urls)
})

test_that("get_repos_urls_from_orgs prepares web repo_urls vector", {
  mockery::stub(
    github_testhost_priv$get_repos_urls_from_orgs,
    "rest_engine$get_repos_urls",
    test_mocker$use("gh_repos_urls")
  )
  github_testhost_priv$searching_scope <- "org"
  github_testhost_priv$orgs <- "test_org"
  expect_snapshot(
    gh_repos_urls_from_orgs <- github_testhost_priv$get_repos_urls_from_orgs(
      type = "web",
      verbose = TRUE,
      progress = FALSE
    )
  )
  expect_gt(length(gh_repos_urls_from_orgs), 0)
  expect_true(any(grepl("test-org", gh_repos_urls_from_orgs)))
  expect_true(all(grepl("https://testhost.com/", gh_repos_urls_from_orgs)))
  test_mocker$cache(gh_repos_urls_from_orgs)
})

test_that("get_repos_urls_from_repos prepares web repo_urls vector", {
  test_org <- "test_org"
  attr(test_org, "type") <- "organization"
  mockery::stub(
    github_testhost_priv$get_repos_urls_from_repos,
    "graphql_engine$set_owner_type",
    test_org
  )
  mockery::stub(
    github_testhost_priv$get_repos_urls_from_repos,
    "rest_engine$get_repos_urls",
    test_mocker$use("gh_repos_urls"),
    depth = 2L
  )
  github_testhost_priv$searching_scope <- c("repo")
  github_testhost_priv$orgs_repos <- list("test_org" = "TestRepo")
  expect_snapshot(
    gh_repos_urls <- github_testhost_priv$get_repos_urls_from_repos(
      type = "web",
      verbose = TRUE,
      progress = FALSE
    )
  )
  expect_gt(length(gh_repos_urls), 0)
  expect_true(any(grepl("test-org", gh_repos_urls)))
  expect_true(all(grepl("https://testhost.com/", gh_repos_urls)))
  test_mocker$cache(gh_repos_urls)
})

test_that("get_all_repos_urls prepares web repo_urls vector", {
  mockery::stub(
    github_testhost_priv$get_all_repos_urls,
    "private$get_repos_urls_from_orgs",
    test_mocker$use("gh_repos_urls_from_orgs")
  )
  mockery::stub(
    github_testhost_priv$get_all_repos_urls,
    "private$get_repos_urls_from_repos",
    test_mocker$use("gh_repos_urls")
  )
  expect_snapshot(
    gh_repos_urls <- github_testhost_priv$get_all_repos_urls(
      type = "web",
      verbose = TRUE
    )
  )
  expect_gt(length(gh_repos_urls), 0)
  expect_true(any(grepl("test-org", gh_repos_urls)))
  expect_true(all(grepl("https://testhost.com/", gh_repos_urls)))
  test_mocker$cache(gh_repos_urls)
})

test_that("get_all_repos_urls is set to scan whole host", {
  github_testhost_all_priv <- create_github_testhost_all(
    orgs = "test_org",
    mode = "private"
  )
  mockery::stub(
    github_testhost_all_priv$get_all_repos_urls,
    "graphql_engine$get_orgs",
    "test_org"
  )
  mockery::stub(
    github_testhost_all_priv$get_all_repos_urls,
    "private$get_repos_urls_from_orgs",
    test_mocker$use("gh_repos_urls_from_orgs")
  )
  mockery::stub(
    github_testhost_all_priv$get_all_repos_urls,
    "private$get_repos_urls_from_repos",
    test_mocker$use("gh_repos_urls")
  )
  gh_repos_urls <- github_testhost_all_priv$get_all_repos_urls(
    type = "web",
    verbose = FALSE
  )
  expect_gt(length(gh_repos_urls), 0)
  expect_true(any(grepl("test-org", gh_repos_urls)))
  expect_true(all(grepl("https://testhost.com/", gh_repos_urls)))
})

test_that("get_repo_url_from_response retrieves repositories URLS", {
  gh_repo_api_urls <- github_testhost_priv$get_repo_url_from_response(
    search_response = test_mocker$use("gh_search_repos_response"),
    type = "api"
  )
  expect_type(gh_repo_api_urls, "character")
  expect_gt(length(gh_repo_api_urls), 0)
  test_mocker$cache(gh_repo_api_urls)
  gh_repo_web_urls <- github_testhost_priv$get_repo_url_from_response(
    search_response = test_mocker$use("gh_search_repos_response"),
    type = "web"
  )
  expect_type(gh_repo_web_urls, "character")
  expect_gt(length(gh_repo_web_urls), 0)
  test_mocker$cache(gh_repo_web_urls)
})

test_that("get_repos_urls_with_code_from_host returns repositories URLS", {
  mockery::stub(
    github_testhost_priv$get_repos_urls_with_code_from_host,
    "private$get_repo_url_from_response",
    test_mocker$use("gh_repo_web_urls")
  )
  gh_repos_urls_with_code_from_host <- github_testhost_priv$get_repos_urls_with_code_from_host(
    type = "api",
    code = "shiny",
    in_files = "DESCRIPTION",
    in_path = FALSE,
    verbose = FALSE,
    progress= FALSE
  )
  expect_type(gh_repos_urls_with_code_from_host, "character")
  expect_gt(length(gh_repos_urls_with_code_from_host), 0)
  test_mocker$cache(gh_repos_urls_with_code_from_host)
})

test_that("get_repos_urls_with_code_from_orgs returns repositories URLS", {
  mockery::stub(
    github_testhost_priv$get_repos_urls_with_code_from_orgs,
    "private$get_repo_url_from_response",
    test_mocker$use("gh_repo_web_urls")
  )
  gh_repos_urls_with_code_from_orgs <- github_testhost_priv$get_repos_urls_with_code_from_orgs(
    type = "web",
    code = "shiny",
    in_files = "DESCRIPTION",
    in_path = FALSE,
    verbose = FALSE,
    progress= FALSE
  )
  expect_type(gh_repos_urls_with_code_from_orgs, "character")
  expect_gt(length(gh_repos_urls_with_code_from_orgs), 0)
  test_mocker$cache(gh_repos_urls_with_code_from_orgs)
})

test_that("get_repos_urls_with_code_from_repos returns repositories URLS", {
  mockery::stub(
    github_testhost_priv$get_repos_urls_with_code_from_repos,
    "private$get_repo_url_from_response",
    test_mocker$use("gh_repo_web_urls")
  )
  gh_repos_urls_with_code_from_repos <- github_testhost_priv$get_repos_urls_with_code_from_repos(
    type = "web",
    code = "shiny",
    in_files = "DESCRIPTION",
    in_path = FALSE,
    verbose = FALSE,
    progress = FALSE
  )
  expect_type(gh_repos_urls_with_code_from_repos, "character")
  expect_gt(length(gh_repos_urls_with_code_from_repos), 0)
  test_mocker$cache(gh_repos_urls_with_code_from_repos)
})

test_that("get_repos_urls_with_code returns repositories URLS", {
  mockery::stub(
    github_testhost_priv$get_repos_urls_with_code,
    "private$get_repos_urls_with_code_from_orgs",
    test_mocker$use("gh_repos_urls_with_code_from_orgs")
  )
  mockery::stub(
    github_testhost_priv$get_repos_urls_with_code,
    "private$get_repos_urls_with_code_from_repos",
    test_mocker$use("gh_repos_urls_with_code_from_repos")
  )
  gh_repos_urls_with_code_in_files <- github_testhost_priv$get_repos_urls_with_code(
    type = "web",
    code = "shiny",
    in_files = "DESCRIPTION",
    in_path = FALSE,
    verbose = FALSE,
    progress = FALSE
  )
  expect_type(gh_repos_urls_with_code_in_files, "character")
  expect_gt(length(gh_repos_urls_with_code_in_files), 0)
  test_mocker$cache(gh_repos_urls_with_code_in_files)
})

test_that("get_repos_urls_with_code returns repositories URLS from whole host", {
  github_testhost_priv <- create_github_testhost(
    mode = "private"
  )
  mockery::stub(
    github_testhost_priv$get_repos_urls_with_code,
    "private$get_repos_urls_with_code_from_host",
    test_mocker$use("gh_repos_urls_with_code_from_host")
  )
  gh_repos_urls_with_code_in_files <- github_testhost_priv$get_repos_urls_with_code(
    type = "web",
    code = "shiny",
    in_files = "DESCRIPTION",
    in_path = FALSE,
    verbose = FALSE,
    progress = FALSE
  )
  expect_type(gh_repos_urls_with_code_in_files, "character")
  expect_gt(length(gh_repos_urls_with_code_in_files), 0)
  test_mocker$cache(gh_repos_urls_with_code_in_files)
})

test_that("get_repos_urls returns repositories URLS", {
  mockery::stub(
    github_testhost$get_repos_urls,
    "private$get_repos_urls_with_code",
    test_mocker$use("gh_repos_urls_with_code_in_files")
  )
  gh_repos_urls_with_code_in_files <- github_testhost$get_repos_urls(
    type = "web",
    with_code = "shiny",
    in_files = "DESCRIPTION",
    with_file = NULL,
    verbose = FALSE,
    progress = FALSE
  )
  expect_type(gh_repos_urls_with_code_in_files, "character")
  expect_gt(length(gh_repos_urls_with_code_in_files), 0)
  test_mocker$cache(gh_repos_urls_with_code_in_files)
})

test_that("get_repos_urls returns repositories URLS", {
  mockery::stub(
    github_testhost$get_repos_urls,
    "private$get_repos_urls_with_code",
    test_mocker$use("gh_repos_urls_with_code_in_files")
  )
  gh_repos_urls_with_code_in_files <- github_testhost$get_repos_urls(
    type = "web",
    with_file = "DESCRIPTION",
    verbose = FALSE,
    progress = FALSE
  )
  expect_type(gh_repos_urls_with_code_in_files, "character")
  expect_gt(length(gh_repos_urls_with_code_in_files), 0)
  test_mocker$cache(gh_repos_urls_with_code_in_files)
})

test_that("get_repos_urls returns repositories URLS", {
  mockery::stub(
    github_testhost$get_repos_urls,
    "private$get_all_repos_urls",
    test_mocker$use("gh_repos_urls")
  )
  gh_repos_urls <- github_testhost$get_repos_urls(
    type = "web",
    verbose = FALSE,
    progress = FALSE
  )
  expect_type(gh_repos_urls, "character")
  expect_gt(length(gh_repos_urls), 0)
  test_mocker$cache(gh_repos_urls)
})
