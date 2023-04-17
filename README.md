
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

setup_preferences(git_stats,
  search_param = "team",
  team_name = "RWD"
)
#> A <GitStats> object for 2 clients:
#> Hosts: https://api.github.com, https://gitlab.com/api/v4
#> Organisations: r-world-devs, openpharma, pharmaverse, mbtests
#> Search preference: team
#> Team: RWD (6 members)
#> Phrase: <not defined>
#> Language: <not defined>
#> Storage: <not defined>
#> Storage On/Off: OFF

# now pull repos and commits by default by team
get_repos(git_stats)
#> Rows: 6
#> Columns: 14
#> $ id               <chr> "R_kgDOJWYrCA", "R_kgDOIvtxsg", "R_kgDOJAtHJA", "MDEw…
#> $ name             <chr> "hypothesis", "GitStats", "shinyTimelines", "facetsr"…
#> $ stars            <int> 0, 1, 2, 4, 9, 0
#> $ forks            <int> 0, 0, 0, 0, 1, 0
#> $ created_at       <dttm> 2023-04-13 13:52:24, 2023-01-09 14:02:20, 2023-02-21 …
#> $ last_push        <chr> "2023-04-14T10:36:24Z", "2023-04-17T08:00:59Z", "2023…
#> $ last_activity_at <drtn> 3.34 days, 26.34 days, 31.34 days, 231.34 days, 252.…
#> $ languages        <chr> "R, JavaScript", "R", "R, CSS", "R, JavaScript, CSS",…
#> $ issues_open      <int> 0, 59, 0, 1, 0, 3
#> $ issues_closed    <int> 0, 69, 0, 0, 0, 0
#> $ contributors     <chr> "krystian8207", "maciekbanas", "krystian8207", "gala…
#> $ organization     <chr> "r-world-devs", "r-world-devs", "r-world-devs", "open…
#> $ api_url          <chr> "https://api.github.com", "https://api.github.com", "…
#> $ repo_url         <chr> "https://github.com/r-world-devs/hypothesis", "https:…

get_commits(git_stats,
  date_from = "2022-01-01",
  date_until = "2023-03-31"
)
#> Rows: 604
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
setup_preferences(git_stats,
  search_param = "phrase",
  phrase = "covid"
)
#> A <GitStats> object for 2 clients:
#> Hosts: https://api.github.com, https://gitlab.com/api/v4
#> Organisations: r-world-devs, openpharma, pharmaverse, mbtests
#> Search preference: phrase
#> Team: RWD (6 members)
#> Phrase: covid
#> Language: <not defined>
#> Storage: <not defined>
#> Storage On/Off: OFF

# now pull repos by default by phrase
get_repos(git_stats)
#> Rows: 7
#> Columns: 14
#> $ id               <int> 349132982, 396118006, 601307131, 208896481, 586903986…
#> $ name             <chr> "admiral", "pharmaverse", "workshop-r-swe", "visR", "…
#> $ stars            <int> 141, 14, 8, 174, 1, 13, 3
#> $ forks            <int> 36, 3, 3, 31, 0, 1, 1
#> $ created_at       <dttm> 2021-03-18, 2021-08-14, 2023-02-13, 2019-09-16, 2023-…
#> $ last_push        <chr> "2023-04-16T14:55:16Z", "2023-04-14T10:08:06Z", "2023…
#> $ last_activity_at <drtn> 2.34 days, 14.34 days, 19.34 days, 24.34 days, 26.34…
#> $ languages        <chr> "R", "HTML", "Lua", "R", "R", "R", "R"
#> $ issues_open      <int> 30, 22, 1, 30, 30, 23, 0
#> $ issues_closed    <int> 0, 0, 0, 0, 0, 0, 0
#> $ contributors     <list> "bundfussr, thomas-neitmann, bms63, rossfarrugia, mil…
#> $ repo_url         <chr> "https://api.github.com/projects/349132982", "https:…
#> $ organization     <chr> "pharmaverse", "pharmaverse", "openpharma", "openphar…
#> $ api_url          <chr> "https://api.github.com", "https://api.github.com", "…
```
