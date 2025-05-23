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
  expect_true(
    all(names(gitstats_storage) %in% c("organizations", "repositories",
                                       "commits", "issues", "repos_trees",
                                       "users", "files", "files_structure",
                                       "release_logs", "R_package_usage"))
  )
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
