test_that("get_issues_from_hosts works", {
  mockery::stub(
    test_gitstats_priv$get_issues_from_hosts,
    "host$get_issues",
    purrr::list_rbind(list(
      test_mocker$use("gh_issues_table"),
      test_mocker$use("gl_issues_table")
    ))
  )
  issues_table_from_hosts <- test_gitstats_priv$get_issues_from_hosts(
    since = "2023-01-01",
    until = "2025-03-06",
    state = NULL,
    verbose = FALSE,
    progress = FALSE
  )
  expect_issues_table(
    issues_table_from_hosts
  )
  test_mocker$cache(issues_table_from_hosts)
})

test_that("set_object_class works for issues", {
  issues_table <- test_gitstats_priv$set_object_class(
    object = test_mocker$use("issues_table_from_hosts"),
    class = "issues_data",
    attr_list = list(
      "date_range" = c("2023-01-01", "2025-03-06")
    )
  )
  expect_s3_class(
    issues_table,
    "issues_data"
  )
  expect_equal(
    attr(issues_table, "date_range"),
    c("2023-01-01", "2025-03-06")
  )
})

test_that("get_issues works properly", {
  mockery::stub(
    test_gitstats$get_issues,
    "private$get_issues_from_hosts",
    test_mocker$use("issues_table_from_hosts")
  )
  issues_table <- test_gitstats$get_issues(
    since = "2023-01-01",
    until = "2025-03-06",
    state = NULL,
    verbose = FALSE
  )
  expect_issues_table(
    issues_table
  )
  test_mocker$cache(issues_table)
})


test_that("get_issues() returns warning if issues table is empty", {
  mockery::stub(
    test_gitstats$get_issues,
    "private$get_issues_from_hosts",
    data.frame()
  )
  expect_snapshot(
    issues_table <- test_gitstats$get_issues(
      since = "2023-01-01",
      until = "2025-03-06",
      cache = FALSE,
      state = NULL,
      verbose = TRUE
    )
  )
  expect_equal(nrow(issues_table), 0)
})

test_that("get_issues() works", {
  mockery::stub(
    get_issues,
    "gitstats$get_issues",
    test_mocker$use("issues_table")
  )
  issues_data <- get_issues(
    test_gitstats,
    since = "2023-01-01",
    until = "2025-03-06",
    verbose = FALSE
  )
  expect_s3_class(
    issues_data,
    "gitstats_issues"
  )
  test_mocker$cache(issues_data)
})

test_that("get_issues() prints data on time used", {
  mockery::stub(
    get_issues,
    "gitstats$get_issues",
    test_mocker$use("issues_table")
  )
  expect_snapshot(
    issues_data <- get_issues(
      test_gitstats,
      since = "2023-01-01",
      until = "2025-03-06",
      verbose = TRUE
    )
  )
})
