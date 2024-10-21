test_that("get_repos_from_hosts works", {
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

test_that("get_repos_from_hosts pulls table in minimalist version", {
  mockery::stub(
    test_gitstats_priv$get_repos_from_hosts,
    "host$get_repos",
    test_mocker$use("gh_repos_table_min")
  )
  repos_from_hosts_min <- test_gitstats_priv$get_repos_from_hosts(
    add_contributors = TRUE,
    with_code = NULL,
    in_files = NULL,
    with_files = NULL,
    output = "table_min",
    verbose = FALSE,
    progress = FALSE
  )
  expect_repos_table(
    repos_from_hosts_min,
    repo_cols = repo_min_colnames,
    with_cols = c("api_url", "platform")
  )
  test_mocker$cache(repos_from_hosts_min)
})

test_that("set_object_class for repos_table works correctly", {
  repos_table <- test_gitstats_priv$set_object_class(
    object = test_mocker$use("repos_from_hosts"),
    class = "repos_table",
    attr_list = list(
      "with_code"  = NULL,
      "in_files"   = NULL,
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
  repos_table <- test_gitstats$get_repos(verbose = FALSE)
  expect_repos_table_object(
    repos_object = repos_table,
    with_cols = c("contributors", "contributors_n")
  )
  repos_table <- test_gitstats$get_repos(
    verbose = FALSE
  )
  expect_repos_table_object(
    repos_object = repos_table,
    with_cols = c("contributors", "contributors_n")
  )
})
