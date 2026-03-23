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

# StoragePostgres (mocked) -----------------------------------------------------

# Helper: create a StoragePostgres with all DBI calls mocked
create_mock_postgres <- function(schema = "git_stats") {
  mock_conn <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
  # Create schema-less metadata table for mock
  DBI::dbExecute(mock_conn, "CREATE TABLE IF NOT EXISTS _metadata (
    dataset_name TEXT PRIMARY KEY,
    metadata TEXT NOT NULL
  )")

  mockery::stub(StoragePostgres$new, "DBI::dbConnect", mock_conn)
  mockery::stub(StoragePostgres$new, "RPostgres::Postgres", function() "mock_driver")
  mockery::stub(StoragePostgres$new, "DBI::dbIsValid", TRUE)
  mockery::stub(StoragePostgres$new, "DBI::dbExecute", 0L)
  mockery::stub(StoragePostgres$new, "DBI::dbExistsTable", TRUE)

  storage <- StoragePostgres$new(schema = schema)
  # Replace conn with real SQLite conn for subsequent method calls
  storage$.__enclos_env__$private$conn <- mock_conn
  storage
}

test_that("StoragePostgres initialize sets connection and schema", {
  skip_if(integration_tests_skipped)
  storage <- create_mock_postgres(schema = "test_schema")
  on.exit(DBI::dbDisconnect(storage$.__enclos_env__$private$conn), add = TRUE)
  expect_true(inherits(storage, "StoragePostgres"))
  expect_true(inherits(storage, "Storage"))
  expect_equal(storage$.__enclos_env__$private$schema, "test_schema")
})

test_that("StoragePostgres initialize aborts on invalid connection", {
  skip_if(integration_tests_skipped)
  mockery::stub(StoragePostgres$new, "DBI::dbConnect", structure(list(), class = "mock_conn"))
  mockery::stub(StoragePostgres$new, "RPostgres::Postgres", function() "mock_driver")
  mockery::stub(StoragePostgres$new, "DBI::dbIsValid", FALSE)
  expect_error(
    StoragePostgres$new(),
    "Failed to connect"
  )
})

test_that("StoragePostgres is_db returns TRUE", {
  skip_if(integration_tests_skipped)
  storage <- create_mock_postgres()
  on.exit(DBI::dbDisconnect(storage$.__enclos_env__$private$conn), add = TRUE)
  expect_true(storage$is_db())
})

test_that("StoragePostgres save writes table and metadata", {
  skip_if(integration_tests_skipped)
  storage <- create_mock_postgres()
  conn <- storage$.__enclos_env__$private$conn
  on.exit(DBI::dbDisconnect(conn), add = TRUE)

  df <- dplyr::tibble(a = 1:3, b = c("x", "y", "z"))
  class(df) <- c("gitstats_commits", class(df))
  attr(df, "since") <- "2024-01-01"

  # Stub DBI calls in save() and in private$save_metadata()
  mockery::stub(storage$save, "DBI::dbWriteTable", TRUE)
  priv <- storage$.__enclos_env__$private
  mockery::stub(priv$save_metadata, "DBI::dbExecute", 0L)
  storage$save("commits", df)

  expect_true(TRUE)
})

test_that("StoragePostgres save strips gitstats_ class prefix", {
  skip_if(integration_tests_skipped)
  storage <- create_mock_postgres()
  conn <- storage$.__enclos_env__$private$conn
  on.exit(DBI::dbDisconnect(conn), add = TRUE)
  priv <- storage$.__enclos_env__$private

  df <- dplyr::tibble(x = 1)
  class(df) <- c("gitstats_repos", "tbl_df", "tbl", "data.frame")

  written_data <- NULL
  mockery::stub(storage$save, "DBI::dbWriteTable", function(conn, name, value, ...) {
    written_data <<- value
    TRUE
  })
  mockery::stub(priv$save_metadata, "DBI::dbExecute", 0L)
  storage$save("repos", df)

  expect_false("gitstats_repos" %in% class(written_data))
})

test_that("StoragePostgres save preserves custom attributes in metadata", {
  skip_if(integration_tests_skipped)
  storage <- create_mock_postgres()
  conn <- storage$.__enclos_env__$private$conn
  on.exit(DBI::dbDisconnect(conn), add = TRUE)
  priv <- storage$.__enclos_env__$private

  df <- dplyr::tibble(x = 1)
  attr(df, "since") <- "2024-01-01"
  attr(df, "until") <- "2024-12-31"

  captured_meta <- NULL
  mockery::stub(storage$save, "DBI::dbWriteTable", TRUE)
  mockery::stub(priv$save_metadata, "DBI::dbExecute", function(conn, sql, ...) {
    args <- list(...)
    if (!is.null(args$params) && length(args$params) >= 2) {
      captured_meta <<- args$params[[2]]
    }
    0L
  })
  storage$save("data", df)

  expect_false(is.null(captured_meta))
  meta <- jsonlite::fromJSON(captured_meta)
  expect_true("since" %in% names(meta$attributes))
  expect_true("until" %in% names(meta$attributes))
})

test_that("StoragePostgres load returns NULL when table does not exist", {
  skip_if(integration_tests_skipped)
  storage <- create_mock_postgres()
  conn <- storage$.__enclos_env__$private$conn
  on.exit(DBI::dbDisconnect(conn), add = TRUE)

  mockery::stub(storage$exists, "DBI::dbExistsTable", FALSE)
  mockery::stub(storage$load, "self$exists", FALSE)
  result <- storage$load("nonexistent")
  expect_null(result)
})

test_that("StoragePostgres load reads table and restores metadata", {
  skip_if(integration_tests_skipped)
  storage <- create_mock_postgres()
  conn <- storage$.__enclos_env__$private$conn
  on.exit(DBI::dbDisconnect(conn), add = TRUE)
  priv <- storage$.__enclos_env__$private

  mock_data <- data.frame(a = 1:3, b = c("x", "y", "z"))
  mock_meta <- list(
    class = c("gitstats_commits", "tbl_df", "tbl", "data.frame"),
    attributes = list(since = "2024-01-01")
  )

  mockery::stub(storage$load, "self$exists", TRUE)
  mockery::stub(storage$load, "DBI::dbReadTable", mock_data)
  mockery::stub(priv$load_metadata, "DBI::dbGetQuery", data.frame(
    metadata = as.character(jsonlite::toJSON(mock_meta, auto_unbox = TRUE)),
    stringsAsFactors = FALSE
  ))

  loaded <- storage$load("commits")
  expect_s3_class(loaded, "gitstats_commits")
  expect_equal(attr(loaded, "since"), "2024-01-01")
})

test_that("StoragePostgres load works when no metadata exists", {
  skip_if(integration_tests_skipped)
  storage <- create_mock_postgres()
  conn <- storage$.__enclos_env__$private$conn
  on.exit(DBI::dbDisconnect(conn), add = TRUE)
  priv <- storage$.__enclos_env__$private

  mock_data <- data.frame(x = 1:3)

  mockery::stub(storage$load, "self$exists", TRUE)
  mockery::stub(storage$load, "DBI::dbReadTable", mock_data)
  mockery::stub(priv$load_metadata, "DBI::dbGetQuery", data.frame(
    metadata = character(0),
    stringsAsFactors = FALSE
  ))

  loaded <- storage$load("raw_data")
  expect_true(inherits(loaded, "tbl_df"))
  expect_equal(nrow(loaded), 3)
})

test_that("StoragePostgres exists delegates to DBI::dbExistsTable", {
  skip_if(integration_tests_skipped)
  storage <- create_mock_postgres()
  conn <- storage$.__enclos_env__$private$conn
  on.exit(DBI::dbDisconnect(conn), add = TRUE)

  mockery::stub(storage$exists, "DBI::dbExistsTable", TRUE)
  expect_true(storage$exists("some_table"))

  mockery::stub(storage$exists, "DBI::dbExistsTable", FALSE)
  expect_false(storage$exists("missing_table"))
})

test_that("StoragePostgres list filters tables by schema", {
  skip_if(integration_tests_skipped)
  storage <- create_mock_postgres()
  conn <- storage$.__enclos_env__$private$conn
  on.exit(DBI::dbDisconnect(conn), add = TRUE)

  mockery::stub(storage$list, "DBI::dbListTables", c("commits", "repos", "other"))
  mockery::stub(storage$list, "DBI::dbExistsTable", function(conn, id) {
    table_name <- if (inherits(id, "Id")) id@name[["table"]] else id
    table_name %in% c("commits", "repos")
  })

  tables <- storage$list()
  expect_equal(sort(tables), c("commits", "repos"))
})

test_that("StoragePostgres finalize disconnects", {
  skip_if(integration_tests_skipped)
  storage <- create_mock_postgres()
  conn <- storage$.__enclos_env__$private$conn
  expect_true(DBI::dbIsValid(conn))
  storage$finalize()
  expect_false(DBI::dbIsValid(conn))
})

test_that("StoragePostgres finalize handles NULL connection", {
  skip_if(integration_tests_skipped)
  storage <- create_mock_postgres()
  conn <- storage$.__enclos_env__$private$conn
  DBI::dbDisconnect(conn)
  storage$.__enclos_env__$private$conn <- NULL
  expect_no_error(storage$finalize())
})

test_that("StoragePostgres qualified_name builds schema.table", {
  skip_if(integration_tests_skipped)
  storage <- create_mock_postgres(schema = "my_schema")
  on.exit(DBI::dbDisconnect(storage$.__enclos_env__$private$conn), add = TRUE)
  qname <- storage$.__enclos_env__$private$qualified_name("commits")
  expect_equal(qname, "my_schema.commits")
})

test_that("StoragePostgres ensure_schema creates schema", {
  skip_if(integration_tests_skipped)
  mock_conn <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
  on.exit(DBI::dbDisconnect(mock_conn), add = TRUE)

  mockery::stub(StoragePostgres$new, "DBI::dbConnect", mock_conn)
  mockery::stub(StoragePostgres$new, "RPostgres::Postgres", function() "mock")
  mockery::stub(StoragePostgres$new, "DBI::dbIsValid", TRUE)

  executed_sql <- NULL
  mockery::stub(StoragePostgres$new, "DBI::dbExecute", function(conn, sql, ...) {
    executed_sql <<- c(executed_sql, sql)
    0L
  })
  mockery::stub(StoragePostgres$new, "DBI::dbExistsTable", TRUE)

  storage <- StoragePostgres$new(schema = "custom_schema")
  expect_true(any(grepl("CREATE SCHEMA IF NOT EXISTS custom_schema", executed_sql)))
})

test_that("StoragePostgres ensure_metadata_table creates table when missing", {
  skip_if(integration_tests_skipped)
  mock_conn <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
  on.exit(DBI::dbDisconnect(mock_conn), add = TRUE)

  mockery::stub(StoragePostgres$new, "DBI::dbConnect", mock_conn)
  mockery::stub(StoragePostgres$new, "RPostgres::Postgres", function() "mock")
  mockery::stub(StoragePostgres$new, "DBI::dbIsValid", TRUE)

  executed_sql <- NULL
  mockery::stub(StoragePostgres$new, "DBI::dbExecute", function(conn, sql, ...) {
    executed_sql <<- c(executed_sql, sql)
    0L
  })
  mockery::stub(StoragePostgres$new, "DBI::dbExistsTable", FALSE)

  storage <- StoragePostgres$new(schema = "git_stats")
  expect_true(any(grepl("CREATE TABLE.*_metadata", executed_sql)))
})

test_that("set_storage creates StoragePostgres with mocked connection", {
  skip_if(integration_tests_skipped)
  gs <- create_gitstats()
  mock_conn <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")

  mockery::stub(gs$set_storage, "do.call", function(fn, args) {
    s <- StorageLocal$new()
    class(s) <- c("StoragePostgres", class(s))
    s$is_db <- function() TRUE
    s
  })

  gs$set_storage(type = "postgres", host = "localhost", dbname = "test")
  backend <- gs$.__enclos_env__$private$storage_backend
  expect_true(backend$is_db())
  DBI::dbDisconnect(mock_conn)
})
