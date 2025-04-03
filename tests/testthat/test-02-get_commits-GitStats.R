test_that("get_commits_from_hosts works", {
  mockery::stub(
    test_gitstats_priv$get_commits_from_hosts,
    "host$get_commits",
    purrr::list_rbind(list(
      test_mocker$use("gh_commits_table"),
      test_mocker$use("gl_commits_table")
    ))
  )
  commits_table_from_hosts <- test_gitstats_priv$get_commits_from_hosts(
    since = "2023-01-01",
    until = "2025-03-06",
    verbose = FALSE,
    progress = FALSE
  )
  expect_commits_table(
    commits_table_from_hosts
  )
  test_mocker$cache(commits_table_from_hosts)
})

test_that("set_object_class works for commits", {
  commits_table <- test_gitstats_priv$set_object_class(
    object = test_mocker$use("commits_table_from_hosts"),
    class = "commits_data",
    attr_list = list(
      "date_range" = c("2023-06-15", "2023-06-30")
    )
  )
  expect_s3_class(
    commits_table,
    "commits_data"
  )
  expect_equal(
    attr(commits_table, "date_range"),
    c("2023-06-15", "2023-06-30")
  )
})

test_that("get_commits works properly", {
  mockery::stub(
    test_gitstats$get_commits,
    "private$get_commits_from_hosts",
    test_mocker$use("commits_table_from_hosts")
  )
  suppressMessages(
    commits_table <- test_gitstats$get_commits(
      since = "2023-06-15",
      until = "2023-06-30",
      verbose = FALSE
    )
  )
  expect_commits_table(
    commits_table
  )
  test_mocker$cache(commits_table)
})

test_that("get_commits() works", {
  mockery::stub(
    get_commits,
    "gitstats$get_commits",
    test_mocker$use("commits_table")
  )
  commits_data <- get_commits(
    test_gitstats,
    since = "2023-06-15",
    until = "2023-06-30",
    verbose = FALSE
  )
  expect_s3_class(
    commits_data,
    "gitstats_commits"
  )
  test_mocker$cache(commits_data)
})

test_that("get_commits() returns error when since is not defined", {
  mockery::stub(
    get_commits,
    "gitstats$get_commits",
    test_mocker$use("commits_table")
  )
  expect_snapshot_error(
    get_commits(
      test_gitstats,
      verbose = FALSE
    )
  )
})

test_that("get_commits() prints time used", {
  mockery::stub(
    get_commits,
    "gitstats$get_commits",
    test_mocker$use("commits_table")
  )
  expect_snapshot(
    commits <- get_commits(
      test_gitstats,
      since = "2023-06-15",
      until = "2023-06-30",
      verbose = TRUE
    )
  )
})
