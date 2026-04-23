test_that("private get_from_storage works", {
  test_gitstats_priv <- test_gitstats$.__enclos_env__$private
  suppressMessages({
    commits <- test_gitstats_priv$get_from_storage(table = "commits")
  })
  expect_s3_class(
    commits,
    "tbl"
  )
  expect_commits_table(
    commits
  )
})

test_that("get_storage works", {
  gitstats_storage <- test_gitstats$get_storage(
    storage = NULL
  )
  expect_type(
    gitstats_storage,
    "list"
  )
  expect_s3_class(
    gitstats_storage[[1]],
    "tbl"
  )
  expect_gt(length(gitstats_storage), 0)
})
test_that("get_storage retrieves one table", {
  gitstats_storage <- test_gitstats$get_storage(
    storage = "commits"
  )
  expect_s3_class(
    gitstats_storage,
    "tbl"
  )
  expect_s3_class(
    gitstats_storage,
    "gitstats_commits"
  )
  expect_commits_table(
    gitstats_storage
  )
})

test_that("get_storage retrieves one table", {
  gitstats_storage <- get_storage(
    gitstats = test_gitstats,
    storage = "files"
  )
  expect_s3_class(
    gitstats_storage,
    "tbl"
  )
  expect_s3_class(
    gitstats_storage,
    "gitstats_files"
  )
})
