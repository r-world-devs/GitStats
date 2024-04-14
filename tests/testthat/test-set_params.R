test_gitstats <- create_gitstats()
test_gitstats_priv <- environment(test_gitstats$set_params)$private

test_that("Setting up settings to `orgs` works correctly", {
  expect_snapshot(
    set_params(test_gitstats,
               search_mode = "org"
    )
  )
  expect_equal(
    test_gitstats_priv$settings$search_mode,
    "org"
  )
})

test_that("Setting up settings to `code` works correctly", {
  expect_snapshot(
    set_params(test_gitstats,
      search_mode = "code"
    )
  )
  expect_equal(
    test_gitstats_priv$settings$search_mode,
    "code"
  )
})

test_that("Setting up `files` works correctly", {
  expect_snapshot(
    set_params(test_gitstats,
               files = c("DESCRIPTION", "NAMESPACE")
    )
  )
  expect_equal(
    test_gitstats_priv$settings$files,
    c("DESCRIPTION", "NAMESPACE")
  )
})

test_that("Error shows, when you pass not proper mode", {
  expect_error(
    set_params(test_gitstats,
      search_mode = "twilight"
    )
  )
})
