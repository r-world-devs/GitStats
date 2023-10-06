test_that("`reset()` resets all settings", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  suppressMessages({
    invisible(
      set_params(
        test_gitstats,
        search_param = "phrase",
        phrase = "test-phrase",
        language = "Python"
      )
    )
  })
  expect_snapshot(
    reset(test_gitstats)
  )
  suppressMessages({
    invisible(
      set_params(
        test_gitstats,
        search_param = "team",
        team_name = "Testers",
        language = "CSS"
      ) %>%
      set_team_member("John Test") %>%
      set_team_member("Bob Test")
    )
  })
  expect_snapshot(
    reset(test_gitstats)
  )
})

test_that("`reset_language()` resets language settings to 'All'", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  suppressMessages({
    invisible(
      set_params(
        test_gitstats,
        search_param = "phrase",
        phrase = "test-phrase",
        language = "Python"
      )
    )
  })
  expect_snapshot(
    reset_language(test_gitstats)
  )
  priv <- environment(test_gitstats$set_params)$private
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
