test_that("get_repos_urls() works for whole orgs", {
  mockery::stub(
    test_rest_github$get_repos_urls,
    "self$response",
    test_fixtures$github_repositories_rest_response
  )
  gh_repos_urls <- test_rest_github$get_repos_urls(
    type = "web",
    org = "test-org",
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
    "self$response",
    test_fixtures$github_repositories_rest_response
  )
  gh_repos_urls <- test_rest_github$get_repos_urls(
    type = "web",
    org = "test-org",
    repos = c("testRepo", "testRepo2")
  )
  expect_length(
    gh_repos_urls,
    2
  )
  test_mocker$cache(gh_repos_urls)
})

test_that("get_all_repos_urls prepares api repo_urls vector", {
  github_testhost_priv <- create_github_testhost(orgs = "test-org",
                                                 mode = "private")
  mockery::stub(
    test_rest_github$get_repos_urls,
    "self$response",
    test_fixtures$github_repositories_rest_response
  )
  gh_api_repos_urls <- test_rest_github$get_repos_urls(
    repos = NULL,
    type = "api"
  )
  expect_gt(length(gh_api_repos_urls), 0)
  expect_true(any(grepl("test-org", gh_api_repos_urls)))
  expect_true(all(grepl("api", gh_api_repos_urls)))
  test_mocker$cache(gh_api_repos_urls)
})

test_that("get_all_repos_urls prepares web repo_urls vector", {
  mockery::stub(
    github_testhost_priv$get_all_repos_urls,
    "rest_engine$get_repos_urls",
    test_mocker$use("gh_repos_urls"),
    depth = 2L
  )
  gh_repos_urls <- github_testhost_priv$get_all_repos_urls(
    type = "web",
    verbose = FALSE
  )
  expect_gt(length(gh_repos_urls), 0)
  expect_true(any(grepl("test-org", gh_repos_urls)))
  expect_true(all(grepl("https://testhost.com/", gh_repos_urls)))
  test_mocker$cache(gh_repos_urls)
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

test_that("get_repos_urls returns repositories URLS", {
  mockery::stub(
    github_testhost$get_repos_urls,
    "private$get_repo_url_from_response",
    test_mocker$use("gh_repo_web_urls")
  )
  gh_repos_urls_with_code_in_files <- github_testhost$get_repos_urls(
    type = "web",
    with_code = "shiny",
    in_files = "DESCRIPTION",
    verbose = FALSE
  )
  expect_type(gh_repos_urls_with_code_in_files, "character")
  expect_gt(length(gh_repos_urls_with_code_in_files), 0)
  test_mocker$cache(gh_repos_urls_with_code_in_files)
})
