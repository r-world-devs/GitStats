test_that("GitStats object is created", {
  test_gitstats <- create_gitstats()
  expect_s3_class(test_gitstats, "GitStats")
})
