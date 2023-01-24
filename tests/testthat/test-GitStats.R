test_gitstats <- create_gitstats()

test_that("Error shows when no `date_from` input to `get_commits`", {
  expect_error(
    test_gitstats$get_commits(),
    "You need to define"
  )
})
