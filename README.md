
<!-- README.md is generated from README.Rmd. Please edit that file -->

# GitStats <img src="man/figures/GitStats_logo.png" align="right" height="138" />

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
#> Set connection to GitHub.
#> Set connection to GitLab.

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
           "maciekbanas") %>%
  get_repos(by = "team")
#> Rows: 10
#> Columns: 12
#> $ organisation     <chr> "r-world-devs", "openpharma", "r-world-devs", "openph…
#> $ name             <chr> "shinyTimelines", "DataFakeR", "shinyCohortBuilder", …
#> $ created_at       <dttm> 2023-02-21, 2021-09-02, 2022-05-22, 2019-09-16, 2022…
#> $ last_activity_at <drtn> 3.36 days, 5.36 days, 16.36 days, 21.36 days, 24.36 …
#> $ forks            <int> 0, 5, 0, 31, 0, 0, 0, 0, 1, 0
#> $ stars            <int> 0, 21, 2, 173, 1, 1, 10, 4, 9, 0
#> $ contributors     <chr> "krystian8207", "krystian8207,hadley,MichaelChirico",…
#> $ issues           <int> 0, 0, 30, 30, 23, 28, 6, 1, 0, 3
#> $ issues_open      <int> 0, 0, 30, 30, 23, 28, 6, 1, 0, 3
#> $ issues_closed    <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
#> $ description      <chr> "", "DataFakeR is an R package designed to help you g…
#> $ api_url          <chr> "https://api.github.com", "https://api.github.com", "…
```
