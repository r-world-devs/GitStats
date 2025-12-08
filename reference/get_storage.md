# Get data from `GitStats` storage

Retrieves whole or particular data (see `storage` parameter) pulled
earlier with `GitStats`.

## Usage

``` r
get_storage(gitstats, storage = NULL)
```

## Arguments

- gitstats:

  A GitStats object.

- storage:

  A character, type of the data you want to get from storage: `commits`,
  `repositories`, `release_logs`, `users`, `files`, `files_structure`,
  `R_package_usage` or `release_logs`.

## Value

A list of tibbles (if `storage` set to `NULL`) or a tibble (if `storage`
defined).

## Examples

``` r
if (FALSE) { # \dontrun{
 my_gitstats <- create_gitstats() |>
  set_github_host(
    token = Sys.getenv("GITHUB_PAT"),
    orgs = c("r-world-devs", "openpharma")
  )
  get_release_logs(my_gistats, since = "2024-01-01")
  get_repos(my_gitstats)

  release_logs <- get_storage(
    gitstats = my_gitstats,
    storage = "release_logs"
  )
} # }
```
