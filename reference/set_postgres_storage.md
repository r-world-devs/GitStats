# Set PostgreSQL storage

Persist GitStats data in a PostgreSQL database. R classes, custom
attributes, and column types are preserved via a `_metadata` table.
Requires `DBI`, `RPostgres`, and `jsonlite` packages.

## Usage

``` r
set_postgres_storage(
  gitstats,
  host = NULL,
  port = NULL,
  dbname = NULL,
  user = NULL,
  password = NULL,
  schema = "git_stats",
  ...
)
```

## Arguments

- gitstats:

  A GitStats object.

- host:

  A character, database host.

- port:

  An integer, database port.

- dbname:

  A character, database name.

- user:

  A character, database user.

- password:

  A character, database password.

- schema:

  A character, database schema (default `"git_stats"`).

- ...:

  Additional arguments passed to
  `DBI::dbConnect(RPostgres::Postgres(), ...)`.

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
} # }
```
