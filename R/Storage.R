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
    initialize = function(conn, schema = "git_stats") {
      check_if_package_installed("DBI")
      check_if_package_installed("RPostgres")
      check_if_package_installed("jsonlite")
      if (!DBI::dbIsValid(conn)) {
        cli::cli_abort("Database connection is not valid.")
      }
      private$conn <- conn
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
    }
  )
)
