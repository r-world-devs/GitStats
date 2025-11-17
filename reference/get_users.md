# Get users data

Get users data

## Usage

``` r
get_users(gitstats, logins, cache = TRUE, verbose = is_verbose(gitstats))
```

## Arguments

- gitstats:

  A GitStats object.

- logins:

  A character vector of logins.

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
 my_gitstats <- create_gitstats() %>%
  set_github_host(
    token = Sys.getenv("GITHUB_PAT"),
    orgs = c("r-world-devs")
  ) %>%
  set_gitlab_host(
    token = Sys.getenv("GITLAB_PAT_PUBLIC"),
    orgs = "mbtests"
  )
 get_users(my_gitstats, c("maciekabanas", "marcinkowskak"))
} # }
```
