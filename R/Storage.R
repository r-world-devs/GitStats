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
    list = function() {
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
    list = function() {
      names(purrr::discard(private$data, is.null))
    }
  ),
  private = list(
    data = list()
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
    finalize = function() {
      if (!is.null(private$conn) && DBI::dbIsValid(private$conn)) {
        DBI::dbDisconnect(private$conn)
      }
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
    list = function() {
      DBI::dbListTables(private$conn) |>
        purrr::keep(~ DBI::dbExistsTable(
          private$conn,
          DBI::Id(schema = private$schema, table = .)
        ))
    },
    is_db = function() {
      TRUE
    }
  ),
  private = list(
    conn = NULL,
    schema = NULL,
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
      private$conn <- DBI::dbConnect(RSQLite::SQLite(), dbname = dbname)
      private$ensure_metadata_table()
    },
    finalize = function() {
      if (!is.null(private$conn) && DBI::dbIsValid(private$conn)) {
        DBI::dbDisconnect(private$conn)
      }
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
    list = function() {
      tables <- DBI::dbListTables(private$conn)
      tables[tables != "_metadata"]
    },
    is_db = function() {
      TRUE
    }
  ),
  private = list(
    conn = NULL,
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
    }
  )
)
