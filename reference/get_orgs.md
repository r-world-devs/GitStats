# Get data on organizations

Pulls data on all organizations from a Git host and parses it into table
format.

## Usage

``` r
get_orgs(gitstats, cache = TRUE, verbose = FALSE)
```

## Arguments

- gitstats:

  A GitStats object.

- cache:

  A logical, if set to `TRUE` GitStats will retrieve the last result
  from its storage.

- verbose:

  A logical, `TRUE` by default. If `FALSE` messages and printing output
  is switched off.

## Value

A data.frame.

## Examples

``` r
if (FALSE) { # \dontrun{
my_gitstats <- create_gitstats() |>
  set_github_host(
    orgs = c("r-world-devs", "openpharma"),
    token = Sys.getenv("GITHUB_PAT")
  ) |>
  set_gitlab_host(
    orgs = "mbtests",
    token = Sys.getenv("GITLAB_PAT_PUBLIC")
  )
get_orgs(my_gitstats)
} # }
```
