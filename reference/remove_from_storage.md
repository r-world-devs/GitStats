# Remove a table from `GitStats` storage

Removes a named table from the active storage backend.

## Usage

``` r
remove_from_storage(gitstats, storage)
```

## Arguments

- gitstats:

  A GitStats object.

- storage:

  A character, name of the table to remove (e.g. `"commits"`,
  `"repositories"`).

## Value

A `GitStats` object (invisibly).

## Examples

``` r
if (FALSE) { # \dontrun{
  my_gitstats <- create_gitstats() |>
    set_github_host(
      token = Sys.getenv("GITHUB_PAT"),
      orgs = "r-world-devs"
    )
  get_commits(my_gitstats, since = "2024-01-01")
  remove_from_storage(my_gitstats, storage = "commits")
} # }
```
