test_that("Set_storage passes information to `storage` field", {
  test_gitstats <- create_gitstats()

  expect_null(test_gitstats$storage)

  set_storage(gitstats_obj = test_gitstats,
              type = "SQLite",
              dbname = "storage/test_db.sqlite")

  expect_length(test_gitstats$storage, 1)

})
