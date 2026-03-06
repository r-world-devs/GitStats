# Get pull requests statistics

Prepare statistics from the pulled pull requests data.

## Usage

``` r
get_pull_requests_stats(
  pull_requests,
  time_aggregation = c("year", "month", "week", "day"),
  group_var
)
```

## Arguments

- pull_requests:

  A `gitstats_pr_stats` S3 class table object (output of
  [`get_pull_requests()`](https://r-world-devs.github.io/GitStats/reference/get_pull_requests.md)).

- time_aggregation:

  A character, specifying time aggregation of statistics.

- group_var:

  Other grouping variable to be passed to
  [`dplyr::group_by()`](https://dplyr.tidyverse.org/reference/group_by.html)
  function apart from `stats_date` and `githost`. Could be: `author`,
  `state` or `organization`. Should be passed without quotation marks.

## Value

A table of `pull_requests_stats` class.

## Details

To make function work, you need first to get pull requests data with
`GitStats`. See examples section.

## Examples

``` r
if (FALSE) { # \dontrun{
 my_gitstats <- create_gitstats() |>
   set_github_host(
     token = Sys.getenv("GITHUB_PAT"),
     repos = c("r-world-devs/GitStats", "openpharma/visR")
   ) |>
   get_pull_requests(my_gitstats, since = "2022-01-01") |>
   get_pull_requests_stats(
     time_aggregation = "month",
     group_var = author
   )
} # }
```
