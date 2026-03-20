# ---- StorageLocal ----

test_that("StorageLocal saves and loads data", {
  storage <- StorageLocal$new()
  test_data <- dplyr::tibble(a = 1:3, b = c("x", "y", "z"))
  storage$save("test_table", test_data)
  result <- storage$load("test_table")
  expect_equal(result, test_data)
})

test_that("StorageLocal preserves R classes and attributes", {
  storage <- StorageLocal$new()
  test_data <- dplyr::tibble(a = 1:3)
  class(test_data) <- c("gitstats_commits", class(test_data))
  attr(test_data, "date_range") <- c("2024-01-01", "2024-12-31")
  storage$save("commits", test_data)
  result <- storage$load("commits")
  expect_s3_class(result, "gitstats_commits")
  expect_equal(attr(result, "date_range"), c("2024-01-01", "2024-12-31"))
})

test_that("StorageLocal$exists works", {
  storage <- StorageLocal$new()
  expect_false(storage$exists("missing"))
  storage$save("present", dplyr::tibble(x = 1))
  expect_true(storage$exists("present"))
})

test_that("StorageLocal$list returns stored names", {
  storage <- StorageLocal$new()
  expect_length(storage$list(), 0)
  storage$save("commits", dplyr::tibble(x = 1))
  storage$save("repos", dplyr::tibble(y = 2))
  expect_equal(sort(storage$list()), c("commits", "repos"))
})

test_that("StorageLocal$load returns NULL for missing data", {
  storage <- StorageLocal$new()
  expect_null(storage$load("nonexistent"))
})

# ---- set_storage ----

test_that("GitStats uses StorageLocal by default", {
  gs <- create_gitstats()
  gs_priv <- environment(gs$print)$private
  expect_s3_class(gs_priv$storage_backend, "StorageLocal")
})

test_that("set_storage with unknown type errors", {
  gs <- create_gitstats()
  expect_error(
    gs$set_storage(type = "unknown"),
    "Unknown storage type"
  )
})

test_that("set_storage('local') resets to in-memory storage", {
  gs <- create_gitstats()
  gs$set_storage(type = "local")
  gs_priv <- environment(gs$print)$private
  expect_s3_class(gs_priv$storage_backend, "StorageLocal")
})

test_that("set_storage('postgres') errors without DBI packages", {
  skip_if(requireNamespace("RPostgres", quietly = TRUE),
          "RPostgres is installed, cannot test missing package error")
  gs <- create_gitstats()
  expect_error(
    gs$set_storage(type = "postgres", dbname = "test"),
    "RPostgres"
  )
})

# ---- StoragePostgres (requires database) ----

test_that("StoragePostgres saves and loads data with metadata", {
  skip_if_not(
    nzchar(Sys.getenv("GITSTATS_TEST_DB")),
    "Set GITSTATS_TEST_DB to run Postgres storage tests"
  )
  skip_if_not_installed("RPostgres")
  skip_if_not_installed("DBI")
  skip_if_not_installed("jsonlite")

  storage <- StoragePostgres$new(
    schema = "git_stats_test",
    dbname = Sys.getenv("GITSTATS_TEST_DB"),
    host = Sys.getenv("GITSTATS_TEST_DB_HOST", "localhost"),
    port = as.integer(Sys.getenv("GITSTATS_TEST_DB_PORT", "5432")),
    user = Sys.getenv("GITSTATS_TEST_DB_USER", "postgres"),
    password = Sys.getenv("GITSTATS_TEST_DB_PASSWORD", "")
  )
  withr::defer({
    DBI::dbExecute(
      storage$.__enclos_env__$private$conn,
      "DROP SCHEMA IF EXISTS git_stats_test CASCADE"
    )
  })

  test_data <- dplyr::tibble(
    repo_name = c("GitStats", "GitAI"),
    stars = c(10L, 5L)
  )
  class(test_data) <- c("gitstats_repositories", class(test_data))
  attr(test_data, "date_range") <- c("2024-01-01", "2024-12-31")

  storage$save("repositories", test_data)
  expect_true(storage$exists("repositories"))

  result <- storage$load("repositories")
  expect_s3_class(result, "gitstats_repositories")
  expect_equal(nrow(result), 2)
  expect_equal(result$repo_name, c("GitStats", "GitAI"))
  expect_equal(attr(result, "date_range"), c("2024-01-01", "2024-12-31"))
})

test_that("set_storage('postgres') creates connection from arguments", {
  skip_if_not(
    nzchar(Sys.getenv("GITSTATS_TEST_DB")),
    "Set GITSTATS_TEST_DB to run Postgres storage tests"
  )
  skip_if_not_installed("RPostgres")
  skip_if_not_installed("DBI")

  gs <- create_gitstats()
  gs$set_storage(
    type = "postgres",
    dbname = Sys.getenv("GITSTATS_TEST_DB"),
    host = Sys.getenv("GITSTATS_TEST_DB_HOST", "localhost"),
    port = as.integer(Sys.getenv("GITSTATS_TEST_DB_PORT", "5432")),
    user = Sys.getenv("GITSTATS_TEST_DB_USER", "postgres"),
    password = Sys.getenv("GITSTATS_TEST_DB_PASSWORD", ""),
    schema = "git_stats_test2"
  )
  gs_priv <- environment(gs$print)$private
  expect_s3_class(gs_priv$storage_backend, "StoragePostgres")

  withr::defer({
    DBI::dbExecute(
      gs_priv$storage_backend$.__enclos_env__$private$conn,
      "DROP SCHEMA IF EXISTS git_stats_test2 CASCADE"
    )
  })
})
