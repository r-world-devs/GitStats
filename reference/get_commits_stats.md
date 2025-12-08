# Get commits statistics

Prepare statistics from the pulled commits data.

## Usage

``` r
get_commits_stats(
  commits,
  time_aggregation = c("year", "month", "week", "day"),
  group_var
)
```

## Arguments

- commits:

  A `gitstats_commits` S3 class table object (output of
  [`get_commits()`](https://r-world-devs.github.io/GitStats/reference/get_commits.md)).

- time_aggregation:

  A character, specifying time aggregation of statistics.

- group_var:

  Other grouping variable to be passed to
  [`dplyr::group_by()`](https://dplyr.tidyverse.org/reference/group_by.html)
  function apart from `stats_date` and `githost`. Could be: `author`,
  `author_login`, `author_name` or `organization`. Should be passed
  without quotation marks.

## Value

A table of `commits_stats` class.

## Details

To make function work, you need first to get commits data with
`GitStats`. See examples section.

## Examples

``` r
if (FALSE) { # \dontrun{
 my_gitstats <- create_gitstats() |>
   set_github_host(
     token = Sys.getenv("GITHUB_PAT"),
     repos = c("r-world-devs/GitStats", "openpharma/visR")
   ) |>
   get_commits(my_gitstats, since = "2022-01-01") |>
   get_commits_stats(
     time_aggregation = "year",
     group_var = author
   )
} # }
```
