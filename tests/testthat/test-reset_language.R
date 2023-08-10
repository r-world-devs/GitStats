test_that("`reset_language()` resets language settings to 'All'", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  suppressMessages({
    invisible(
      setup(test_gitstats,
            search_param = "phrase",
            phrase = "test-phrase",
            language = "Python")
    )
  })
  expect_snapshot(
    reset_language(test_gitstats)
  )
  priv <- environment(test_gitstats$setup)$private
  expect_equal(
    priv$settings$search_param,
    "phrase"
  )
  expect_equal(
    priv$settings$phrase,
    "test-phrase"
  )
  expect_equal(
    priv$settings$language,
    "All"
  )
})
