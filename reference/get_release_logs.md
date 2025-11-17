# Get release logs

Pull release logs from repositories.

## Usage

``` r
get_release_logs(
  gitstats,
  since = NULL,
  until = Sys.Date() + lubridate::days(1),
  cache = TRUE,
  verbose = is_verbose(gitstats),
  progress = verbose
)
```

## Arguments

- gitstats:

  A `GitStats` object.

- since:

  A starting date.

- until:

  An end date.

- cache:

  A logical, if set to `TRUE` GitStats will retrieve the last result
  from its storage.

- verbose:

  A logical, `TRUE` by default. If `FALSE` messages and printing output
  is switched off.

- progress:

  A logical, by default set to `verbose` value. If `FALSE` no `cli`
  progress bar will be displayed.

## Value

A data.frame.

## Examples

``` r
if (FALSE) { # \dontrun{
 my_gitstats <- create_gitstats() %>%
  set_github_host(
    token = Sys.getenv("GITHUB_PAT"),
    orgs = c("r-world-devs", "openpharma")
  )
  get_release_logs(my_gistats, since = "2024-01-01")
} # }
```
