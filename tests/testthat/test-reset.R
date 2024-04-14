test_that("`reset()` resets all settings", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  suppressMessages({
    invisible(
      set_params(
        test_gitstats,
        search_mode = "code"
      )
    )
  })
  expect_snapshot(
    reset(test_gitstats)
  )
})
