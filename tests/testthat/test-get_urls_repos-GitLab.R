test_that("get_repos_urls() works for org", {
  mockery::stub(
    test_rest_gitlab$get_repos_urls,
    "self$get_repos_from_org",
    test_fixtures$gitlab_repositories_rest_response
  )
  test_org <- "test_org"
  attr(test_org, "type") <- "organization"
  gl_api_repos_urls <- test_rest_gitlab$get_repos_urls(
    type = "api",
    org = test_org,
    repos = NULL
  )
  expect_length(
    gl_api_repos_urls,
    3
  )
  test_mocker$cache(gl_api_repos_urls)
  test_user <- "test_user"
  attr(test_user, "type") <- "user"
  gl_web_repos_urls <- test_rest_gitlab$get_repos_urls(
    type = "web",
    org = test_user,
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
    "self$get_repos_from_org",
    test_mocker$use("gitlab_rest_repos_from_org_raw")
  )
  test_group <- "test_group"
  attr(test_group, "type") <- "organization"
  gl_api_repos_urls <- test_rest_gitlab$get_repos_urls(
    type = "api",
    org = test_group,
    repos = c("testRepo1", "testRepo2")
  )
  expect_length(
    gl_api_repos_urls,
    2
  )
  test_mocker$cache(gl_api_repos_urls)
  test_user <- "test_user"
  attr(test_user, "type") <- "user"
  gl_web_repos_urls <- test_rest_gitlab$get_repos_urls(
    type = "web",
    org = test_user,
    repos = c("testRepo1", "testRepo2")
  )
  expect_length(
    gl_web_repos_urls,
    2
  )
  test_mocker$cache(gl_web_repos_urls)
})

test_that("get_repos_urls_from_orgs prepares api repo_urls vector", {
  mockery::stub(
    gitlab_testhost_priv$get_repos_urls_from_orgs,
    "rest_engine$get_repos_urls",
    test_mocker$use("gl_api_repos_urls")
  )
  gitlab_testhost_priv$searching_scope <- "org"
  gitlab_testhost_priv$orgs <- "test_org"
  gl_api_repos_urls <- gitlab_testhost_priv$get_repos_urls_from_orgs(
    type = "api",
    verbose = FALSE,
    progress = FALSE
  )
  expect_gt(length(gl_api_repos_urls), 0)
  expect_true(all(grepl("api", gl_api_repos_urls)))
  test_mocker$cache(gl_api_repos_urls)
})

test_that("get_repos_urls_from_repos prepares api repo_urls vector", {
  mockery::stub(
    gitlab_testhost_priv$get_repos_urls_from_repos,
    "rest_engine$get_repos_urls",
    test_mocker$use("gl_web_repos_urls")
  )
  gitlab_testhost_priv$searching_scope <- c("repo")
  gitlab_testhost_priv$orgs_repos <- list("test_org" = "TestRepo")
  gl_web_repos_urls <- gitlab_testhost_priv$get_repos_urls_from_repos(
    type = "web",
    verbose = FALSE,
    progress = FALSE
  )
  expect_gt(length(gl_web_repos_urls), 0)
  test_mocker$cache(gl_web_repos_urls)
})


test_that("get_all_repos_urls prepares api repo_urls vector", {
  mockery::stub(
    gitlab_testhost_priv$get_all_repos_urls,
    "private$get_repos_urls_from_orgs",
    test_mocker$use("gl_api_repos_urls")
  )
  mockery::stub(
    gitlab_testhost_priv$get_all_repos_urls,
    "private$get_repos_urls_from_repos",
    NULL
  )
  gl_api_repos_urls <- gitlab_testhost_priv$get_all_repos_urls(
    type = "api",
    verbose = FALSE
  )
  expect_true(all(grepl("api", gl_api_repos_urls)))
  expect_gt(length(gl_api_repos_urls), 0)
  test_mocker$cache(gl_api_repos_urls)
})

test_that("`get_repo_url_from_response()` works", {
  gl_repo_web_urls <- gitlab_testhost_priv$get_repo_url_from_response(
    search_response = test_mocker$use("gl_repos_raw_output"),
    type = "web",
    progress = FALSE
  )
  expect_gt(length(gl_repo_web_urls), 0)
  expect_type(gl_repo_web_urls, "character")
  test_mocker$cache(gl_repo_web_urls)
})

test_that("get_repos_urls_with_code_from_orgs returns repositories URLS", {
  mockery::stub(
    gitlab_testhost_priv$get_repos_urls_with_code_from_orgs,
    "private$get_repo_url_from_response",
    test_mocker$use("gl_repo_web_urls")
  )
  gl_repos_urls_with_code_from_orgs <- gitlab_testhost_priv$get_repos_urls_with_code_from_orgs(
    type = "web",
    code = "shiny",
    in_files = "DESCRIPTION",
    in_path = FALSE,
    verbose = FALSE,
    progress = FALSE
  )
  expect_type(gl_repos_urls_with_code_from_orgs, "character")
  expect_gt(length(gl_repos_urls_with_code_from_orgs), 0)
  test_mocker$cache(gl_repos_urls_with_code_from_orgs)
})

test_that("get_repos_urls_with_code_from_repos returns repositories URLS", {
  mockery::stub(
    gitlab_testhost_priv$get_repos_urls_with_code_from_repos,
    "private$get_repo_url_from_response",
    test_mocker$use("gl_repo_web_urls")
  )
  gl_repos_urls_with_code_from_repos <- gitlab_testhost_priv$get_repos_urls_with_code_from_repos(
    type = "web",
    code = "shiny",
    in_files = "DESCRIPTION",
    in_path = FALSE,
    verbose = FALSE,
    progress = FALSE
  )
  expect_type(gl_repos_urls_with_code_from_repos, "character")
  expect_gt(length(gl_repos_urls_with_code_from_repos), 0)
  test_mocker$cache(gl_repos_urls_with_code_from_repos)
})

test_that("get_repos_urls_with_code_from_repos returns repositories URLS", {
  mockery::stub(
    gitlab_testhost_priv$get_repos_urls_with_code,
    "private$get_repos_urls_with_code_from_orgs",
    test_mocker$use("gl_repos_urls_with_code_from_orgs")
  )
  mockery::stub(
    gitlab_testhost_priv$get_repos_urls_with_code,
    "private$get_repos_urls_with_code_from_repos",
    test_mocker$use("gl_repos_urls_with_code_from_repos")
  )
  gl_repos_urls_with_code_in_files <- gitlab_testhost_priv$get_repos_urls_with_code(
    type = "web",
    code = "shiny",
    in_files = "DESCRIPTION",
    in_path = FALSE,
    verbose = FALSE,
    progress = FALSE
  )
  expect_type(gl_repos_urls_with_code_in_files, "character")
  expect_gt(length(gl_repos_urls_with_code_in_files), 0)
  test_mocker$cache(gl_repos_urls_with_code_in_files)
})
