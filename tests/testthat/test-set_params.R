test_gitstats <- create_gitstats()
test_gitstats_priv <- environment(test_gitstats$set_params)$private

test_that("Setting up settings to `team` throws error when team_name is not defined", {
  expect_snapshot_error(
    set_params(test_gitstats,
      search_param = "team"
    )
  )
})

test_that("Setting up settings to `team` passes information to 'team' field", {
  suppressMessages(
    set_params(test_gitstats,
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
  set_params(test_gitstats,
    search_param = "org"
  )
  expect_equal(
    test_gitstats_priv$settings$search_param,
    "org"
  )
})

test_that("Setting up settings to `phrase` throws error when phrase is not defined", {
  expect_error(
    set_params(test_gitstats,
      search_param = "phrase"
    )
  )
})

test_that("Setting up settings to `phrase` works correctly", {
  expect_snapshot(
    set_params(test_gitstats,
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
    set_params(test_gitstats,
      search_param = "twilight"
    )
  )
})

test_that("Setting language works correctly", {
  expect_snapshot(
    set_params(test_gitstats,
      language = "Python"
    )
  )
})

test_that("Setting language to 'All' resets language settings", {
  expect_snapshot(
    set_params(test_gitstats,
          language = "All"
    )
  )
})
