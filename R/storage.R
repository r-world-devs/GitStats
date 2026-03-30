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

#' @title Get metadata for a storage table
#' @name get_storage_metadata
#' @description Retrieves metadata (R classes, custom attributes, column types)
#'   for a table stored in the active storage backend.
#' @param gitstats A GitStats object.
#' @param storage A character, name of the table (e.g. `"commits"`,
#'   `"repositories"`).
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
get_storage_metadata <- function(gitstats, storage) {
  gitstats$get_storage_metadata(storage = storage)
}
