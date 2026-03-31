# Get metadata for a storage table

Retrieves metadata (R classes, custom attributes, column types) for a
table stored in the active storage backend.

## Usage

``` r
get_storage_metadata(gitstats, storage = NULL)
```

## Arguments

- gitstats:

  A GitStats object.

- storage:

  A character, name of the table (e.g. `"commits"`, `"repositories"`).
  If `NULL` (default), metadata for all tables in storage will be
  returned.

## Value

A list with metadata fields: `class`, `attributes`, and (for database
backends) `column_types`.

## Examples

``` r
if (FALSE) { # \dontrun{
  my_gitstats <- create_gitstats() |>
    set_github_host(
      token = Sys.getenv("GITHUB_PAT"),
      orgs = "r-world-devs"
    )
  get_commits(my_gitstats, since = "2024-01-01")
  get_storage_metadata(my_gitstats, storage = "commits")
} # }
```
