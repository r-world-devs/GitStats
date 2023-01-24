
<!-- README.md is generated from README.Rmd. Please edit that file -->

# GitStats

<!-- badges: start -->

[![R-CMD-check](https://github.com/r-world-devs/GitStats/workflows/R-CMD-check/badge.svg)](https://github.com/r-world-devs/GitStats/actions)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

***WORK IN PROGRESS***

The goal of GitStats is to search through multiple GitHub and GitLab
platforms for different statistics either by owners/groups of
repositories, team members or searched code phrases.

For the time being GitStats supports connections to public GitHub,
enterprise GitHub and GitLab.

## Installation

Development version:

``` r
devtools::install_github("r-world-devs/GitStats")
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
    token = Sys.getenv("GITHUB_PAT"), # You can set up your own token as an environment variable in .Renviron file (based in home directory)
    orgs = c("openpharma", "r-world-devs")
  ) %>%
  set_connection(
    api_url = "https://gitlab.com/api/v4",
    token = Sys.getenv("GITLAB_PAT"),
    orgs = c("erasmusmc-public-health")
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
#>  orgs: erasmusmc-public-health
```

## Explore

And start your exploration for repos and commits, e.g. by owners and
groups:

``` r
repos <- get_repos(git_stats)

head(repos)
```

``` r
commits <- get_commits(git_stats,
                       date_from = "2022-06-01")

head(commits)
```

### Team

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
```
