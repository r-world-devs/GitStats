#' @title Set local (in-memory) storage
#' @name set_local_storage
#' @description Reset storage to the default in-memory backend.
#' @param gitstats A GitStats object.
#' @return A `GitStats` object (invisibly).
#' @examples
#' \dontrun{
#'   my_gitstats <- create_gitstats() |>
#'     set_local_storage()
#' }
#' @export
set_local_storage <- function(gitstats) {
  gitstats$set_local_storage()
}

#' @title Set PostgreSQL storage
#' @name set_postgres_storage
#' @description Persist GitStats data in a PostgreSQL database. R classes,
#'   custom attributes, and column types are preserved via a `_metadata` table.
#'   Requires `DBI`, `RPostgres`, and `jsonlite` packages.
#' @param gitstats A GitStats object.
#' @param host A character, database host.
#' @param port An integer, database port.
#' @param dbname A character, database name.
#' @param user A character, database user.
#' @param password A character, database password.
#' @param schema A character, database schema (default `"git_stats"`).
#' @param ... Additional arguments passed to
#'   `DBI::dbConnect(RPostgres::Postgres(), ...)`.
#' @return A `GitStats` object (invisibly).
#' @examples
#' \dontrun{
#'   my_gitstats <- create_gitstats() |>
#'     set_postgres_storage(
#'       dbname = "my_database",
#'       host = "localhost",
#'       user = "postgres",
#'       password = "secret"
#'     )
#' }
#' @export
set_postgres_storage <- function(gitstats,
                                 host = NULL,
                                 port = NULL,
                                 dbname = NULL,
                                 user = NULL,
                                 password = NULL,
                                 schema = "git_stats",
                                 ...) {
  gitstats$set_postgres_storage(
    host = host,
    port = port,
    dbname = dbname,
    user = user,
    password = password,
    schema = schema,
    ...
  )
}

#' @title Set SQLite storage
#' @name set_sqlite_storage
#' @description Persist GitStats data in a SQLite database. R classes,
#'   custom attributes, and column types are preserved via a `_metadata` table.
#'   Requires `DBI`, `RSQLite`, and `jsonlite` packages.
#' @param gitstats A GitStats object.
#' @param dbname A character, path to SQLite file. Defaults to `":memory:"`
#'   for an in-memory database.
#' @return A `GitStats` object (invisibly).
#' @examples
#' \dontrun{
#'   # File-based
#'   my_gitstats <- create_gitstats() |>
#'     set_sqlite_storage(dbname = "gitstats.sqlite")
#'
#'   # In-memory
#'   my_gitstats <- create_gitstats() |>
#'     set_sqlite_storage()
#' }
#' @export
set_sqlite_storage <- function(gitstats, dbname = ":memory:") {
  gitstats$set_sqlite_storage(dbname = dbname)
}

#' @title Get data from `GitStats` storage
#' @name get_storage
#' @description Retrieves whole or particular data (see `storage` parameter)
#'   pulled earlier with `GitStats`.
#' @param gitstats A GitStats object.
#' @param storage A character, type of the data you want to get from storage:
#'   `commits`, `repositories`, `release_logs`, `users`, `files`,
#'   `files_structure`, `R_package_usage` or `release_logs`.
#' @return A list of tibbles (if `storage` set to `NULL`) or a tibble (if
#'   `storage` defined).
#' @examples
#' \dontrun{
#'  my_gitstats <- create_gitstats() |>
#'   set_github_host(
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs", "openpharma")
#'   )
#'   get_release_logs(my_gistats, since = "2024-01-01")
#'   get_repos(my_gitstats)
#'
#'   release_logs <- get_storage(
#'     gitstats = my_gitstats,
#'     storage = "release_logs"
#'   )
#' }
#' @export
get_storage <- function(gitstats,
                        storage = NULL) {
  gitstats$get_storage(
    storage = storage
  )
}

#' @title Remove a table from `GitStats` storage
#' @name remove_from_storage
#' @description Removes a named table from the active storage backend.
#' @param gitstats A GitStats object.
#' @param storage A character, name of the table to remove (e.g. `"commits"`,
#'   `"repositories"`).
#' @return A `GitStats` object (invisibly).
#' @examples
#' \dontrun{
#'   my_gitstats <- create_gitstats() |>
#'     set_github_host(
#'       token = Sys.getenv("GITHUB_PAT"),
#'       orgs = "r-world-devs"
#'     )
#'   get_commits(my_gitstats, since = "2024-01-01")
#'   remove_from_storage(my_gitstats, storage = "commits")
#' }
#' @export
remove_from_storage <- function(gitstats, storage) {
  gitstats$remove_from_storage(storage = storage)
}

#' @title Remove PostgreSQL storage
#' @name remove_postgres_storage
#' @description Drops the GitStats schema (with all tables and metadata) from
#'   the PostgreSQL database, closes the connection, and reverts storage to the
#'   default in-memory local backend. Errors if no PostgreSQL backend is
#'   currently set.
#' @param gitstats A GitStats object.
#' @return A `GitStats` object (invisibly).
#' @examples
#' \dontrun{
#'   my_gitstats <- create_gitstats() |>
#'     set_postgres_storage(
#'       dbname = "my_database",
#'       host = "localhost",
#'       user = "postgres",
#'       password = "secret"
#'     )
#'   remove_postgres_storage(my_gitstats)
#' }
#' @export
remove_postgres_storage <- function(gitstats) {
  gitstats$remove_postgres_storage()
}

#' @title Remove SQLite storage
#' @name remove_sqlite_storage
#' @description Closes the SQLite connection and, for file-based databases,
#'   deletes the database file. For in-memory databases the data is simply
#'   discarded. Storage is reverted to the default in-memory local backend.
#'   Errors if no SQLite backend is currently set.
#' @param gitstats A GitStats object.
#' @return A `GitStats` object (invisibly).
#' @examples
#' \dontrun{
#'   my_gitstats <- create_gitstats() |>
#'     set_sqlite_storage(dbname = "gitstats.sqlite")
#'   remove_sqlite_storage(my_gitstats)
#' }
#' @export
remove_sqlite_storage <- function(gitstats) {
  gitstats$remove_sqlite_storage()
}

#' @title Get metadata for a storage table
#' @name get_storage_metadata
#' @description Retrieves metadata (R classes, custom attributes, column types)
#'   for a table stored in the active storage backend.
#' @param gitstats A GitStats object.
#' @param storage A character, name of the table (e.g. `"commits"`,
#'   `"repositories"`). If `NULL` (default), metadata for all tables in storage
#'   will be returned.
#' @return A list with metadata fields: `class`, `attributes`, and (for
#'   database backends) `column_types`.
#' @examples
#' \dontrun{
#'   my_gitstats <- create_gitstats() |>
#'     set_github_host(
#'       token = Sys.getenv("GITHUB_PAT"),
#'       orgs = "r-world-devs"
#'     )
#'   get_commits(my_gitstats, since = "2024-01-01")
#'   get_storage_metadata(my_gitstats, storage = "commits")
#' }
#' @export
get_storage_metadata <- function(gitstats, storage = NULL) {
  gitstats$get_storage_metadata(storage = storage)
}

#' @noRd
Storage <- R6::R6Class(
  classname = "Storage",
  public = list(
    save = function(name, data) {
      stop("Not implemented")
    },
    load = function(name) {
      stop("Not implemented")
    },
    exists = function(name) {
      stop("Not implemented")
    },
    remove = function(name) {
      stop("Not implemented")
    },
    drop_storage = function() {
      stop("Not implemented")
    },
    list = function() {
      stop("Not implemented")
    },
    get_metadata = function(name = NULL) {
      stop("Not implemented")
    },
    is_db = function() {
      FALSE
    }
  )
)

#' @noRd
StorageLocal <- R6::R6Class(
  classname = "StorageLocal",
  inherit = Storage,
  public = list(
    initialize = function() {
      private$data <- list()
    },
    save = function(name, data) {
      private$data[[name]] <- data
    },
    load = function(name) {
      private$data[[name]]
    },
    exists = function(name) {
      !is.null(private$data[[name]])
    },
    remove = function(name) {
      private$data[[name]] <- NULL
    },
    drop_storage = function() {
      private$data <- list()
    },
    list = function() {
      names(purrr::discard(private$data, is.null))
    },
    get_metadata = function(name = NULL) {
      if (is.null(name)) {
        names_list <- self$list()
        if (length(names_list) == 0) {
          return(private$empty_metadata_tibble())
        }
        build_row <- private$build_metadata_row
        rows <- purrr::map(names_list, function(n) build_row(n))
        return(dplyr::bind_rows(rows))
      }
      data <- private$data[[name]]
      if (is.null(data)) {
        return(private$empty_metadata_tibble())
      }
      private$build_metadata_row(name)
    }
  ),
  private = list(
    data = list(),
    build_metadata_row = function(name) {
      data <- private$data[[name]]
      custom_attrs <- setdiff(
        names(attributes(data)),
        c("names", "row.names", "class")
      )
      attrs <- list()
      for (attr_name in custom_attrs) {
        attrs[[attr_name]] <- attr(data, attr_name)
      }
      dplyr::tibble(
        table_name = name,
        class = list(class(data)),
        attributes = list(attrs)
      )
    },
    empty_metadata_tibble = function() {
      dplyr::tibble(
        table_name = character(),
        class = list(),
        attributes = list()
      )
    }
  )
)

#' @noRd
StoragePostgres <- R6::R6Class(
  classname = "StoragePostgres",
  inherit = Storage,
  public = list(
    initialize = function(schema = "git_stats", ...) {
      check_if_package_installed("DBI")
      check_if_package_installed("RPostgres")
      check_if_package_installed("jsonlite")
      private$conn <- DBI::dbConnect(RPostgres::Postgres(), ...)
      if (!DBI::dbIsValid(private$conn)) {
        cli::cli_abort("Failed to connect to the database.")
      }
      private$schema <- schema
      private$ensure_schema()
      private$ensure_metadata_table()
    },
    save = function(name, data) {
      qualified <- private$qualified_name(name)
      meta <- list(
        class = class(data),
        attributes = list()
      )
      custom_attrs <- setdiff(
        names(attributes(data)),
        c("names", "row.names", "class")
      )
      for (attr_name in custom_attrs) {
        meta$attributes[[attr_name]] <- attr(data, attr_name)
      }
      plain_data <- data
      class(plain_data) <- class(plain_data)[!grepl("^gitstats_", class(plain_data))]
      serialized <- private$serialize_columns(plain_data)
      plain_data <- serialized$data
      meta$column_types <- serialized$column_types
      DBI::dbWriteTable(
        private$conn,
        DBI::Id(schema = private$schema, table = name),
        plain_data,
        overwrite = TRUE
      )
      private$save_metadata(name, meta)
    },
    load = function(name) {
      if (!self$exists(name)) {
        return(NULL)
      }
      data <- DBI::dbReadTable(
        private$conn,
        DBI::Id(schema = private$schema, table = name)
      ) |>
        dplyr::as_tibble()
      meta <- private$load_metadata(name)
      if (!is.null(meta)) {
        if (!is.null(meta$column_types)) {
          data <- private$restore_columns(data, meta$column_types)
        }
        if (!is.null(meta$class)) {
          class(data) <- meta$class
        }
        if (!is.null(meta$attributes)) {
          for (attr_name in names(meta$attributes)) {
            attr(data, attr_name) <- meta$attributes[[attr_name]]
          }
        }
      }
      return(data)
    },
    exists = function(name) {
      DBI::dbExistsTable(
        private$conn,
        DBI::Id(schema = private$schema, table = name)
      )
    },
    remove = function(name) {
      if (self$exists(name)) {
        DBI::dbRemoveTable(
          private$conn,
          DBI::Id(schema = private$schema, table = name)
        )
        DBI::dbExecute(
          private$conn,
          glue::glue(
            "DELETE FROM {private$schema}._metadata
             WHERE dataset_name = $1"
          ),
          params = list(name)
        )
      }
      invisible(NULL)
    },
    drop_storage = function() {
      DBI::dbExecute(
        private$conn,
        glue::glue("DROP SCHEMA IF EXISTS {private$schema} CASCADE")
      )
      DBI::dbDisconnect(private$conn)
      private$conn <- NULL
    },
    list = function() {
      result <- DBI::dbGetQuery(
        private$conn,
        glue::glue(
          "SELECT table_name FROM information_schema.tables
           WHERE table_schema = $1 AND table_name != '_metadata'"
        ),
        params = list(private$schema)
      )
      result$table_name
    },
    get_metadata = function(name = NULL) {
      if (is.null(name)) {
        names_list <- self$list()
        if (length(names_list) == 0) {
          return(private$empty_metadata_tibble())
        }
        build_row <- private$build_metadata_row
        rows <- purrr::map(names_list, function(n) build_row(n))
        return(dplyr::bind_rows(rows))
      }
      if (!self$exists(name)) {
        return(private$empty_metadata_tibble())
      }
      private$build_metadata_row(name)
    },
    is_db = function() {
      TRUE
    }
  ),
  private = list(
    conn = NULL,
    schema = NULL,
    finalize = function() {
      if (!is.null(private$conn) && DBI::dbIsValid(private$conn)) {
        DBI::dbDisconnect(private$conn)
      }
    },
    ensure_schema = function() {
      DBI::dbExecute(
        private$conn,
        glue::glue("CREATE SCHEMA IF NOT EXISTS {private$schema}")
      )
    },
    ensure_metadata_table = function() {
      meta_table <- DBI::Id(schema = private$schema, table = "_metadata")
      if (!DBI::dbExistsTable(private$conn, meta_table)) {
        DBI::dbExecute(
          private$conn,
          glue::glue(
            "CREATE TABLE {private$schema}._metadata (
              dataset_name TEXT PRIMARY KEY,
              metadata JSONB NOT NULL
            )"
          )
        )
      }
    },
    qualified_name = function(name) {
      paste0(private$schema, ".", name)
    },
    save_metadata = function(name, meta) {
      meta_json <- jsonlite::toJSON(meta, auto_unbox = TRUE)
      DBI::dbExecute(
        private$conn,
        glue::glue(
          "INSERT INTO {private$schema}._metadata (dataset_name, metadata)
           VALUES ($1, $2)
           ON CONFLICT (dataset_name) DO UPDATE SET metadata = $2"
        ),
        params = list(name, as.character(meta_json))
      )
    },
    load_metadata = function(name) {
      result <- DBI::dbGetQuery(
        private$conn,
        glue::glue(
          "SELECT metadata FROM {private$schema}._metadata
           WHERE dataset_name = $1"
        ),
        params = list(name)
      )
      if (nrow(result) == 0) {
        return(NULL)
      }
      jsonlite::fromJSON(result$metadata[[1]])
    },
    serialize_columns = function(data) {
      column_types <- list()
      for (col in names(data)) {
        if (inherits(data[[col]], "difftime")) {
          column_types[[col]] <- list(
            type = "difftime",
            units = attr(data[[col]], "units")
          )
          data[[col]] <- as.numeric(data[[col]])
        } else if (inherits(data[[col]], "POSIXct")) {
          column_types[[col]] <- list(type = "POSIXct")
          data[[col]] <- format(data[[col]], "%Y-%m-%dT%H:%M:%S")
        }
      }
      list(data = data, column_types = column_types)
    },
    restore_columns = function(data, column_types) {
      for (col in names(column_types)) {
        if (!(col %in% names(data))) next
        col_type <- column_types[[col]]
        type <- if (is.list(col_type)) col_type$type else col_type
        if (type == "difftime") {
          units <- if (is.list(col_type)) col_type$units else "days"
          data[[col]] <- as.difftime(
            as.numeric(data[[col]]),
            units = units
          )
        } else if (type == "POSIXct") {
          data[[col]] <- as.POSIXct(data[[col]], format = "%Y-%m-%dT%H:%M:%S")
        }
      }
      data
    },
    build_metadata_row = function(name) {
      meta <- private$load_metadata(name)
      if (is.null(meta)) {
        return(dplyr::tibble(
          table_name = name,
          class = list(NULL),
          attributes = list(list())
        ))
      }
      dplyr::tibble(
        table_name = name,
        class = list(meta$class),
        attributes = list(meta$attributes %||% list())
      )
    },
    empty_metadata_tibble = function() {
      dplyr::tibble(
        table_name = character(),
        class = list(),
        attributes = list()
      )
    }
  )
)

#' @noRd
StorageSQLite <- R6::R6Class(
  classname = "StorageSQLite",
  inherit = Storage,
  public = list(
    initialize = function(dbname = ":memory:") {
      check_if_package_installed("DBI")
      check_if_package_installed("RSQLite")
      check_if_package_installed("jsonlite")
      private$dbname <- dbname
      private$conn <- DBI::dbConnect(RSQLite::SQLite(), dbname = dbname)
      private$ensure_metadata_table()
    },
    save = function(name, data) {
      meta <- list(
        class = class(data),
        attributes = list()
      )
      custom_attrs <- setdiff(
        names(attributes(data)),
        c("names", "row.names", "class")
      )
      for (attr_name in custom_attrs) {
        meta$attributes[[attr_name]] <- attr(data, attr_name)
      }
      plain_data <- data
      class(plain_data) <- class(plain_data)[!grepl("^gitstats_", class(plain_data))]
      serialized <- private$serialize_columns(plain_data)
      plain_data <- serialized$data
      meta$column_types <- serialized$column_types
      DBI::dbWriteTable(private$conn, name, plain_data, overwrite = TRUE)
      private$save_metadata(name, meta)
    },
    load = function(name) {
      if (!self$exists(name)) {
        return(NULL)
      }
      data <- DBI::dbReadTable(private$conn, name) |>
        dplyr::as_tibble()
      meta <- private$load_metadata(name)
      if (!is.null(meta)) {
        if (!is.null(meta$column_types)) {
          data <- private$restore_columns(data, meta$column_types)
        }
        if (!is.null(meta$class)) {
          class(data) <- meta$class
        }
        if (!is.null(meta$attributes)) {
          for (attr_name in names(meta$attributes)) {
            attr(data, attr_name) <- meta$attributes[[attr_name]]
          }
        }
      }
      return(data)
    },
    exists = function(name) {
      DBI::dbExistsTable(private$conn, name)
    },
    remove = function(name) {
      if (self$exists(name)) {
        DBI::dbRemoveTable(private$conn, name)
        DBI::dbExecute(
          private$conn,
          "DELETE FROM _metadata WHERE dataset_name = ?",
          params = list(name)
        )
      }
      invisible(NULL)
    },
    drop_storage = function() {
      if (!is.null(private$conn) && DBI::dbIsValid(private$conn)) {
        DBI::dbDisconnect(private$conn)
        private$conn <- NULL
      }
      if (!is.null(private$dbname) && private$dbname != ":memory:" &&
          file.exists(private$dbname)) {
        file.remove(private$dbname)
      }
    },
    list = function() {
      tables <- DBI::dbListTables(private$conn)
      tables[tables != "_metadata"]
    },
    get_metadata = function(name = NULL) {
      if (is.null(name)) {
        names_list <- self$list()
        if (length(names_list) == 0) {
          return(private$empty_metadata_tibble())
        }
        build_row <- private$build_metadata_row
        rows <- purrr::map(names_list, function(n) build_row(n))
        return(dplyr::bind_rows(rows))
      }
      if (!self$exists(name)) {
        return(private$empty_metadata_tibble())
      }
      private$build_metadata_row(name)
    },
    is_db = function() {
      TRUE
    }
  ),
  private = list(
    conn = NULL,
    dbname = NULL,
    finalize = function() {
      if (!is.null(private$conn) && DBI::dbIsValid(private$conn)) {
        DBI::dbDisconnect(private$conn)
      }
    },
    ensure_metadata_table = function() {
      if (!DBI::dbExistsTable(private$conn, "_metadata")) {
        DBI::dbExecute(
          private$conn,
          "CREATE TABLE _metadata (
            dataset_name TEXT PRIMARY KEY,
            metadata TEXT NOT NULL
          )"
        )
      }
    },
    save_metadata = function(name, meta) {
      meta_json <- jsonlite::toJSON(meta, auto_unbox = TRUE)
      DBI::dbExecute(
        private$conn,
        "DELETE FROM _metadata WHERE dataset_name = ?",
        params = list(name)
      )
      DBI::dbExecute(
        private$conn,
        "INSERT INTO _metadata (dataset_name, metadata) VALUES (?, ?)",
        params = list(name, as.character(meta_json))
      )
    },
    load_metadata = function(name) {
      result <- DBI::dbGetQuery(
        private$conn,
        "SELECT metadata FROM _metadata WHERE dataset_name = ?",
        params = list(name)
      )
      if (nrow(result) == 0) {
        return(NULL)
      }
      jsonlite::fromJSON(result$metadata[[1]])
    },
    serialize_columns = function(data) {
      column_types <- list()
      for (col in names(data)) {
        if (inherits(data[[col]], "difftime")) {
          column_types[[col]] <- list(
            type = "difftime",
            units = attr(data[[col]], "units")
          )
          data[[col]] <- as.numeric(data[[col]])
        } else if (inherits(data[[col]], "POSIXct")) {
          column_types[[col]] <- list(type = "POSIXct")
          data[[col]] <- format(data[[col]], "%Y-%m-%dT%H:%M:%S")
        }
      }
      list(data = data, column_types = column_types)
    },
    restore_columns = function(data, column_types) {
      for (col in names(column_types)) {
        if (!(col %in% names(data))) next
        col_type <- column_types[[col]]
        type <- if (is.list(col_type)) col_type$type else col_type
        if (type == "difftime") {
          units <- if (is.list(col_type)) col_type$units else "days"
          data[[col]] <- as.difftime(
            as.numeric(data[[col]]),
            units = units
          )
        } else if (type == "POSIXct") {
          data[[col]] <- as.POSIXct(data[[col]], format = "%Y-%m-%dT%H:%M:%S")
        }
      }
      data
    },
    build_metadata_row = function(name) {
      meta <- private$load_metadata(name)
      if (is.null(meta)) {
        return(dplyr::tibble(
          table_name = name,
          class = list(NULL),
          attributes = list(list())
        ))
      }
      dplyr::tibble(
        table_name = name,
        class = list(meta$class),
        attributes = list(meta$attributes %||% list())
      )
    },
    empty_metadata_tibble = function() {
      dplyr::tibble(
        table_name = character(),
        class = list(),
        attributes = list()
      )
    }
  )
)
