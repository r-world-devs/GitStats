commits_table_from_hosts <- purrr::list_rbind(
  list(
    test_mocker$use("gh_commits_table"),
    test_mocker$use("gl_commits_table")
  )
)

test_that("set_object_class works for commits", {
  commits_table <- test_gitstats_priv$set_object_class(
    object = commits_table_from_hosts,
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
    commits_table_from_hosts
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
