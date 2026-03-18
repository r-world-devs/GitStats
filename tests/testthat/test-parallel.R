# ---- mirai_active ----

test_that("`mirai_active` returns FALSE when no daemons are set", {
  mirai::daemons(0)
  expect_false(mirai_active())
})

# ---- gitstats_map (sequential fallback) ----

test_that("`gitstats_map` falls back to purrr::map when no daemons are set", {
  mirai::daemons(0)
  result <- gitstats_map(1:3, function(x) x * 2)
  expect_equal(result, list(2L, 4L, 6L))
})

test_that("`gitstats_map` passes .progress to purrr::map in sequential mode", {
  mirai::daemons(0)
  result <- gitstats_map(1:3, function(x) x + 1, .progress = FALSE)
  expect_equal(result, list(2L, 3L, 4L))
})

# ---- gitstats_map2 (sequential fallback) ----

test_that("`gitstats_map2` falls back to purrr::map2 when no daemons are set", {
  mirai::daemons(0)
  result <- gitstats_map2(1:3, 4:6, function(a, b) a + b)
  expect_equal(result, list(5L, 7L, 9L))
})

# ---- gitstats_map_chr (sequential fallback) ----

test_that("`gitstats_map_chr` falls back to purrr::map_chr when no daemons are set", {
  mirai::daemons(0)
  result <- gitstats_map_chr(c("a", "b", "c"), function(x) toupper(x))
  expect_equal(result, c("A", "B", "C"))
})

# ---- gitstats_map with .progress = TRUE (sequential) ----

test_that("`gitstats_map` works with character .progress in sequential mode", {
  mirai::daemons(0)
  result <- gitstats_map(1:3, function(x) x * 10, .progress = "GitHub")
  expect_equal(result, list(10L, 20L, 30L))
})

# ---- gitstats_map_chr with .progress (sequential) ----

test_that("`gitstats_map_chr` works with .progress = TRUE in sequential mode", {
  mirai::daemons(0)
  result <- gitstats_map_chr(1:3, function(x) as.character(x), .progress = TRUE)
  expect_equal(result, c("1", "2", "3"))
})

# ---- gitstats_map with empty input (sequential) ----

test_that("`gitstats_map` handles empty input in sequential mode", {
  mirai::daemons(0)
  result <- gitstats_map(list(), function(x) x)
  expect_equal(result, list())
})

test_that("`gitstats_map2` handles empty input in sequential mode", {
  mirai::daemons(0)
  result <- gitstats_map2(list(), list(), function(a, b) a + b)
  expect_equal(result, list())
})

test_that("`gitstats_map_chr` handles empty input in sequential mode", {
  mirai::daemons(0)
  result <- gitstats_map_chr(character(0), function(x) x)
  expect_equal(result, character(0))
})

# ---- set_parallel ----

test_that("`set_parallel` enables and disables daemons", {
  withr::defer(mirai::daemons(0))

  expect_message(set_parallel(2), "Parallel processing enabled with 2 workers")
  expect_true(mirai_active())

  expect_message(set_parallel(FALSE), "Parallel processing disabled")
  expect_false(mirai_active())

  expect_message(set_parallel(0), "Parallel processing disabled")
  expect_false(mirai_active())

  expect_message(set_parallel(0L), "Parallel processing disabled")
  expect_false(mirai_active())
})

test_that("`set_parallel(TRUE)` auto-detects workers", {
  withr::defer(mirai::daemons(0))
  expect_message(set_parallel(TRUE), "Parallel processing enabled with \\d+ workers")
  expect_true(mirai_active())
})
