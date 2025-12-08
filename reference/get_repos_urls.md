# Get repository URLS

Pulls a vector of repositories URLs (web or API): either all for an
organization or those with a given text in code blobs (`with_code`
parameter) or a file (`with_files` parameter).

## Usage

``` r
get_repos_urls(
  gitstats,
  type = "api",
  with_code = NULL,
  in_files = NULL,
  with_files = NULL,
  cache = TRUE,
  verbose = FALSE,
  progress = TRUE
)
```

## Arguments

- gitstats:

  A GitStats object.

- type:

  A character, choose if `api` or `web` (`html`) URLs should be
  returned. `api` type is set by default as setting `web` results in
  parsing which may be time consuming in case of large number of
  repositories.

- with_code:

  A character vector, if defined, `GitStats` will pull repositories with
  specified code phrases in code blobs.

- in_files:

  A character vector of file names. Works when `with_code` is set - then
  it searches code blobs only in files passed to `in_files` parameter.

- with_files:

  A character vector, if defined, GitStats will pull repositories with
  specified files.

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

A character vector.

## Examples

``` r
if (FALSE) { # \dontrun{
my_gitstats <- create_gitstats() |>
  set_github_host(
    token = Sys.getenv("GITHUB_PAT"),
    orgs = c("r-world-devs", "openpharma")
  ) |>
  set_gitlab_host(
    token = Sys.getenv("GITLAB_PAT_PUBLIC"),
    orgs = "mbtests"
  )
get_repos_urls(my_gitstats, with_files = c("DESCRIPTION", "LICENSE"))
} # }
```
