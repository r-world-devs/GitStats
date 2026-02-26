# Get data on pull requests

List all pull requests from all repositories for an organization or a
vector of repositories.

## Usage

``` r
get_pull_requests(
  gitstats,
  since = NULL,
  until = Sys.Date(),
  state = NULL,
  cache = TRUE,
  verbose = FALSE,
  progress = TRUE
)
```

## Arguments

- gitstats:

  A `GitStats` object.

- since:

  A starting date.

- until:

  An end date.

- state:

  An optional character, by default `NULL`, may be set to "open" or
  "closed" if user wants one type of issues.

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

A table of `tibble` and `gitstats_pull_requests` classes.

## Examples

``` r
if (FALSE) { # \dontrun{
my_gitstats <- create_gitstats() |>
  set_github_host(
    token = Sys.getenv("GITHUB_PAT"),
    repos = c("openpharma/DataFakeR", "openpharma/visR")
  ) |>
  set_gitlab_host(
    token = Sys.getenv("GITLAB_PAT_PUBLIC"),
    orgs = "mbtests"
  )
 get_pull_requests(my_gitstats, since = "2018-01-01", state = "open")
} # }
```
