# Get data on repositories

Pulls data on all repositories for an organization, individual user or
those with a given text in code blobs (`with_code` parameter) or a file
(`with_files` parameter) and parse it into table format.

## Usage

``` r
get_repos(
  gitstats,
  add_contributors = TRUE,
  add_languages = TRUE,
  with_code = NULL,
  in_files = NULL,
  with_files = NULL,
  language = NULL,
  cache = TRUE,
  verbose = FALSE,
  progress = TRUE,
  fill_empty_sha = FALSE
)
```

## Arguments

- gitstats:

  A GitStats object.

- add_contributors:

  A logical parameter to decide whether to add information about
  repositories' contributors to the repositories output (table). If set
  to `FALSE` it makes function run faster as, in the case of `org`
  search mode, it reaches only `GraphQL` endpoint with a query on
  repositories, and in the case of `code` search mode it reaches only
  `repositories REST API` endpoint. However, the pitfall is that the
  result does not convey information on contributors.  
    
  When set to `TRUE` (by default), `GitStats` iterates additionally over
  pulled repositories and reaches to the `contributors APIs`, which
  makes it slower, but gives additional information.

- add_languages:

  A logical, `TRUE` by default. If set to `FALSE`, languages data will
  not be included in the repositories output which may speed up the
  process for GitLab REST engine.

- with_code:

  A character vector, if defined, GitStats will pull repositories with
  specified code phrases in code blobs.

- in_files:

  A character vector of file names. Works when `with_code` is set - then
  it searches code blobs only in files passed to `in_files` parameter.

- with_files:

  A character vector, if defined, GitStats will pull repositories with
  specified files.

- language:

  A character. If defined, GitStats will return only repositories with
  given language.

- cache:

  A logical, if set to `TRUE` GitStats will retrieve the last result
  from its storage.

- verbose:

  A logical, `TRUE` by default. If `FALSE` messages and printing output
  is switched off.

- progress:

  A logical, by default set to `verbose` value. If `FALSE` no `cli`
  progress bar will be displayed.

- fill_empty_sha:

  A logical, `FALSE` by default. If `TRUE`, GitStats will try to fetch
  missing `commit_sha` values (e.g. for archived GitLab projects) via
  the REST Branches API. This may slow down the call for large numbers
  of repositories.

## Value

A data.frame.

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
get_repos(my_gitstats)
get_repos(my_gitstats, add_contributors = FALSE)
get_repos(my_gitstats, add_languages = FALSE)
get_repos(my_gitstats, with_code = "Shiny", in_files = "renv.lock")
get_repos(my_gitstats, with_files = "DESCRIPTION")
} # }
```
