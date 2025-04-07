test_that("get_repos_from_host_with_code works", {
  mockery::stub(
    test_gitstats_priv$get_repos_from_host_with_code,
    "host$get_repos",
    test_mocker$use("gh_repos_table_full")
  )
  repos_from_host_with_code <- test_gitstats_priv$get_repos_from_host_with_code(
    add_contributors = TRUE,
    with_code = "test_code",
    in_files = NULL,
    force_orgs = FALSE,
    verbose = FALSE,
    progress = FALSE
  )
  expect_repos_table(
    repos_from_host_with_code,
    repo_cols = repo_host_colnames,
    with_cols = c("api_url", "platform", "contributors")
  )
  test_mocker$cache(repos_from_host_with_code)
})

test_that("get_repos_from_host_with_files works", {
  mockery::stub(
    test_gitstats_priv$get_repos_from_host_with_files,
    "host$get_repos",
    test_mocker$use("gl_repos_table_full")
  )
  repos_from_host_with_files <- test_gitstats_priv$get_repos_from_host_with_files(
    add_contributors = TRUE,
    with_files = "test_file",
    force_orgs = FALSE,
    verbose = FALSE,
    progress = FALSE
  )
  expect_repos_table(
    repos_from_host_with_files,
    repo_cols = repo_host_colnames,
    with_cols = c("api_url", "platform", "contributors")
  )
  test_mocker$cache(repos_from_host_with_files)
})

test_that("get_repos_from_hosts works", {
  mockery::stub(
    test_gitstats_priv$get_repos_from_hosts,
    "private$get_repos_from_host_with_code",
    test_mocker$use("repos_from_host_with_code")
  )
  repos_from_hosts_with_code <- test_gitstats_priv$get_repos_from_hosts(
    add_contributors = TRUE,
    with_code = "test_code",
    in_files = NULL,
    with_files = NULL,
    verbose = FALSE,
    progress = FALSE
  )
  expect_repos_table(
    repos_from_hosts_with_code,
    repo_cols = repo_gitstats_colnames,
    with_cols = c("contributors", "contributors_n")
  )
  mockery::stub(
    test_gitstats_priv$get_repos_from_hosts,
    "private$get_repos_from_host_with_files",
    test_mocker$use("repos_from_host_with_files")
  )
  repos_from_hosts_with_files <- test_gitstats_priv$get_repos_from_hosts(
    add_contributors = TRUE,
    with_code = NULL,
    in_files = NULL,
    with_files = "test_file",
    verbose = FALSE,
    progress = FALSE
  )
  expect_repos_table(
    repos_from_hosts_with_files,
    repo_cols = repo_gitstats_colnames,
    with_cols = c("contributors", "contributors_n")
  )
  mockery::stub(
    test_gitstats_priv$get_repos_from_hosts,
    "host$get_repos",
    purrr::list_rbind(list(
      test_mocker$use("gh_repos_table_full"),
      test_mocker$use("gl_repos_table_with_api_url")
    ))
  )
  repos_from_hosts <- test_gitstats_priv$get_repos_from_hosts(
    add_contributors = TRUE,
    with_code = NULL,
    in_files = NULL,
    with_files = NULL,
    verbose = FALSE,
    progress = FALSE
  )
  expect_repos_table(
    repos_from_hosts,
    repo_cols = repo_gitstats_colnames,
    with_cols = c("contributors", "contributors_n")
  )
  test_mocker$cache(repos_from_hosts)
})

test_that("set_object_class for repos_table works correctly", {
  repos_table <- test_gitstats_priv$set_object_class(
    object = test_mocker$use("repos_from_hosts"),
    class = "repos_table",
    attr_list = list(
      "with_code" = NULL,
      "in_files" = NULL,
      "with_files" = "renv.lock"
    )
  )
  expect_s3_class(repos_table, "repos_table")
  expect_equal(attr(repos_table, "with_files"), "renv.lock")
  test_mocker$cache(repos_table)
})

test_that("get_repos works properly and for the second time uses cache", {
  mockery::stub(
    test_gitstats$get_repos,
    "private$get_repos_from_hosts",
    test_mocker$use("repos_table")
  )
  repos_data <- test_gitstats$get_repos(verbose = FALSE)
  expect_repos_table_object(
    repos_object = repos_data,
    with_cols = c("contributors", "contributors_n")
  )
  repos_data <- test_gitstats$get_repos(
    verbose = FALSE
  )
  expect_repos_table_object(
    repos_object = repos_data,
    with_cols = c("contributors", "contributors_n")
  )
  test_mocker$cache(repos_data)
})

test_that("get_repos returns warning when repositories table is empty", {
  mockery::stub(
    test_gitstats$get_repos,
    "private$get_repos_from_hosts",
    data.frame()
  )
  expect_snapshot(
    repos_data <- test_gitstats$get_repos(
      cache = FALSE,
      verbose = TRUE
    )
  )
  expect_equal(nrow(repos_data), 0)
})

test_that("get_repos works", {
  mockery::stub(
    get_repos,
    "gitstats$get_repos",
    test_mocker$use("repos_data")
  )
  repos_data <- get_repos(
    gitstats = test_gitstats,
    verbose = FALSE
  )
  expect_repos_table_object(
    repos_object = repos_data,
    with_cols = c("contributors", "contributors_n")
  )
})

test_that("get_repos prints time used to pull data", {
  mockery::stub(
    get_repos,
    "gitstats$get_repos",
    test_mocker$use("repos_data")
  )
  expect_snapshot(
    repos_data <- get_repos(
      gitstats = test_gitstats,
      verbose = TRUE
    )
  )
})
