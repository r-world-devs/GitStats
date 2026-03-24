# Storage base class -----------------------------------------------------------

test_that("Storage base class methods raise 'Not implemented'", {
  base <- Storage$new()
  expect_error(base$save("x", 1), "Not implemented")
  expect_error(base$load("x"), "Not implemented")
  expect_error(base$exists("x"), "Not implemented")
  expect_error(base$list(), "Not implemented")
  expect_false(base$is_db())
})

# StorageLocal -----------------------------------------------------------------

test_that("StorageLocal save and load round-trips data", {
  storage <- StorageLocal$new()
  df <- dplyr::tibble(a = 1:3, b = letters[1:3])
  storage$save("test_data", df)
  loaded <- storage$load("test_data")
  expect_equal(loaded, df)
})

test_that("StorageLocal preserves class and attributes", {
  storage <- StorageLocal$new()
  df <- dplyr::tibble(a = 1:3)
  class(df) <- c("gitstats_repos", class(df))
  attr(df, "since") <- "2024-01-01"
  attr(df, "until") <- "2024-12-31"
  storage$save("repos", df)
  loaded <- storage$load("repos")
  expect_s3_class(loaded, "gitstats_repos")
  expect_equal(attr(loaded, "since"), "2024-01-01")
  expect_equal(attr(loaded, "until"), "2024-12-31")
})

test_that("StorageLocal exists returns TRUE/FALSE correctly", {
  storage <- StorageLocal$new()
  expect_false(storage$exists("missing"))
  storage$save("present", dplyr::tibble(x = 1))
  expect_true(storage$exists("present"))
})

test_that("StorageLocal list returns saved names", {
  storage <- StorageLocal$new()
  expect_null(storage$list())
  storage$save("alpha", dplyr::tibble(x = 1))
  storage$save("beta", dplyr::tibble(y = 2))
  expect_setequal(storage$list(), c("alpha", "beta"))
})

test_that("StorageLocal load returns NULL for missing data", {
  storage <- StorageLocal$new()
  expect_null(storage$load("nonexistent"))
})

test_that("StorageLocal overwrite replaces data", {
  storage <- StorageLocal$new()
  storage$save("data", dplyr::tibble(x = 1))
  storage$save("data", dplyr::tibble(x = 99))
  expect_equal(storage$load("data")$x, 99)
})

test_that("StorageLocal is_db returns FALSE", {
  storage <- StorageLocal$new()
  expect_false(storage$is_db())
})

# set_storage ------------------------------------------------------------------

test_that("set_storage defaults to StorageLocal", {
  gs <- create_gitstats()
  backend <- gs$.__enclos_env__$private$storage_backend
  expect_true(inherits(backend, "StorageLocal"))
  expect_false(backend$is_db())
})

test_that("set_storage errors on unknown type", {
  gs <- create_gitstats()
  expect_error(
    gs$set_storage(type = "redis"),
    "Unknown storage type"
  )
})

test_that("set_storage resets to local", {
  gs <- create_gitstats()
  gs$set_storage(type = "sqlite")
  expect_true(gs$.__enclos_env__$private$storage_backend$is_db())
  gs$set_storage(type = "local")
  expect_false(gs$.__enclos_env__$private$storage_backend$is_db())
})

test_that("set_storage returns self invisibly for piping", {
  gs <- create_gitstats()
  result <- gs$set_storage(type = "local")
  expect_identical(result, gs)
})

# StorageSQLite ----------------------------------------------------------------

test_that("StorageSQLite save and load round-trips data", {
  storage <- StorageSQLite$new()
  df <- dplyr::tibble(a = 1:3, b = c("x", "y", "z"))
  storage$save("test_data", df)
  loaded <- storage$load("test_data")
  expect_equal(loaded$a, df$a)
  expect_equal(loaded$b, df$b)
})

test_that("StorageSQLite preserves class via metadata", {
  storage <- StorageSQLite$new()
  df <- dplyr::tibble(a = 1:3)
  class(df) <- c("gitstats_commits", class(df))
  storage$save("commits", df)
  loaded <- storage$load("commits")
  expect_s3_class(loaded, "gitstats_commits")
})

test_that("StorageSQLite preserves custom attributes via metadata", {
  storage <- StorageSQLite$new()
  df <- dplyr::tibble(a = 1:3)
  class(df) <- c("gitstats_repos", class(df))
  attr(df, "since") <- "2024-01-01"
  attr(df, "until") <- "2024-12-31"
  storage$save("repos", df)
  loaded <- storage$load("repos")
  expect_equal(attr(loaded, "since"), "2024-01-01")
  expect_equal(attr(loaded, "until"), "2024-12-31")
})

test_that("StorageSQLite exists returns TRUE/FALSE correctly", {
  storage <- StorageSQLite$new()
  expect_false(storage$exists("missing"))
  storage$save("present", dplyr::tibble(x = 1))
  expect_true(storage$exists("present"))
})

test_that("StorageSQLite list excludes _metadata table", {
  storage <- StorageSQLite$new()
  storage$save("alpha", dplyr::tibble(x = 1))
  storage$save("beta", dplyr::tibble(y = 2))
  tables <- storage$list()
  expect_true("alpha" %in% tables)
  expect_true("beta" %in% tables)
  expect_false("_metadata" %in% tables)
})

test_that("StorageSQLite load returns NULL for missing data", {
  storage <- StorageSQLite$new()
  expect_null(storage$load("nonexistent"))
})

test_that("StorageSQLite overwrite replaces data", {
  storage <- StorageSQLite$new()
  storage$save("data", dplyr::tibble(x = 1))
  storage$save("data", dplyr::tibble(x = 99))
  expect_equal(storage$load("data")$x, 99)
})

test_that("StorageSQLite is_db returns TRUE", {
  storage <- StorageSQLite$new()
  expect_true(storage$is_db())
})

test_that("StorageSQLite finalize disconnects connection", {
  storage <- StorageSQLite$new()
  conn <- storage$.__enclos_env__$private$conn
  expect_true(DBI::dbIsValid(conn))
  storage$finalize()
  expect_false(DBI::dbIsValid(conn))
})

test_that("StorageSQLite finalize handles NULL connection", {
  storage <- StorageSQLite$new()
  conn <- storage$.__enclos_env__$private$conn
  DBI::dbDisconnect(conn)
  storage$.__enclos_env__$private$conn <- NULL
  expect_no_error(storage$finalize())
})

test_that("StorageSQLite load works when metadata is missing", {
  storage <- StorageSQLite$new()
  conn <- storage$.__enclos_env__$private$conn
  DBI::dbWriteTable(conn, "raw_table", data.frame(x = 1:3))
  loaded <- storage$load("raw_table")
  expect_equal(nrow(loaded), 3)
  expect_true(inherits(loaded, "tbl_df"))
})

test_that("StorageSQLite works with file-based database", {
  tmp <- tempfile(fileext = ".sqlite")
  on.exit(unlink(tmp), add = TRUE)
  storage <- StorageSQLite$new(dbname = tmp)
  storage$save("data", dplyr::tibble(val = 42))
  loaded <- storage$load("data")
  expect_equal(loaded$val, 42)
})

test_that("set_storage creates SQLite backend with dbname", {
  tmp <- tempfile(fileext = ".sqlite")
  on.exit(unlink(tmp), add = TRUE)
  gs <- create_gitstats()
  gs$set_storage(type = "sqlite", dbname = tmp)
  backend <- gs$.__enclos_env__$private$storage_backend
  expect_true(inherits(backend, "StorageSQLite"))
  expect_true(backend$is_db())
})

# GitStats + SQLite integration ------------------------------------------------

test_that("GitStats save_to_storage and get_from_storage work with SQLite", {
  gs <- create_gitstats()
  gs$set_storage(type = "sqlite")
  priv <- gs$.__enclos_env__$private
  df <- dplyr::tibble(repo = "test/repo", stars = 10)
  priv$storage_backend$save("repositories", df)
  expect_false(priv$storage_is_empty("repositories"))
  loaded <- priv$storage_backend$load("repositories")
  expect_equal(loaded$repo, "test/repo")
})

test_that("GitStats get_storage returns all data from SQLite", {
  gs <- create_gitstats()
  gs$set_storage(type = "sqlite")
  priv <- gs$.__enclos_env__$private
  priv$storage_backend$save("repos", dplyr::tibble(x = 1))
  priv$storage_backend$save("commits", dplyr::tibble(y = 2))
  all_data <- gs$get_storage(NULL)
  expect_true("repos" %in% names(all_data))
  expect_true("commits" %in% names(all_data))
})

test_that("GitStats get_storage returns single table from SQLite", {
  gs <- create_gitstats()
  gs$set_storage(type = "sqlite")
  priv <- gs$.__enclos_env__$private
  priv$storage_backend$save("files", dplyr::tibble(path = "R/main.R"))
  result <- gs$get_storage("files")
  expect_equal(result$path, "R/main.R")
})

# check_if_package_installed ---------------------------------------------------

test_that("check_if_package_installed errors for missing package", {
  expect_error(
    check_if_package_installed("nonexistent_pkg_12345"),
    "nonexistent_pkg_12345"
  )
})

test_that("check_if_package_installed passes for installed package", {
  expect_no_error(check_if_package_installed("testthat"))
})

# set_storage wrapper function --------------------------------------------------

test_that("set_storage() exported wrapper calls R6 method", {
  gs <- create_gitstats()
  result <- set_storage(gs, type = "sqlite")
  backend <- gs$.__enclos_env__$private$storage_backend
  expect_true(inherits(backend, "StorageSQLite"))
})

test_that("set_storage postgres branch executes with stubbed connection", {
  gs <- create_gitstats()
  mock_storage <- StorageLocal$new()
  mockery::stub(
    gs$set_storage,
    "do.call",
    mock_storage
  )
  gs$set_storage(type = "postgres", host = "localhost", dbname = "test")
  backend <- gs$.__enclos_env__$private$storage_backend
  expect_true(inherits(backend, "StorageLocal"))
})
