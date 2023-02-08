
<!-- README.md is generated from README.Rmd. Please edit that file -->

# GitStats <img src="man/figures/GitStats_logo.png" align="right" height="138" />

<!-- badges: start -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/r-world-devs/GitStats/workflows/R-CMD-check/badge.svg)](https://github.com/r-world-devs/GitStats/actions)
[![Codecov test
coverage](https://codecov.io/gh/r-world-devs/GitStats/branch/devel/graph/badge.svg)](https://app.codecov.io/gh/r-world-devs/GitStats?branch=devel)
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
#>    organisation               name created_at last_activity_at forks stars
#> 1:   openpharma          DataFakeR 2021-09-02        1.38 days     4    10
#> 2:   openpharma               visR 2019-09-16        5.38 days    30   173
#> 3: r-world-devs      cohortBuilder 2022-05-22        8.38 days     0     1
#> 4: r-world-devs           GitStats 2023-01-09        8.38 days     0     1
#> 5: r-world-devs         shinyGizmo 2022-04-20       30.38 days     0    10
#> 6:   openpharma            facetsr 2020-11-26      163.38 days     0     4
#> 7:   openpharma                RDO 2020-01-18      184.38 days     1     9
#> 8: r-world-devs shinyCohortBuilder 2022-05-22      249.38 days     0     1
#> 9: r-world-devs   cohortBuilder.db 2022-05-22      262.38 days     0     0
#>                                                                                                                                                                                     contributors
#> 1:                                                                                                                                                            krystian8207,hadley,MichaelChirico
#> 2: timtreis,bailliem,SHAESEN2,epijim,rebecca-albrecht,ddsjoberg,cschaerfe,actions-user,Jonnie-Bevan,diego-s,kentm4,ardeeshany,kawap,galachad,AlexandraP-21,joanacmbarros,ginberg,thanos-siadimas
#> 3:                                                                                                                                                                                  krystian8207
#> 4:                                                                                                                                                                             maciekbanas,Cotau
#> 5:                                                                                                                                                            krystian8207,stla,galachad,stlagsk
#> 6:                                                                                                                                                                                      galachad
#> 7:                                                                                                                                                                                        kalimu
#> 8:                                                                                                                                                                         krystian8207,galachad
#> 9:                                                                                                                                                                                  krystian8207
#>    issues issues_open issues_closed
#> 1:      2           2             0
#> 2:     30          30             0
#> 3:     24          24             0
#> 4:     29          29             0
#> 5:      4           4             0
#> 6:      1           1             0
#> 7:      0           0             0
#> 8:     29          29             0
#> 9:      3           3             0
#>                                                                                                                             description
#> 1: DataFakeR is an R package designed to help you generate sample of fake data preserving specified assumptions about the original one.
#> 2:                                     A package to wrap functionality for plots, tables and diagrams adhering to graphical principles.
#> 3:                                                                                                                                     
#> 4:     An R package to get statistics in a standardized form from different git hosting services: GitHub and GitLab for the time-being.
#> 5:                                                                                                                                     
#> 6:                                                                             This package is using html widgets to wrap facets into R
#> 7:                                                                                                Reproducible Data Objects (RDO) in R 
#> 8:                                                                                                                                     
#> 9:                                                                                                                                     
#>                   api_url
#> 1: https://api.github.com
#> 2: https://api.github.com
#> 3: https://api.github.com
#> 4: https://api.github.com
#> 5: https://api.github.com
#> 6: https://api.github.com
#> 7: https://api.github.com
#> 8: https://api.github.com
#> 9: https://api.github.com
```
