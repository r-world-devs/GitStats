# Get data on files trees across repositories

Pulls files tree (structure) per repository. Files trees are then stored
as character vectors in `files_tree` column of output table.

## Usage

``` r
get_repos_trees(
  gitstats,
  pattern = NULL,
  depth = Inf,
  cache = TRUE,
  verbose = FALSE,
  progress = TRUE
)
```

## Arguments

- gitstats:

  A GitStats object.

- pattern:

  A regular expression. If defined, it pulls structure of files in a
  repository matching this pattern reaching to the level of directories
  defined by `depth` parameter.

- depth:

  Defines level of directories to reach for files structure from. E.g.
  if set to `0`, it will pull files tree only from `root`, if `1L`, will
  take data from `root` directory and directories visible in `root`
  directory. If left with no argument, will pull files tree down to
  every directory in a repo.

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

A `tibble`.

## Examples

``` r
if (FALSE) { # \dontrun{
 my_gitstats <- create_gitstats() |>
  set_github_host(
    token = Sys.getenv("GITHUB_PAT"),
    orgs = c("r-world-devs", "openpharma")
  )

 get_repos_trees(
   gitstats = my_gitstats,
   pattern = "\\.md"
 )
} # }
```
