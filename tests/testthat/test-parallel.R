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

# ---- set_parallel ----

test_that("`set_parallel` enables daemons with integer workers", {
  withr::defer(mirai::daemons(0))
  expect_message(
    set_parallel(2),
    "Parallel processing enabled with 2 workers"
  )
  expect_true(mirai_active())
})

test_that("`set_parallel(TRUE)` auto-detects workers", {
  withr::defer(mirai::daemons(0))
  expect_message(
    set_parallel(TRUE),
    "Parallel processing enabled with \\d+ workers"
  )
  expect_true(mirai_active())
})

test_that("`set_parallel(FALSE)` disables daemons", {
  set_parallel(2)
  expect_message(
    set_parallel(FALSE),
    "Parallel processing disabled"
  )
  expect_false(mirai_active())
})

test_that("`set_parallel(0)` disables daemons", {
  set_parallel(2)
  expect_message(
    set_parallel(0),
    "Parallel processing disabled"
  )
  expect_false(mirai_active())
})

test_that("`set_parallel(0L)` disables daemons", {
  set_parallel(2)
  expect_message(
    set_parallel(0L),
    "Parallel processing disabled"
  )
  expect_false(mirai_active())
})

# ---- gitstats_map (parallel path) ----

test_that("`gitstats_map` uses mirai_map when daemons are active", {
  withr::defer(mirai::daemons(0))
  set_parallel(2)
  result <- gitstats_map(1:3, function(x) x * 2)
  expect_equal(result, list(2L, 4L, 6L))
})

test_that("`gitstats_map` handles empty input in parallel mode", {
  withr::defer(mirai::daemons(0))
  set_parallel(2)
  result <- gitstats_map(list(), function(x) x)
  expect_equal(result, list())
})

# ---- gitstats_map2 (parallel path) ----

test_that("`gitstats_map2` uses mirai_map when daemons are active", {
  withr::defer(mirai::daemons(0))
  set_parallel(2)
  result <- gitstats_map2(1:3, 4:6, function(a, b) a + b)
  expect_equal(result, list(5L, 7L, 9L))
})

# ---- gitstats_map_chr (parallel path) ----

test_that("`gitstats_map_chr` returns character vector in parallel mode", {
  withr::defer(mirai::daemons(0))
  set_parallel(2)
  result <- gitstats_map_chr(c("a", "b", "c"), function(x) toupper(x))
  expect_equal(result, c("A", "B", "C"))
})

# ---- edge cases ----

test_that("`gitstats_map` with single element works in parallel mode", {
  withr::defer(mirai::daemons(0))
  set_parallel(2)
  result <- gitstats_map(list(42), function(x) x * 2)
  expect_equal(result, list(84))
})

test_that("`set_parallel` can be called multiple times", {
  withr::defer(mirai::daemons(0))
  set_parallel(2)
  expect_true(mirai_active())
  set_parallel(FALSE)
  expect_false(mirai_active())
  set_parallel(2)
  expect_true(mirai_active())
})
