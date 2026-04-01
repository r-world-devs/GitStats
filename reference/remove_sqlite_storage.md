# Remove SQLite storage

Closes the SQLite connection and, for file-based databases, deletes the
database file. For in-memory databases the data is simply discarded.
Storage is reverted to the default in-memory local backend. Errors if no
SQLite backend is currently set.

## Usage

``` r
remove_sqlite_storage(gitstats)
```

## Arguments

- gitstats:

  A GitStats object.

## Value

A `GitStats` object (invisibly).

## Examples

``` r
if (FALSE) { # \dontrun{
  my_gitstats <- create_gitstats() |>
    set_sqlite_storage(dbname = "gitstats.sqlite")
  remove_sqlite_storage(my_gitstats)
} # }
```
