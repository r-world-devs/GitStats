test_gitstats <- create_gitstats()
test_gitstats_priv <- environment(test_gitstats$setup)$private

test_that("By default search param is set to 'orgs'", {
  expect_equal(
    test_gitstats_priv$settings$search_param,
    "org"
  )
})

test_that("Setting up settings to `team` throws error when team_name is not defined", {
  expect_snapshot_error(
    setup(test_gitstats,
      search_param = "team"
    )
  )
})

test_that("Setting up settings to `team` passes information to 'team' field", {
  suppressMessages(
    setup(test_gitstats,
      search_param = "team",
      team_name = "RWD-IE"
    )
  )
  expect_equal(
    test_gitstats_priv$settings$search_param,
    "team"
  )
})

test_that("Setting up settings to `orgs` works correctly", {
  setup(test_gitstats,
    search_param = "org"
  )
  expect_equal(
    test_gitstats_priv$settings$search_param,
    "org"
  )
})

test_that("Setting up settings to `phrase` throws error when phrase is not defined", {
  expect_error(
    setup(test_gitstats,
      search_param = "phrase"
    )
  )
})

test_that("Setting up settings to `phrase` works correctly", {
  expect_snapshot(
    setup(test_gitstats,
      search_param = "phrase",
      phrase = "covid"
    )
  )
  expect_equal(
    test_gitstats_priv$settings$search_param,
    "phrase"
  )
  expect_equal(
    test_gitstats_priv$settings$phrase,
    "covid"
  )
})

test_that("Error shows, when you pass not proper param", {
  expect_error(
    setup(test_gitstats,
      search_param = "twilight"
    )
  )
})

test_that("Setting language works correctly", {
  expect_snapshot(
    setup(test_gitstats,
      language = "Python"
    )
  )
})
