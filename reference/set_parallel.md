# Enable parallel processing

Set up parallel processing for API calls using mirai daemons. When
enabled, GitStats fetches data from multiple repositories concurrently.
Call `set_parallel(FALSE)` or `set_parallel(0)` to revert to sequential
execution.

## Usage

``` r
set_parallel(gitstats, workers = 10L)
```

## Arguments

- gitstats:

  A GitStats object.

- workers:

  Number of parallel workers. Set to `TRUE` for automatic detection, a
  positive integer for a specific count, or `FALSE`/`0` to disable
  parallelism.

## Value

A `GitStats` object.

## Examples

``` r
if (FALSE) { # \dontrun{
  my_gitstats <- create_gitstats() |>
    set_github_host(
      token = Sys.getenv("GITHUB_PAT"),
      orgs = c("r-world-devs", "openpharma")
    ) |>
    set_parallel(4)
  get_commits(my_gitstats, since = "2024-01-01")
  my_gitstats |> set_parallel(FALSE) # revert to sequential
} # }
```
