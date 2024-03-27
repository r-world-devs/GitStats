
<!-- README.md is generated from README.Rmd. Please edit that file -->

# GitStats <img src="man/figures/GitStats_logo.png" align="right" height="138" style="float:right; height:138px;"/>

<!-- badges: start -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/r-world-devs/GitStats/workflows/R-CMD-check/badge.svg)](https://github.com/r-world-devs/GitStats/actions)
[![Codecov test
coverage](https://codecov.io/gh/r-world-devs/GitStats/branch/devel/graph/badge.svg)](https://app.codecov.io/gh/r-world-devs/GitStats?branch=devel)
<!-- badges: end -->

The goal of GitStats is to pull git data (e.g. `repositories`,
`commits`, `release logs`) in a uniform way from different Git platforms
(GitHub and GitLab for the time-being).

## Installation

``` r
devtools::install_github("r-world-devs/GitStats")
```

## Setting up your tokens

Please remember to have your access tokens stored as environment
variables, e.g. `GITHUB_PAT` for access to GitHub API and `GITLAB_PAT`
for GitLab API.

### Access scopes of tokens

For `GitStats` to work you need:

- \[GitHub\] `public_repo`, `read:org` and `read:user` scopes,
- \[GitLab\] `read_api` scope.

## Connect to GitHub and/or GitLab

GitStats is configured to connect to GitHub API (version 3) and GitLab
API (version 4).

To set connections try:

``` r
library(GitStats)

git_stats <- create_gitstats() %>%
  set_github_host(
    orgs = c("r-world-devs", "openpharma"),
    token = Sys.getenv("GITHUB_PAT")
  ) %>%
  set_gitlab_host(
    orgs = c("mbtests"),
    token = Sys.getenv("GITLAB_PAT_PUBLIC")
  )
```

If you have your access tokens stored in environment variables with such
names as `GITHUB_PAT` or `GITHUB_PAT_*` and `GITLAB_PAT` or
`GITLAB_PAT_*` you do not need to specify them in `set_*_host()`
functions, `GitStats` will automatically find them.

``` r
git_stats <- create_gitstats() %>%
  set_github_host(
    orgs = c("r-world-devs", "openpharma")
  ) %>%
  set_gitlab_host(
    orgs = c("mbtests")
  )
```

If you wish to connect to internal GitHub or GitLab, you need to pass
argument to `host` parameter.

``` r
git_stats <- create_gitstats() %>%
  set_github_host(
    host = "github.internal.com",
    orgs = c("org_1", "org_2", "org_3"),
    token = Sys.getenv("YOUR_GITHUB_PAT")
  ) %>%
  set_gitlab_host(
    host = "internal.host.com",
    orgs = c("internal_org"),
    token = Sys.getenv("YOUR_GITLAB_PAT")
  )
```

Pull data!

``` r
get_release_logs(git_stats, since = "2022-01-01")
#> Rows: 44
#> Columns: 7
#> $ repo_name    <chr> "shinyGizmo", "shinyGizmo", "shinyGizmo", "shinyGizmo", "…
#> $ repo_url     <chr> "https://github.com/r-world-devs/shinyGizmo", "https://gi…
#> $ release_name <chr> "shinyGizmo 0.4.2", "shinyGizmo 0.4.1", "shinyGizmo 0.4",…
#> $ release_tag  <chr> "v0.4.2", "v0.4.1", "v0.4", "v0.3", "v0.2", "v0.1", "v.0.…
#> $ published_at <dttm> 2023-03-01 14:59:39, 2023-02-28 13:35:01, 2023-02-13 17:…
#> $ release_url  <chr> "https://github.com/r-world-devs/shinyGizmo/releases/tag/…
#> $ release_log  <chr> "Fixed handling non-existing selector case for valueButto…
```

## GitStats workflow

On how to use GitStats, refer to the
[documentation](https://r-world-devs.github.io/GitStats/index.html).

## Acknowledgement

Special thanks to [James Black](https://github.com/epijim), [Kamil
Koziej](https://github.com/Cotau), [Karolina
Marcinkowska](https://github.com/marcinkowskak), [Krystian
Igras](https://github.com/krystian8207), [Matt
Secrest](https://github.com/mattsecrest), [Kamil
Wais](https://github.com/kalimu), [Adam
Forys](https://github.com/galachad) - for the support in the package
development.
