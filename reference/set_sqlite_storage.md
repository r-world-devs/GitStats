# Set SQLite storage

Persist GitStats data in a SQLite database. R classes, custom
attributes, and column types are preserved via a `_metadata` table.
Requires `DBI`, `RSQLite`, and `jsonlite` packages.

## Usage

``` r
set_sqlite_storage(gitstats, dbname = ":memory:")
```

## Arguments

- gitstats:

  A GitStats object.

- dbname:

  A character, path to SQLite file. Defaults to `":memory:"` for an
  in-memory database.

## Value

A `GitStats` object (invisibly).

## Examples

``` r
if (FALSE) { # \dontrun{
  # File-based
  my_gitstats <- create_gitstats() |>
    set_sqlite_storage(dbname = "gitstats.sqlite")

  # In-memory
  my_gitstats <- create_gitstats() |>
    set_sqlite_storage()
} # }
```
