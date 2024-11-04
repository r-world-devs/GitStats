test_that("get_repos_urls() works for org", {
  mockery::stub(
    test_rest_gitlab$get_repos_urls,
    "self$response",
    test_fixtures$gitlab_repositories_rest_response
  )
  gl_api_repos_urls <- test_rest_gitlab$get_repos_urls(
    type = "api",
    org = "mbtests",
    repos = NULL
  )
  expect_length(
    gl_api_repos_urls,
    3
  )
  test_mocker$cache(gl_api_repos_urls)
  gl_web_repos_urls <- test_rest_gitlab$get_repos_urls(
    type = "web",
    org = "mbtests",
    repos = NULL
  )
  expect_length(
    gl_web_repos_urls,
    3
  )
  test_mocker$cache(gl_web_repos_urls)
})

test_that("get_repos_urls() works for individual repos", {
  mockery::stub(
    test_rest_gitlab$get_repos_urls,
    "self$response",
    test_fixtures$gitlab_repositories_rest_response
  )
  gl_api_repos_urls <- test_rest_gitlab$get_repos_urls(
    type = "api",
    org = "mbtests",
    repos = c("testRepo1", "testRepo2")
  )
  expect_length(
    gl_api_repos_urls,
    2
  )
  test_mocker$cache(gl_api_repos_urls)
  gl_web_repos_urls <- test_rest_gitlab$get_repos_urls(
    type = "web",
    org = "mbtests",
    repos = c("testRepo1", "testRepo2")
  )
  expect_length(
    gl_web_repos_urls,
    2
  )
  test_mocker$cache(gl_web_repos_urls)
})

test_that("get_all_repos_urls prepares api repo_urls vector", {
  mockery::stub(
    gitlab_testhost_priv$get_all_repos_urls,
    "rest_engine$get_repos_urls",
    test_mocker$use("gl_api_repos_urls")
  )
  gl_api_repos_urls <- gitlab_testhost_priv$get_all_repos_urls(
    type = "api",
    verbose = FALSE
  )
  expect_gt(length(gl_api_repos_urls), 0)
  expect_true(all(grepl("api", gl_api_repos_urls)))
  test_mocker$cache(gl_api_repos_urls)
  mockery::stub(
    gitlab_testhost_priv$get_all_repos_urls,
    "rest_engine$get_repos_urls",
    test_mocker$use("gl_web_repos_urls")
  )
  gl_web_repos_urls <- gitlab_testhost_priv$get_all_repos_urls(
    type = "web",
    verbose = FALSE
  )
  expect_gt(length(gl_web_repos_urls), 0)
  test_mocker$cache(gl_web_repos_urls)
})

test_that("get_all_repos_urls prepares web repo_urls vector", {
  mockery::stub(
    gitlab_testhost_priv$get_all_repos_urls,
    "rest_engine$get_repos_urls",
    test_mocker$use("gl_web_repos_urls")
  )
  gl_repos_urls <- gitlab_testhost_priv$get_all_repos_urls(
    type = "web",
    verbose = FALSE
  )
  expect_gt(length(gl_repos_urls), 0)
  expect_true(all(!grepl("api", gl_repos_urls)))
})

test_that("`get_repo_url_from_response()` works", {
  gl_repo_web_urls <- gitlab_testhost_priv$get_repo_url_from_response(
    search_response = test_mocker$use("gl_search_response"),
    type            = "web",
    progress        = FALSE
  )
  expect_gt(length(gl_repo_web_urls), 0)
  expect_type(gl_repo_web_urls, "character")
  test_mocker$cache(gl_repo_web_urls)
})

test_that("get_repos_urls returns repositories URLS", {
  mockery::stub(
    gitlab_testhost$get_repos_urls,
    "private$get_repo_url_from_response",
    test_mocker$use("gl_repo_web_urls")
  )
  gl_repos_urls_with_code_in_files <- gitlab_testhost$get_repos_urls(
    type = "web",
    with_code = "shiny",
    in_files = "DESCRIPTION",
    verbose = FALSE
  )
  expect_type(gl_repos_urls_with_code_in_files, "character")
  expect_gt(length(gl_repos_urls_with_code_in_files), 0)
  test_mocker$cache(gl_repos_urls_with_code_in_files)
})
