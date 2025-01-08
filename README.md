
<!-- README.md is generated from README.Rmd. Please edit that file -->

# GitStats <img src="man/figures/GitStats_logo.png" align="right" height="138" style="float:right; height:138px;"/>

<!-- badges: start -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/r-world-devs/GitStats/workflows/R-CMD-check/badge.svg)](https://github.com/r-world-devs/GitStats/actions)
[![Codecov test
coverage](https://codecov.io/gh/r-world-devs/GitStats/branch/devel/graph/badge.svg)](https://app.codecov.io/gh/r-world-devs/GitStats?branch=devel)
<!-- badges: end -->

With GitStats you can pull git data in a uniform way (table format) from
GitHub and GitLab. For the time-being you can get data on:

- repositories,
- commits,
- users,
- release logs,
- text files content,
- R package usage.

## Installation

From CRAN:

``` r
install.packages("GitStats")
```

From GitHub:

``` r
devtools::install_github("r-world-devs/GitStats")
```

## Start

``` r
library(GitStats)

commits <- create_gitstats() |>
  set_gitlab_host(
    repos = "mbtests/gitstatstesting"
  ) |>
  set_github_host(
    orgs = "r-world-devs",
    repos = "openpharma/DataFakeR"
  ) |>
  get_commits(
    since = "2022-01-01"
  )

commits
#> # A tibble: 2,169 × 11
#>    id    committed_date      author author_login author_name additions deletions
#>    <chr> <dttm>              <chr>  <chr>        <chr>           <int>     <int>
#>  1 7f48… 2024-09-10 11:12:59 Macie… maciekbanas  Maciej Ban…         0         0
#>  2 9c66… 2024-09-10 10:35:37 Macie… maciekbanas  Maciej Ban…         0         0
#>  3 fca2… 2024-09-10 10:31:24 Macie… maciekbanas  Maciej Ban…         0         0
#>  4 e8f2… 2023-03-30 14:15:33 Macie… maciekbanas  Maciej Ban…         1         0
#>  5 7e87… 2023-02-10 09:48:55 Macie… maciekbanas  Maciej Ban…         1         1
#>  6 62c4… 2023-02-10 09:17:24 Macie… maciekbanas  Maciej Ban…         2        87
#>  7 55cf… 2023-02-10 09:07:54 Macie… maciekbanas  Maciej Ban…        92         0
#>  8 C_kw… 2023-05-08 09:43:31 Kryst… krystian8207 Krystian I…        18         0
#>  9 C_kw… 2023-04-28 12:30:40 Kamil… <NA>         Kamil Kozi…        18         0
#> 10 C_kw… 2023-03-01 15:05:10 Kryst… krystian8207 Krystian I…       296       153
#> # ℹ 2,159 more rows
#> # ℹ 4 more variables: repository <chr>, organization <chr>, repo_url <chr>,
#> #   api_url <glue>

commits |>
  get_commits_stats(
    time_aggregation = "month",
    group_var = author
  )
#> # A tibble: 224 × 4
#>    stats_date          githost author             stats
#>    <dttm>              <chr>   <chr>              <int>
#>  1 2022-01-01 00:00:00 github  Admin_mschuemi         1
#>  2 2022-01-01 00:00:00 github  Gowtham Rao            5
#>  3 2022-01-01 00:00:00 github  Krystian Igras         1
#>  4 2022-01-01 00:00:00 github  Martijn Schuemie       1
#>  5 2022-02-01 00:00:00 github  Hadley Wickham         3
#>  6 2022-02-01 00:00:00 github  Martijn Schuemie       2
#>  7 2022-02-01 00:00:00 github  Maximilian Girlich    13
#>  8 2022-02-01 00:00:00 github  Reijo Sund             1
#>  9 2022-02-01 00:00:00 github  eitsupi                1
#> 10 2022-03-01 00:00:00 github  Maximilian Girlich    14
#> # ℹ 214 more rows
```

## Acknowledgement

Special thanks to [James Black](https://github.com/epijim), [Karolina
Marcinkowska](https://github.com/marcinkowskak), [Kamil
Koziej](https://github.com/Cotau), [Matt
Secrest](https://github.com/mattsecrest), [Krystian
Igras](https://github.com/krystian8207), [Kamil
Wais](https://github.com/kalimu), [Adam
Forys](https://github.com/galachad) - for the support in the package
development.
