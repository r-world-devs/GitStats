test_that("get_repos_urls() works", {
  gh_repos_urls <- test_rest_github$get_repos_urls(
    type = "web",
    org = "r-world-devs"
  )
  expect_gt(
    length(gh_repos_urls),
    0
  )
  test_mocker$cache(gh_repos_urls)
})

test_that("get_all_repos_urls prepares api repo_urls vector", {
  github_testhost_priv <- create_github_testhost(orgs = c("r-world-devs", "openpharma"),
                                                 mode = "private")
  gh_api_repos_urls <- github_testhost_priv$get_all_repos_urls(
    type = "api",
    verbose = FALSE
  )
  expect_gt(length(gh_api_repos_urls), 0)
  expect_true(any(grepl("openpharma", gh_api_repos_urls)))
  expect_true(any(grepl("r-world-devs", gh_api_repos_urls)))
  expect_true(all(grepl("api", gh_api_repos_urls)))
  test_mocker$cache(gh_api_repos_urls)
})

test_that("get_all_repos_urls prepares web repo_urls vector", {
  mockery::stub(
    github_testhost_priv$get_all_repos_urls,
    "rest_engine$get_repos_urls",
    test_mocker$use("gh_repos_urls")
  )
  gh_repos_urls <- github_testhost_priv$get_all_repos_urls(
    type = "web",
    verbose = FALSE
  )
  expect_gt(length(gh_repos_urls), 0)
  expect_true(any(grepl("r-world-devs", gh_repos_urls)))
  expect_true(all(grepl("https://github.com/", gh_repos_urls)))
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
    search_response = test_mocker$use("gh_search_response_in_file"),
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
