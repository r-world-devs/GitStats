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
  skip_if(Sys.getenv("R_COVR") == "true", "mirai daemons conflict with covr tracing")
  withr::defer(mirai::daemons(0))
  gs <- create_gitstats()

  expect_message(set_parallel(gs, 2), "Parallel processing enabled with 2 workers")
  expect_true(is_parallel(gs))

  expect_message(set_parallel(gs, FALSE), "Parallel processing disabled")
  expect_false(is_parallel(gs))

  expect_message(set_parallel(gs, 0), "Parallel processing disabled")
  expect_false(is_parallel(gs))

  expect_message(set_parallel(gs, 0L), "Parallel processing disabled")
  expect_false(is_parallel(gs))
})

test_that("`set_parallel(TRUE)` auto-detects workers", {
  skip_if(Sys.getenv("R_COVR") == "true", "mirai daemons conflict with covr tracing")
  withr::defer(mirai::daemons(0))
  gs <- create_gitstats()
  expect_message(set_parallel(gs, TRUE), "Parallel processing enabled with \\d+ workers")
  expect_true(is_parallel(gs))
})

# ---- set_parallel (mocked, runs under covr) ----

test_that("`set_parallel` disable path executes under covr", {
  gs <- create_gitstats()
  mock_daemons <- mockery::mock("status_off")
  mockery::stub(gs$set_parallel, "mirai::daemons", mock_daemons)

  gs$set_parallel(FALSE)
  mockery::expect_called(mock_daemons, 1)
  expect_equal(mockery::mock_args(mock_daemons)[[1]], list(0))
  expect_false(gs$is_parallel())
})

test_that("`set_parallel(0)` disable path executes under covr", {
  gs <- create_gitstats()
  mock_daemons <- mockery::mock("status_off")
  mockery::stub(gs$set_parallel, "mirai::daemons", mock_daemons)

  gs$set_parallel(0)
  mockery::expect_called(mock_daemons, 1)
  expect_false(gs$is_parallel())
})

test_that("`set_parallel(0L)` disable path executes under covr", {
  gs <- create_gitstats()
  mock_daemons <- mockery::mock("status_off")
  mockery::stub(gs$set_parallel, "mirai::daemons", mock_daemons)

  gs$set_parallel(0L)
  mockery::expect_called(mock_daemons, 1)
  expect_false(gs$is_parallel())
})

test_that("`set_parallel` enable path with explicit workers executes under covr", {
  gs <- create_gitstats()
  mock_daemons <- mockery::mock("status_on")
  mockery::stub(gs$set_parallel, "mirai::daemons", mock_daemons)
  mockery::stub(gs$set_parallel, "do.call", NULL)

  gs$set_parallel(4)
  mockery::expect_called(mock_daemons, 1)
  expect_equal(mockery::mock_args(mock_daemons)[[1]], list(4))
})

test_that("`set_parallel(TRUE)` auto-detects and falls back to 2 when cores < 2", {
  gs <- create_gitstats()
  mock_daemons <- mockery::mock("status_on")
  mockery::stub(gs$set_parallel, "mirai::daemons", mock_daemons)
  mockery::stub(gs$set_parallel, "parallel::detectCores", 1L)
  mockery::stub(gs$set_parallel, "do.call", NULL)

  gs$set_parallel(TRUE)
  # Should have been called with 2 (the fallback)
  expect_equal(mockery::mock_args(mock_daemons)[[1]], list(2))
})

test_that("`set_parallel(TRUE)` falls back to 2 when detectCores returns NA", {
  gs <- create_gitstats()
  mock_daemons <- mockery::mock("status_on")
  mockery::stub(gs$set_parallel, "mirai::daemons", mock_daemons)
  mockery::stub(gs$set_parallel, "parallel::detectCores", NA_integer_)
  mockery::stub(gs$set_parallel, "do.call", NULL)

  gs$set_parallel(TRUE)
  expect_equal(mockery::mock_args(mock_daemons)[[1]], list(2))
})

test_that("`set_parallel(TRUE)` uses detected cores when >= 2", {
  gs <- create_gitstats()
  mock_daemons <- mockery::mock("status_on")
  mockery::stub(gs$set_parallel, "mirai::daemons", mock_daemons)
  mockery::stub(gs$set_parallel, "parallel::detectCores", 8L)
  mockery::stub(gs$set_parallel, "do.call", NULL)

  gs$set_parallel(TRUE)
  expect_equal(mockery::mock_args(mock_daemons)[[1]], list(8))
})

test_that("`set_parallel` returns GitStats object invisibly", {
  gs <- create_gitstats()
  mock_daemons <- mockery::mock("status", "status")
  mockery::stub(gs$set_parallel, "mirai::daemons", mock_daemons)

  result <- set_parallel(gs, FALSE)
  expect_invisible(set_parallel(gs, FALSE))
  expect_s3_class(result, "GitStats")
})

test_that("`set_parallel` can be used in a pipeline", {
  skip_if(Sys.getenv("R_COVR") == "true", "mirai daemons conflict with covr tracing")
  withr::defer(mirai::daemons(0))

  gs <- create_gitstats() |>
    set_parallel(2)
  expect_true(is_parallel(gs))
  expect_s3_class(gs, "GitStats")
})

# ---- is_parallel ----

test_that("`is_parallel` returns FALSE for a fresh GitStats object", {
  gs <- create_gitstats()
  expect_false(is_parallel(gs))
})

test_that("`is_parallel` reflects parallel state per object", {
  skip_if(Sys.getenv("R_COVR") == "true", "mirai daemons conflict with covr tracing")
  withr::defer(mirai::daemons(0))

  gs1 <- create_gitstats()
  gs2 <- create_gitstats()

  set_parallel(gs1, 2)
  # gs1 was set to parallel, gs2 was not
  expect_true(is_parallel(gs1))
  expect_false(is_parallel(gs2))
})

# ---- parallel execution paths (single daemon startup) ----

test_that("gitstats_map/map_chr work via mirai_map when daemons are active", {
  skip_if(Sys.getenv("R_COVR") == "true", "mirai daemons conflict with covr tracing")
  withr::defer(mirai::daemons(0))
  gs <- create_gitstats()
  set_parallel(gs, 2)

  # gitstats_map without progress
  result <- gitstats_map(1:3, function(x) x * 2)
  expect_equal(result, list(2L, 4L, 6L))

  # gitstats_map with progress
  result <- gitstats_map(1:3, function(x) x + 1, .progress = TRUE)
  expect_equal(result, list(2L, 3L, 4L))

  # gitstats_map_chr without progress
  result <- gitstats_map_chr(c("a", "b"), function(x) toupper(x))
  expect_equal(result, c("A", "B"))

  # gitstats_map_chr with progress
  result <- gitstats_map_chr(c("x", "y"), function(x) toupper(x), .progress = TRUE)
  expect_equal(result, c("X", "Y"))
})
