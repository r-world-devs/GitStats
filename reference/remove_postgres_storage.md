# Remove PostgreSQL storage

Drops the GitStats schema (with all tables and metadata) from the
PostgreSQL database, closes the connection, and reverts storage to the
default in-memory local backend. Errors if no PostgreSQL backend is
currently set.

## Usage

``` r
remove_postgres_storage(gitstats)
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
    set_postgres_storage(
      dbname = "my_database",
      host = "localhost",
      user = "postgres",
      password = "secret"
    )
  remove_postgres_storage(my_gitstats)
} # }
```
