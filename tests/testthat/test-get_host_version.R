test_that("REST Engine returns response on GitLab version", {
  expect_type(
    test_rest_gitlab$get_host_version(),
    "character"
  )
})

test_that("REST Engine returns response on GitHub version", {
  expect_type(
    test_rest_github$get_host_version(),
    "character"
  )
})
