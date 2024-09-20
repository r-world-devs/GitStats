test_that("get_repos_table works", {
  mockery::stub(
    test_gitstats_priv$get_repos_table,
    "host$get_repos",
    purrr::list_rbind(list(
      test_mocker$use("gh_repos_table_with_api_url"),
      test_mocker$use("gl_repos_table_with_api_url")
    ))
  )
  repos_table <- test_gitstats_priv$get_repos_table(
    with_code = NULL,
    in_files = NULL,
    with_files = NULL,
    verbose = FALSE,
    settings = test_settings
  )
  expect_repos_table(
    repos_table,
    repo_cols = repo_gitstats_colnames
  )
})

test_that("get_repos_table with_code works", {
  mockery::stub(
    test_gitstats_priv$get_repos_table,
    "private$get_repos_from_host_with_code",
    purrr::list_rbind(
      list(test_mocker$use("gh_repos_by_code_table"),
           test_mocker$use("gl_repos_by_code_table"))
    )
  )
  repos_table <- test_gitstats_priv$get_repos_table(
    with_code = "shiny",
    in_files = "DESCRIPTION",
    with_files = NULL,
    verbose = FALSE,
    settings = test_settings
  )
  expect_repos_table(
    repos_table,
    repo_cols = repo_gitstats_colnames,
    with_cols = c("contributors", "contributors_n")
  )
  test_mocker$cache(repos_table)
})

test_that("set_object_class for repos_table works correctly", {
  repos_table <- test_gitstats_priv$set_object_class(
    object = test_mocker$use("repos_table"),
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
  test_gitstats <- create_test_gitstats(hosts = 2)
  mockery::stub(
    test_gitstats$get_repos,
    "private$get_repos_table",
    test_mocker$use("repos_table")
  )
  repos_table <- test_gitstats$get_repos(verbose = FALSE)
  expect_repos_table_object(
    repos_object = repos_table,
    with_cols = c("contributors", "contributors_n")
  )
  test_mocker$cache(repos_table)
  expect_snapshot(
    repos_table <- test_gitstats$get_repos()
  )
})

test_that("get_repos pulls repositories without contributors", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  repos_table <- test_gitstats$get_repos(add_contributors = FALSE, verbose = FALSE)
  expect_repos_table(repos_table, repo_cols = repo_gitstats_colnames)
  expect_false("contributors" %in% names(repos_table))
})
