
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
devtools::install_github("r-world-devs/GitStats@test")
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

## Setup preferences

You can setup your search preferences, either to organizations, team or
phrase.

### Team

If you setup your preferences to team, name it and add your team
members:

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
#> Rows: 21
#> Columns: 14
#> $ id               <chr> "R_kgDOHNMr2w", "R_kgDOHYNOFQ", "R_kgDOHYNrJw", "R_kg…
#> $ name             <chr> "shinyGizmo", "cohortBuilder", "shinyCohortBuilder", …
#> $ stars            <int> 16, 2, 4, 0, 1, 2, 2, 10, 4, 22, 1, 4, 7, 0, 0, 0, 0,…
#> $ forks            <int> 0, 1, 0, 0, 0, 0, 0, 1, 0, 5, 0, 3, 5, NA, NA, NA, NA…
#> $ created_at       <dttm> 2022-04-20 10:04:32, 2022-05-22 18:31:55, 2022-05-22…
#> $ last_push        <chr> "2023-03-15T20:06:31Z", "2023-03-15T20:24:15Z", "2023…
#> $ last_activity_at <drtn> 27.39 days, 42.39 days, 42.39 days, 341.39 days, 10.…
#> $ languages        <chr> "R, CSS, JavaScript", "R", "R, CSS, JavaScript, SCSS"…
#> $ issues_open      <int> 5, 22, 27, 3, 66, 0, 0, 0, 1, 0, 6, 3, 38, NA, NA, NA…
#> $ issues_closed    <int> 12, 1, 4, 0, 71, 0, 0, 0, 0, 1, 55, 23, 118, NA, NA, …
#> $ contributors     <chr> "krystian8207, stla, stlagsk, galachad", "krystian820…
#> $ organization     <chr> "r-world-devs", "r-world-devs", "r-world-devs", "r-wo…
#> $ repo_url         <chr> "https://github.com/r-world-devs/shinyGizmo", "https:…
#> $ api_url          <chr> "https://api.github.com", "https://api.github.com", "…

get_commits(git_stats,
  date_from = "2022-01-01",
  date_until = "2023-03-31"
)
#> Rows: 577
#> Columns: 8
#> $ id             <chr> "C_kwDOHNMr29oAKGFjZWNlMDA5ZDNiMWQ2MWY1OWJhZGVlNmNmMzg2…
#> $ committed_date <dttm> 2022-05-23 15:00:08, 2022-05-18 07:32:23, 2023-03-01 1…
#> $ author         <chr> "Adam Forys", "Adam Forys", "Krystian Igras", "Krystian…
#> $ additions      <int> 1, 33, 18, 10, 29, 8, 17, 1, 11, 267, 1, 6, 3, 20, 164,…
#> $ deletions      <int> 1, 6, 11, 7, 14, 4, 8, 1, 5, 146, 1, 4, 3, 9, 107, 21, …
#> $ repository     <chr> "shinyGizmo", "shinyGizmo", "shinyGizmo", "shinyGizmo",…
#> $ organization   <chr> "r-world-devs", "r-world-devs", "r-world-devs", "r-worl…
#> $ api_url        <chr> "https://api.github.com", "https://api.github.com", "ht…
```

### Keyword

With `GitStats` you can look for the activity connected to a certain
phrase.

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
#> Repositories output: Rows number: 21
#> Commits output: Since: 2022-01-20 14:57:56; Rows number: 577

# now pull repos by default by phrase
get_repos(git_stats)
#> Rows: 3
#> Columns: 14
#> $ id               <chr> "495151911", "512764983", "431378047"
#> $ name             <chr> "shinyCohortBuilder", "openpharma_ml", "elaborator"
#> $ stars            <int> 4, 0, 2
#> $ forks            <int> 0, 0, 0
#> $ created_at       <dttm> 2022-05-22, 2022-07-11, 2021-11-24
#> $ last_push        <chr> "2023-03-15T20:54:41Z", "2023-01-16T10:26:05Z", "2022…
#> $ last_activity_at <drtn> 42.39 days, 291.39 days, 225.39 days
#> $ languages        <chr> "R", "Python", "R"
#> $ issues_open      <int> 27, 0, 0
#> $ issues_closed    <int> 0, 0, 0
#> $ contributors     <chr> "krystian8207, galachad", "MathieuCayssol, epijim", "…
#> $ organization     <chr> "r-world-devs", "openpharma", "openpharma"
#> $ repo_url         <chr> "https://api.github.com/repos/r-world-devs/shinyCohor…
#> $ api_url          <chr> "https://api.github.com", "https://api.github.com", "…
```
