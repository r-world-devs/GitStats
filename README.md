
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

``` r
devtools::install_github("r-world-devs/GitStats")
```

## Getting started

You can start by creating your `GitStats` object, where you will hold
information on your multiple connections.

``` r
library(GitStats)
library(magrittr)

git_stats <- create_gitstats() %>%
  set_connection(
    api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = c("r-world-devs", "openpharma", "pharmaverse")
  ) %>%
  set_connection(
    api_url = "https://gitlab.com/api/v4",
    token = Sys.getenv("GITLAB_PAT_PUBLIC"),
    orgs = c("mbtests")
  )
```

## Setup

You can setup your search preferences, either to `org`, `team` or
`phrase`.

### Team

If you with to setup your search parameter to team, add your team
members first:

``` r
git_stats %>%
  add_team_member("Adam Foryś", "galachad") %>%
  add_team_member("Kamil Wais", "kalimu") %>%
  add_team_member("Krystian Igras", "krystian8207") %>%
  add_team_member("Karolina Marcinkowska", "marcinkowskak") %>%
  add_team_member("Kamil Koziej", "Cotau") %>%
  add_team_member("Maciej Banaś", "maciekbanas")

setup(git_stats,
  search_param = "team",
  team_name = "RWD"
)
#> A <GitStats> object for 2 hosts:
#> Hosts: https://api.github.com, https://gitlab.com/api/v4
#> Organisations: r-world-devs, openpharma, pharmaverse, mbtests
#> Search preference: team
#> Team: RWD (6 members)
#> Phrase: <not defined>
#> Language: <not defined>
#> Repositories output: <not defined>
#> Commits output: <not defined>

# now pull repos and commits by default by team
get_repos(git_stats)
#> Rows: 23
#> Columns: 13
#> $ id               <chr> "R_kgDOJWYrCA", "R_kgDOIvtxsg", "R_kgDOJAtHJA", "R_kg…
#> $ name             <chr> "hypothesis", "GitStats", "shinyTimelines", "shinyGiz…
#> $ stars            <int> 2, 1, 2, 16, 2, 4, 4, 10, 22, 2, 144, 1, 3, 7, 7, 0, …
#> $ forks            <int> 0, 0, 0, 0, 2, 0, 0, 1, 5, 1, 36, 0, 3, 6, 4, NA, NA,…
#> $ created_at       <dttm> 2023-04-13 13:52:24, 2023-01-09 14:02:20, 2023-02-21…
#> $ last_activity_at <drtn> 14.38 days, 0.38 days, 7.38 days, 4.38 days, 7.38 da…
#> $ languages        <chr> "R, JavaScript", "R", "R, CSS", "R, CSS, JavaScript",…
#> $ issues_open      <dbl> 0, 65, 0, 5, 22, 27, 1, 0, 0, 2, 64, 6, 3, 39, 26, 0,…
#> $ issues_closed    <dbl> 0, 79, 0, 12, 1, 4, 0, 0, 1, 0, 986, 55, 23, 121, 35,…
#> $ contributors     <chr> "krystian8207", "maciekbanas", "krystian8207", "kryst…
#> $ organization     <chr> "r-world-devs", "r-world-devs", "r-world-devs", "r-wo…
#> $ repo_url         <chr> "https://github.com/r-world-devs/hypothesis", "https:…
#> $ api_url          <chr> "https://api.github.com", "https://api.github.com", "…

get_commits(git_stats,
  date_from = "2022-01-01",
  date_until = "2023-03-31"
)
#> Rows: 304
#> Columns: 8
#> $ id             <chr> "C_kwDOHNMr29oAKGFjZWNlMDA5ZDNiMWQ2MWY1OWJhZGVlNmNmMzg2…
#> $ committed_date <dttm> 2022-05-23 15:00:08, 2022-05-18 07:32:23, 2023-03-01 1…
#> $ author         <chr> "Adam Forys", "Adam Forys", "Krystian Igras", "Krystian…
#> $ additions      <int> 1, 33, 296, 18, 10, 29, 8, 17, 1, 11, 267, 876, 1, 6, 3…
#> $ deletions      <int> 1, 6, 153, 11, 7, 14, 4, 8, 1, 5, 146, 146, 1, 4, 3, 9,…
#> $ repository     <chr> "shinyGizmo", "shinyGizmo", "shinyGizmo", "shinyGizmo",…
#> $ organization   <chr> "r-world-devs", "r-world-devs", "r-world-devs", "r-worl…
#> $ api_url        <chr> "https://api.github.com", "https://api.github.com", "ht…
```

### Keyword

With `GitStats` you can look for the repos with a certain phrase in code
blobs.

``` r
setup(git_stats,
  search_param = "phrase",
  phrase = "shiny"
)
#> A <GitStats> object for 2 hosts:
#> Hosts: https://api.github.com, https://gitlab.com/api/v4
#> Organisations: r-world-devs, openpharma, pharmaverse, mbtests
#> Search preference: phrase
#> Team: RWD (6 members)
#> Phrase: shiny
#> Language: <not defined>
#> Repositories output: Rows number: 23
#> Commits output: Since: 2022-01-20 14:57:56; Until: 2023-03-30 14:15:33; Rows number: 304

# now pull repos by default by phrase
get_repos(git_stats)
#> Rows: 3
#> Columns: 13
#> $ id               <chr> "495151911", "512764983", "431378047"
#> $ name             <chr> "shinyCohortBuilder", "openpharma_ml", "elaborator"
#> $ stars            <int> 4, 0, 2
#> $ forks            <int> 0, 0, 0
#> $ created_at       <dttm> 2022-05-22, 2022-07-11, 2021-11-24
#> $ last_activity_at <drtn> 7.38 days, 1.38 days, 455.38 days
#> $ languages        <chr> "R", "Python", "R"
#> $ issues_open      <int> 27, 0, 0
#> $ issues_closed    <int> 0, 0, 0
#> $ contributors     <chr> "krystian8207, galachad", "MathieuCayssol, epijim", "…
#> $ organization     <chr> "r-world-devs", "openpharma", "openpharma"
#> $ repo_url         <chr> "https://api.github.com/repos/r-world-devs/shinyCohor…
#> $ api_url          <chr> "https://api.github.com", "https://api.github.com", "…
```

### Acknowledgement

Special thanks to:

- @Cotau - for reviewing permanently my pull requests and suggesting
  more efficient solutions,
- @marcinkowskak - for substantial improvements on plots,
- @kalimu, @galachad, @krystian8207 - for your guidelines at the very
  beginning of the project.
