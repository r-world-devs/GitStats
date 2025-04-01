test_that("get_repos_urls_from_hosts gets data from the hosts", {
  mockery::stub(
    test_gitstats_priv$get_repos_urls_from_hosts,
    "host$get_repos_urls",
    c(test_mocker$use("gh_api_repos_urls"), test_mocker$use("gl_api_repos_urls"))
  )
  repos_urls_from_hosts <- test_gitstats_priv$get_repos_urls_from_hosts(
    type = "api",
    with_code = NULL,
    in_files = NULL,
    with_files = NULL,
    verbose = FALSE
  )
  expect_type(repos_urls_from_hosts, "character")
  expect_gt(length(repos_urls_from_hosts), 0)
  expect_true(any(grepl("gitlab.com/api", repos_urls_from_hosts)))
  expect_true(any(grepl("testhost.com/api", repos_urls_from_hosts)))
  test_mocker$cache(repos_urls_from_hosts)
})

test_that("get_repos_urls_from_hosts gets data with_code in_files from the hosts", {
  mockery::stub(
    test_gitstats_priv$get_repos_urls_from_hosts,
    "private$get_repos_urls_from_host_with_code",
    c(test_mocker$use("gh_repos_urls_with_code_in_files"), test_mocker$use("gl_repos_urls_with_code_in_files"))
  )
  repos_urls_from_hosts_with_code_in_files <- test_gitstats_priv$get_repos_urls_from_hosts(
    type = "api",
    with_code = "shiny",
    in_files = "DESCRIPTION",
    with_files = NULL,
    verbose = FALSE
  )
  expect_type(repos_urls_from_hosts_with_code_in_files, "character")
  expect_gt(length(repos_urls_from_hosts_with_code_in_files), 0)
  expect_true(any(grepl("gitlab.com", repos_urls_from_hosts_with_code_in_files)))
  expect_true(any(grepl("github", repos_urls_from_hosts_with_code_in_files)))
  test_mocker$cache(repos_urls_from_hosts_with_code_in_files)
})

test_that("set_object_class works correctly", {
  repos_urls <- test_gitstats_priv$set_object_class(
    object = test_mocker$use("repos_urls_from_hosts_with_code_in_files"),
    class = "repos_urls",
    attr_list = list(
      "type" = "api",
      "with_code" = "shiny",
      "in_files" = c("NAMESPACE", "DESCRIPTION"),
      "with_files" = NULL
    )
  )
  expect_s3_class(repos_urls, "repos_urls")
  expect_equal(attr(repos_urls, "type"), "api")
  expect_equal(attr(repos_urls, "with_code"), "shiny")
  expect_equal(attr(repos_urls, "in_files"), c("NAMESPACE", "DESCRIPTION"))
})

test_that("get_repos_urls gets vector of repository URLS", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  mockery::stub(
    test_gitstats$get_repos_urls,
    "private$get_repos_urls_from_hosts",
    test_mocker$use("repos_urls_from_hosts")
  )
  repo_urls <- test_gitstats$get_repos_urls(
    verbose = FALSE
  )
  expect_type(
    repo_urls,
    "character"
  )
  expect_gt(
    length(repo_urls),
    1
  )
})

test_that("get_repos_urls gets vector of repository URLS", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  mockery::stub(
    test_gitstats$get_repos_urls,
    "private$get_repos_urls_from_hosts",
    test_mocker$use("repos_urls_from_hosts_with_code_in_files")
  )
  repos_urls <- test_gitstats$get_repos_urls(
    with_code = "shiny",
    in_files = "DESCRIPTION",
    verbose = FALSE
  )
  expect_type(
    repos_urls,
    "character"
  )
  expect_gt(
    length(repos_urls),
    1
  )
  test_mocker$cache(repos_urls)
})

test_that("get_repos_urls gets vector of repository URLS", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  mockery::stub(
    get_repos_urls,
    "gitstats$get_repos_urls",
    test_mocker$use("repos_urls")
  )
  repos_urls <- get_repos_urls(
    gitstats = test_gitstats,
    with_code = "shiny",
    in_files = "DESCRIPTION",
    verbose = FALSE
  )
  expect_type(
    repos_urls,
    "character"
  )
  expect_gt(
    length(repos_urls),
    1
  )
})

test_that("get_repos_urls prints time used to pull data", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  mockery::stub(
    get_repos_urls,
    "gitstats$get_repos_urls",
    test_mocker$use("repos_urls")
  )
  expect_snapshot(
    repos_urls <- get_repos_urls(
      gitstats = test_gitstats,
      with_code = "shiny",
      in_files = "DESCRIPTION",
      verbose = TRUE
    )
  )
})
