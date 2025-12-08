# Set GitHub host

Set GitHub host

## Usage

``` r
set_github_host(
  gitstats,
  host = NULL,
  token = NULL,
  orgs = NULL,
  repos = NULL,
  verbose = is_verbose(gitstats),
  .error = TRUE
)
```

## Arguments

- gitstats:

  A GitStats object.

- host:

  A character, optional, URL name of the host. If not passed, a public
  host will be used.

- token:

  A token.

- orgs:

  An optional character vector of organisations. If you pass it, `repos`
  parameter should stay `NULL`.

- repos:

  An optional character vector of repositories full names (organization
  and repository name, e.g. "r-world-devs/GitStats"). If you pass it,
  `orgs` parameter should stay `NULL`.

- verbose:

  A logical, `TRUE` by default. If `FALSE` messages and printing output
  is switched off.

- .error:

  A logical to control if passing wrong input (`repositories` and
  `organizations`) should end with an error or not.

## Value

A `GitStats` object with added information on host.

## Details

If you do not define `orgs` and `repos`, `GitStats` will be set to scan
whole Git platform (such as enterprise version of GitHub or GitLab),
unless it is a public platform. In case of a public one (like GitHub)
you need to define `orgs` or `repos` as scanning through all
organizations may take large amount of time.

## Examples

``` r
if (FALSE) { # \dontrun{
my_gitstats <- create_gitstats() |>
  set_github_host(
    orgs = c("r-world-devs", "openpharma", "pharmaverse")
  )
} # }
```
