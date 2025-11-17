# Get issues statistics

Prepare statistics from the pulled issues data.

## Usage

``` r
get_issues_stats(
  issues,
  time_aggregation = c("year", "month", "week", "day"),
  group_var
)
```

## Arguments

- issues:

  A `gitstats_issue` S3 class table object (output of
  [`get_issues()`](https://r-world-devs.github.io/GitStats/reference/get_issues.md)).

- time_aggregation:

  A character, specifying time aggregation of statistics.

- group_var:

  Other grouping variable to be passed to
  [`dplyr::group_by()`](https://dplyr.tidyverse.org/reference/group_by.html)
  function apart from `stats_date` and `githost`. Could be: `author`,
  `state` or `organization`. Should be passed without quotation marks.

## Value

A table of `issues_stats` class.

## Details

To make function work, you need first to get issues data with
`GitStats`. See examples section.

## Examples

``` r
if (FALSE) { # \dontrun{
 my_gitstats <- create_gitstats() %>%
   set_github_host(
     token = Sys.getenv("GITHUB_PAT"),
     repos = c("r-world-devs/GitStats", "openpharma/visR")
   ) |>
   get_issues(my_gitstats, since = "2022-01-01") |>
   get_issues_stats(
     time_aggregation = "month",
     group_var = state
   )
} # }
```
