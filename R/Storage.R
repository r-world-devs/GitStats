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
    list = function() {
      names(purrr::discard(private$data, is.null))
    },
    get_metadata = function(name = NULL) {
      if (is.null(name)) {
        names_list <- self$list()
        if (length(names_list) == 0) {
          return(private$empty_metadata_tibble())
        }
        rows <- purrr::map(names_list, ~ private$build_metadata_row(.))
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
        rows <- purrr::map(names_list, ~ private$build_metadata_row(.))
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
        rows <- purrr::map(names_list, ~ private$build_metadata_row(.))
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
