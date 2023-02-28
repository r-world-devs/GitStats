
<!-- README.md is generated from README.Rmd. Please edit that file -->

# GitStats <img src="man/figures/GitStats_logo.png" align="right" height="138" style="float:right; height:138px;"/>

<!-- badges: start -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/r-world-devs/GitStats/workflows/R-CMD-check/badge.svg)](https://github.com/r-world-devs/GitStats/actions)
[![Codecov test
coverage](https://codecov.io/gh/r-world-devs/GitStats/branch/devel/graph/badge.svg)](https://app.codecov.io/gh/r-world-devs/GitStats?branch=devel)
<!-- badges: end -->

The goal of GitStats is to search through multiple GitHub and GitLab
platforms for different statistics either by owners/groups of
repositories, team members or searched code phrases.

For the time being GitStats supports connections to public GitHub,
enterprise GitHub and GitLab.

## Installation

Development version:

``` r
devtools::install_github("r-world-devs/GitStats@devel")
```

## Start - set connections

Start with setting your git connections.

As GitStats provides possibility of showing stats through multiple
platforms, you can pass more than one connection from other Git hosting
service.

``` r

library(GitStats)
library(magrittr)

git_stats <- create_gitstats() %>%
  set_connection(
    api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = c("openpharma", "r-world-devs")
  ) %>%
  set_connection(
    api_url = "https://gitlab.com/api/v4",
    token = Sys.getenv("GITLAB_PAT"),
    orgs = c("mbtests")
  )
#> ✔ Set connection to GitHub.
#> ✔ Set connection to GitLab.

git_stats
#> A GitStats object (multi-API client platform) for 2 clients:
#> GitHub API Client
#>  url: https://api.github.com
#>  orgs: openpharma, r-world-devs
#> GitLab API Client
#>  url: https://gitlab.com/api/v4
#>  orgs: mbtests
```

## Explore

You can look for the repositories and other information, where engaged
is your team. First you need to specify your team members (by
git-platform logins), then do the search.

``` r
git_stats <- git_stats %>%
  set_team(team_name = "RWD-IE",
           "galachad",
           "krystian8207",
           "kalimu",
           "marcinkowskak",
           "Cotau",
           "Maciej Banaś") %>%
  get_repos(by = "team")
#> → Pulling repositories...
#> → Pulling repositories...
#> Warning: Automatic coercion from integer to character was deprecated in purrr 1.0.0.
#> ℹ Please use an explicit call to `as.character()` within `map_chr()` instead.
#> ℹ The deprecated feature was likely used in the GitStats package.
#>   Please report the issue to the authors.
#> Rows: 13
#> Columns: 12
#> $ organisation     <chr> "mbtests", "r-world-devs", "openpharma", "mbtests", "…
#> $ name             <chr> "RM Tests", "shinyTimelines", "DataFakeR", "GitStats …
#> $ created_at       <dttm> 2023-02-27, 2023-02-21, 2021-09-02, 2023-02-10, 2023…
#> $ last_activity_at <drtn> 1.6 days, 7.6 days, 9.6 days, 18.6 days, 18.6 days, …
#> $ forks            <chr> "", "0", "5", "", "", "0", "31", "0", "0", "0", "0", …
#> $ stars            <int> 0, 0, 21, 0, 0, 2, 173, 1, 1, 10, 4, 9, 0
#> $ contributors     <chr> "Maciej Banaś", "krystian8207", "krystian8207,hadley,…
#> $ issues           <int> 0, 0, 0, 1, 2, 30, 30, 23, 30, 6, 1, 0, 3
#> $ issues_open      <int> 0, 0, 0, 1, 1, 30, 30, 23, 30, 6, 1, 0, 3
#> $ issues_closed    <int> 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0
#> $ description      <chr> "", "", "DataFakeR is an R package designed to help y…
#> $ api_url          <chr> "https://gitlab.com/api/v4", "https://api.github.com"…
```
