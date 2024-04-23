
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

### API versions

GitStats is configured to connect to GitHub API (version 3) and GitLab
API (version 4).

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
