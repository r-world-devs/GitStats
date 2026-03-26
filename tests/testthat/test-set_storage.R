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

# set_*_storage ----------------------------------------------------------------

test_that("default storage is StorageLocal", {
  gs <- create_gitstats()
  backend <- gs$.__enclos_env__$private$storage_backend
  expect_true(inherits(backend, "StorageLocal"))
  expect_false(backend$is_db())
})

test_that("set_local_storage resets to local", {
  gs <- create_gitstats()
  gs$set_sqlite_storage()
  expect_true(gs$.__enclos_env__$private$storage_backend$is_db())
  gs$set_local_storage()
  expect_false(gs$.__enclos_env__$private$storage_backend$is_db())
})

test_that("set_local_storage returns self invisibly for piping", {
  gs <- create_gitstats()
  result <- gs$set_local_storage()
  expect_identical(result, gs)
})

test_that("set_sqlite_storage returns self invisibly for piping", {
  gs <- create_gitstats()
  result <- gs$set_sqlite_storage()
  expect_identical(result, gs)
})

test_that("print shows storage backend type for local", {
  gs <- create_gitstats()
  output <- capture.output(print(gs))
  expect_true(any(grepl("Storage \\[local\\]", output)))
})

test_that("print shows storage backend type for SQLite", {
  gs <- create_gitstats()
  gs$set_sqlite_storage()
  output <- capture.output(print(gs))
  expect_true(any(grepl("Storage \\[SQLite\\]", output)))
})

test_that("print lists stored data on separate lines", {
  gs <- create_gitstats()
  gs$set_sqlite_storage()
  priv <- gs$.__enclos_env__$private
  repos <- dplyr::tibble(repo = c("a/b", "c/d"), stars = c(1, 2))
  class(repos) <- c("gitstats_repos", class(repos))
  priv$storage_backend$save("repositories", repos)
  commits <- dplyr::tibble(sha = "abc123")
  class(commits) <- c("gitstats_commits", class(commits))
  attr(commits, "date_range") <- c("2024-01-01", "2024-06-30")
  priv$storage_backend$save("commits", commits)
  output <- capture.output(print(gs))
  storage_lines <- output[grepl("Storage|Repositories|Commits", output)]
  expect_true(any(grepl("Storage \\[SQLite\\]", storage_lines)))
  expect_true(any(grepl("Repositories: 2", storage_lines)))
  expect_true(any(grepl("Commits: 1", storage_lines)))
  storage_label_line <- grep("Storage \\[SQLite\\]", output)
  expect_false(grepl("Repositories|Commits", output[storage_label_line]))
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

test_that("StorageSQLite preserves difftime columns", {
  storage <- StorageSQLite$new()
  df <- dplyr::tibble(
    repo = "test/repo",
    last_activity = as.difftime(c(38.5, 12.3), units = "days")
  )
  storage$save("repos", df)
  loaded <- storage$load("repos")
  expect_s3_class(loaded$last_activity, "difftime")
  expect_equal(attr(loaded$last_activity, "units"), "days")
  expect_equal(as.numeric(loaded$last_activity), c(38.5, 12.3))
})

test_that("StorageSQLite preserves POSIXct columns", {
  storage <- StorageSQLite$new()
  timestamps <- as.POSIXct(c("2024-01-15 10:30:00", "2024-06-20 14:00:00"))
  df <- dplyr::tibble(
    repo = "test/repo",
    created_at = timestamps,
    last_activity_at = timestamps
  )
  storage$save("repos", df)
  loaded <- storage$load("repos")
  expect_s3_class(loaded$created_at, "POSIXct")
  expect_s3_class(loaded$last_activity_at, "POSIXct")
  expect_equal(
    format(loaded$created_at, "%Y-%m-%d %H:%M:%S"),
    format(timestamps, "%Y-%m-%d %H:%M:%S")
  )
})

test_that("StorageSQLite preserves mixed difftime and POSIXct columns", {
  storage <- StorageSQLite$new()
  df <- dplyr::tibble(
    repo = "test/repo",
    created_at = as.POSIXct("2024-01-15 10:30:00"),
    last_activity_at = as.POSIXct("2024-06-20 14:00:00"),
    last_activity = as.difftime(38.5, units = "days")
  )
  class(df) <- c("gitstats_repos", class(df))
  storage$save("repos", df)
  loaded <- storage$load("repos")
  expect_s3_class(loaded, "gitstats_repos")
  expect_s3_class(loaded$created_at, "POSIXct")
  expect_s3_class(loaded$last_activity_at, "POSIXct")
  expect_s3_class(loaded$last_activity, "difftime")
  expect_equal(as.numeric(loaded$last_activity), 38.5)
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
  storage$.__enclos_env__$private$finalize()
  expect_false(DBI::dbIsValid(conn))
})

test_that("StorageSQLite finalize handles NULL connection", {
  storage <- StorageSQLite$new()
  conn <- storage$.__enclos_env__$private$conn
  DBI::dbDisconnect(conn)
  storage$.__enclos_env__$private$conn <- NULL
  expect_no_error(storage$.__enclos_env__$private$finalize())
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

test_that("set_sqlite_storage creates SQLite backend with dbname", {
  tmp <- tempfile(fileext = ".sqlite")
  on.exit(unlink(tmp), add = TRUE)
  gs <- create_gitstats()
  gs$set_sqlite_storage(dbname = tmp)
  backend <- gs$.__enclos_env__$private$storage_backend
  expect_true(inherits(backend, "StorageSQLite"))
  expect_true(backend$is_db())
})

# GitStats + SQLite integration ------------------------------------------------

test_that("GitStats save_to_storage and get_from_storage work with SQLite", {
  gs <- create_gitstats()
  gs$set_sqlite_storage()
  priv <- gs$.__enclos_env__$private
  df <- dplyr::tibble(repo = "test/repo", stars = 10)
  priv$storage_backend$save("repositories", df)
  expect_false(priv$storage_is_empty("repositories"))
  loaded <- priv$storage_backend$load("repositories")
  expect_equal(loaded$repo, "test/repo")
})

test_that("GitStats get_storage returns all data from SQLite", {
  gs <- create_gitstats()
  gs$set_sqlite_storage()
  priv <- gs$.__enclos_env__$private
  priv$storage_backend$save("repos", dplyr::tibble(x = 1))
  priv$storage_backend$save("commits", dplyr::tibble(y = 2))
  all_data <- gs$get_storage(NULL)
  expect_true("repos" %in% names(all_data))
  expect_true("commits" %in% names(all_data))
})

test_that("GitStats get_storage returns single table from SQLite", {
  gs <- create_gitstats()
  gs$set_sqlite_storage()
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

# Exported wrapper functions ----------------------------------------------------

test_that("set_local_storage() wrapper calls R6 method", {
  gs <- create_gitstats()
  gs$set_sqlite_storage()
  result <- set_local_storage(gs)
  backend <- gs$.__enclos_env__$private$storage_backend
  expect_true(inherits(backend, "StorageLocal"))
})

test_that("set_sqlite_storage() wrapper calls R6 method", {
  gs <- create_gitstats()
  result <- set_sqlite_storage(gs)
  backend <- gs$.__enclos_env__$private$storage_backend
  expect_true(inherits(backend, "StorageSQLite"))
})

test_that("set_postgres_storage() R6 method executes with stubbed connection", {
  gs <- create_gitstats()
  mock_storage <- StorageLocal$new()
  mockery::stub(
    gs$set_postgres_storage,
    "do.call",
    mock_storage
  )
  gs$set_postgres_storage(
    host = "localhost",
    port = 5432,
    dbname = "test",
    user = "postgres",
    password = "secret",
    schema = "my_schema"
  )
  backend <- gs$.__enclos_env__$private$storage_backend
  expect_true(inherits(backend, "StorageLocal"))
})

test_that("set_postgres_storage() exported wrapper calls R6 method", {
  gs <- create_gitstats()
  mock_storage <- StorageLocal$new()
  mockery::stub(
    set_postgres_storage,
    "gitstats$set_postgres_storage",
    mock_storage
  )
  set_postgres_storage(
    gs,
    host = "localhost",
    port = 5432,
    dbname = "test",
    user = "postgres",
    password = "secret"
  )
  backend <- gs$.__enclos_env__$private$storage_backend
  expect_true(inherits(backend, "StorageLocal"))
})

test_that("print shows PostgreSQL backend type", {
  gs <- create_gitstats()
  mock_backend <- StorageLocal$new()
  class(mock_backend) <- c("StoragePostgres", class(mock_backend))
  gs$.__enclos_env__$private$storage_backend <- mock_backend
  output <- capture.output(print(gs))
  expect_true(any(grepl("Storage \\[PostgreSQL\\]", output)))
})

# Storage propagation to hosts -------------------------------------------------

test_that("set_sqlite_storage propagates backend to hosts", {
  gs <- create_test_gitstats(hosts = 1)
  suppressMessages(gs$set_sqlite_storage())
  host <- gs$.__enclos_env__$private$hosts[[1]]
  host_storage <- host$.__enclos_env__$private$storage_backend
  expect_true(inherits(host_storage, "StorageSQLite"))
})

test_that("set_local_storage propagates backend to hosts", {
  gs <- create_test_gitstats(hosts = 1)
  suppressMessages(gs$set_sqlite_storage())
  gs$set_local_storage()
  host <- gs$.__enclos_env__$private$hosts[[1]]
  host_storage <- host$.__enclos_env__$private$storage_backend
  expect_true(inherits(host_storage, "StorageLocal"))
})

test_that("add_new_host propagates current storage to new host", {
  gs <- create_gitstats()
  suppressMessages(gs$set_sqlite_storage())
  gs$.__enclos_env__$private$hosts[[1]] <- create_github_testhost(
    orgs = "test_org"
  )
  gs$.__enclos_env__$private$propagate_storage_to_hosts()
  host <- gs$.__enclos_env__$private$hosts[[1]]
  host_storage <- host$.__enclos_env__$private$storage_backend
  expect_true(inherits(host_storage, "StorageSQLite"))
})

# report_storage_contents ------------------------------------------------------

test_that("set_sqlite_storage reports empty database", {
  gs <- create_gitstats()
  output <- capture.output(
    gs$set_sqlite_storage(),
    type = "message"
  )
  expect_true(any(grepl("Database is empty", output)))
})

test_that("set_sqlite_storage reports existing data", {
  tmp <- tempfile(fileext = ".sqlite")
  on.exit(unlink(tmp), add = TRUE)
  storage <- StorageSQLite$new(dbname = tmp)
  df <- dplyr::tibble(repo = "test/repo", stars = 10L)
  class(df) <- c("gitstats_repos", class(df))
  storage$save("repositories", df)
  commits <- dplyr::tibble(id = "abc123")
  class(commits) <- c("gitstats_commits", class(commits))
  storage$save("commits", commits)
  rm(storage)
  gc()

  gs <- create_gitstats()
  output <- capture.output(
    gs$set_sqlite_storage(dbname = tmp),
    type = "message"
  )
  expect_true(any(grepl("Database contains data", output)))
  expect_true(any(grepl("repositories.*1", output)))
  expect_true(any(grepl("commits.*1", output)))
})

# GitHost set_storage_backend --------------------------------------------------

test_that("GitHost set_storage_backend sets storage", {
  host <- create_github_testhost(orgs = "test_org")
  storage <- StorageSQLite$new()
  host$set_storage_backend(storage)
  host_storage <- host$.__enclos_env__$private$storage_backend
  expect_true(inherits(host_storage, "StorageSQLite"))
})

# save_repos_to_storage --------------------------------------------------------

test_that("GitHub save_repos_to_storage saves repos to database", {
  host <- create_github_testhost(orgs = "test_org")
  storage <- StorageSQLite$new()
  host$set_storage_backend(storage)
  priv <- host$.__enclos_env__$private

  mock_repos_table <- dplyr::tibble(
    repo_id = "123",
    repo_name = "test-repo",
    default_branch = "main",
    organization = "test_org"
  )
  mock_engine <- list(
    prepare_repos_table = function(repos_from_org, org) mock_repos_table
  )

  priv$save_repos_to_storage(list(), "test_org", mock_engine)

  loaded <- storage$load("repositories")
  expect_equal(nrow(loaded), 1)
  expect_equal(loaded$repo_id, "123")
  expect_s3_class(loaded, "gitstats_repos")
})

test_that("GitHub save_repos_to_storage merges with existing repos", {
  host <- create_github_testhost(orgs = "test_org")
  storage <- StorageSQLite$new()
  host$set_storage_backend(storage)
  priv <- host$.__enclos_env__$private

  existing <- dplyr::tibble(
    repo_id = "100",
    repo_name = "old-repo",
    default_branch = "main",
    organization = "old_org"
  )
  class(existing) <- c("gitstats_repos", class(existing))
  storage$save("repositories", existing)

  new_repos <- dplyr::tibble(
    repo_id = "200",
    repo_name = "new-repo",
    default_branch = "main",
    organization = "test_org"
  )
  mock_engine <- list(
    prepare_repos_table = function(repos_from_org, org) new_repos
  )

  priv$save_repos_to_storage(list(), "test_org", mock_engine)

  loaded <- storage$load("repositories")
  expect_equal(nrow(loaded), 2)
  expect_true("100" %in% loaded$repo_id)
  expect_true("200" %in% loaded$repo_id)
})

test_that("GitHub save_repos_to_storage deduplicates by repo_id", {
  host <- create_github_testhost(orgs = "test_org")
  storage <- StorageSQLite$new()
  host$set_storage_backend(storage)
  priv <- host$.__enclos_env__$private

  existing <- dplyr::tibble(
    repo_id = "123",
    repo_name = "test-repo",
    default_branch = "main",
    organization = "test_org"
  )
  class(existing) <- c("gitstats_repos", class(existing))
  storage$save("repositories", existing)

  duplicate_repos <- dplyr::tibble(
    repo_id = "123",
    repo_name = "test-repo-updated",
    default_branch = "develop",
    organization = "test_org"
  )
  mock_engine <- list(
    prepare_repos_table = function(repos_from_org, org) duplicate_repos
  )

  priv$save_repos_to_storage(list(), "test_org", mock_engine)

  loaded <- storage$load("repositories")
  expect_equal(nrow(loaded), 1)
})

test_that("GitHub save_repos_to_storage skips when no db storage", {
  host <- create_github_testhost(orgs = "test_org")
  priv <- host$.__enclos_env__$private
  # storage_backend is NULL by default
  expect_no_error(
    priv$save_repos_to_storage(list(), "test_org", list())
  )
})

test_that("GitHub save_repos_to_storage skips when storage is local", {
  host <- create_github_testhost(orgs = "test_org")
  storage <- StorageLocal$new()
  host$set_storage_backend(storage)
  priv <- host$.__enclos_env__$private
  mock_engine <- list(
    prepare_repos_table = function(repos_from_org, org) {
      dplyr::tibble(repo_id = "1", repo_name = "r")
    }
  )
  priv$save_repos_to_storage(list(), "test_org", mock_engine)
  expect_null(storage$load("repositories"))
})

test_that("GitLab save_repos_to_storage saves repos to database", {
  host <- create_gitlab_testhost(orgs = "test_group")
  storage <- StorageSQLite$new()
  host$set_storage_backend(storage)
  priv <- host$.__enclos_env__$private

  mock_repos_table <- dplyr::tibble(
    repo_id = "456",
    repo_name = "gl-repo",
    default_branch = "main",
    organization = "test_group"
  )
  mock_engine <- list(
    prepare_repos_table = function(repos_from_org, org) mock_repos_table
  )

  priv$save_repos_to_storage(list(), "test_group", mock_engine)

  loaded <- storage$load("repositories")
  expect_equal(nrow(loaded), 1)
  expect_equal(loaded$repo_id, "456")
  expect_s3_class(loaded, "gitstats_repos")
})

# add_new_host propagates storage ----------------------------------------------

test_that("add_new_host propagates storage backend to host", {
  gs <- create_gitstats()
  suppressMessages(gs$set_sqlite_storage())
  priv <- gs$.__enclos_env__$private
  new_host <- create_github_testhost(orgs = "test_org")
  priv$add_new_host(new_host)
  host_storage <- priv$hosts[[1]]$.__enclos_env__$private$storage_backend
  expect_true(inherits(host_storage, "StorageSQLite"))
})


