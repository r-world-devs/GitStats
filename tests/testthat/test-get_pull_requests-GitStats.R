test_that("get_pull_requests_from_hosts works", {
  mockery::stub(
    test_gitstats_priv$get_pull_requests_from_hosts,
    "host$get_pull_requests",
    purrr::list_rbind(list(
      test_mocker$use("gh_pr_table"),
      test_mocker$use("gl_pr_table")
    ))
  )
  pr_table_from_hosts <- test_gitstats_priv$get_pull_requests_from_hosts(
    since = "2025-01-01",
    until = "2026-03-06",
    state = NULL,
    verbose = FALSE,
    progress = FALSE
  )
  expect_pr_table(
    pr_table_from_hosts
  )
  test_mocker$cache(pr_table_from_hosts)
})

test_that("set_object_class works for pull requests", {
  pr_table <- test_gitstats_priv$set_object_class(
    object = test_mocker$use("pr_table_from_hosts"),
    class = "gitstats_pull_requests",
    attr_list = list(
      "date_range" = c("2023-01-01", "2025-03-06")
    )
  )
  expect_s3_class(
    pr_table,
    "gitstats_pull_requests"
  )
  expect_equal(
    attr(pr_table, "date_range"),
    c("2023-01-01", "2025-03-06")
  )
})

test_that("get_pull_requests works properly", {
  mockery::stub(
    test_gitstats$get_pull_requests,
    "private$get_pull_requests_from_hosts",
    test_mocker$use("pr_table_from_hosts")
  )
  pr_table <- test_gitstats$get_pull_requests(
    since = "2023-01-01",
    until = "2025-03-06",
    state = NULL,
    verbose = FALSE
  )
  expect_pr_table(pr_table)
  test_mocker$cache(pr_table)
})

test_that("get_pull_requests gets data from storage for the second time", {
  expect_snapshot(
    pr_table <- test_gitstats$get_pull_requests(
      since = "2023-01-01",
      until = "2025-03-06",
      state = NULL,
      verbose = FALSE
    )
  )
  expect_pr_table(pr_table)
})

test_that("get_pull_requests() returns warning if PR table is empty", {
  mockery::stub(
    test_gitstats$get_pull_requests,
    "private$get_pull_requests_from_hosts",
    data.frame()
  )
  expect_snapshot(
    pr_table <- test_gitstats$get_pull_requests(
      since = "2023-01-01",
      until = "2025-03-06",
      cache = FALSE,
      state = NULL,
      verbose = TRUE
    )
  )
  expect_equal(nrow(pr_table), 0)
})

test_that("get_pull_requests works", {
  mockery::stub(
    get_pull_requests,
    "gitstats$get_pull_requests",
    test_mocker$use("pr_table")
  )
  pr_data <- get_pull_requests(
    test_gitstats,
    since = "2023-01-01",
    until = "2025-03-06",
    verbose = FALSE
  )
  expect_s3_class(
    pr_data,
    "gitstats_pull_requests"
  )
  test_mocker$cache(pr_data)
})

test_that("get_pull_requests() prints data on time used", {
  mockery::stub(
    get_pull_requests,
    "gitstats$get_pull_requests",
    test_mocker$use("pr_table")
  )
  expect_snapshot(
    pr_data <- get_pull_requests(
      test_gitstats,
      since = "2023-01-01",
      until = "2025-03-06",
      verbose = TRUE
    )
  )
})
