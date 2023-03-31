
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
    token = Sys.getenv("GITLAB_PAT"),
    orgs = c("mbtests")
  ) 
#> ✔ Set connection to GitHub.
#> ✔ Set connection to GitLab.
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
#> ✔ Adam Foryś successfully added to team.
#> ✔ Kamil Wais successfully added to team.
#> ✔ Krystian Igras successfully added to team.
#> ✔ Karolina Marcinkowska successfully added to team.
#> ✔ Kamil Koziej successfully added to team.
#> ✔ Maciej Banaś successfully added to team.

setup_preferences(git_stats,
                  search_param = "team",
                  team_name = "RWD")
#> ✔ Your search preferences set to team: RWD.
#> A <GitStats> object for 2 clients:
#> Clients: https://api.github.com, https://gitlab.com/api/v4
#> Organisations: r-world-devs, openpharma, pharmaverse, mbtests
#> Search preference: team
#> Team: RWD (6 members)
#> Phrase: <not defined>
#> Language: <not defined>
#> Storage: <not defined>
#> Storage On/Off: OFF

# now pull repos and commits by default by team
get_repos(git_stats)
#> ℹ [GitHub Public][r-world-devs] Pulling repositories...
#> ℹ Number of repositories: 7
#> ℹ Filtering by team members.
#> ℹ [GitHub Public][openpharma] Pulling repositories...
#> ℹ Number of repositories: 42
#> ℹ Filtering by team members.
#> ℹ [GitHub Public][pharmaverse] Pulling repositories...
#> ℹ Number of repositories: 30
#> ℹ Filtering by team members.
#> ℹ [GitLab][mbtests] Pulling repositories...
#> ℹ Number of repositories: 6
#> ℹ Filtering by team members.
#> Rows: 6
#> Columns: 13
#> $ id               <chr> "gid://gitlab/Project/44565479", "R_kgDOIvtxsg", "R_k…
#> $ name             <chr> "TestRPackage", "GitStats", "shinyTimelines", "facets…
#> $ stars            <int> 0, 1, 2, 4, 9, 0
#> $ forks            <int> 0, 0, 0, 0, 1, 0
#> $ created_at       <dttm> 2023-03-23 08:43:03, 2023-01-09 14:02:20, 2023-02-21 …
#> $ last_push        <chr> NA, "2023-03-31T07:23:04Z", "2023-03-22T14:12:29Z", "…
#> $ last_activity_at <drtn> 8.32 days, 9.32 days, 14.32 days, 214.32 days, 235.3…
#> $ languages        <chr> "", "R", "R, CSS", "R, JavaScript, CSS", "R", "R"
#> $ issues_open      <int> 0, 56, 0, 1, 0, 3
#> $ issues_closed    <int> 0, 67, 0, 0, 0, 0
#> $ contributors     <list> "maciekbanas", "maciekbanas", "krystian8207", "galach…
#> $ organization     <chr> "mbtests", "r-world-devs", "r-world-devs", "openphar…
#> $ api_url          <chr> "https://gitlab.com/api/v4", "https://api.github.com"…

get_commits(git_stats, 
            date_from = "2020-01-01",
            date_until = "2023-03-31")
#> ℹ [GitHub Public][r-world-devs] Pulling repositories...
#> ℹ Number of repositories: 7
#> ℹ [GitHub Public][r-world-devs] Pulling commits...
#> ℹ [GitHub Public][openpharma] Pulling repositories...
#> ℹ Number of repositories: 42
#> ℹ [GitHub Public][openpharma] Pulling commits...
#> ℹ [GitHub Public][pharmaverse] Pulling repositories...
#> ℹ Number of repositories: 30
#> ℹ [GitHub Public][pharmaverse] Pulling commits...
#> ✔ GitHub for 'RWD' team: pulled 632 commits from 16 repositories.
#> ℹ [GitLab][mbtests] Pulling repositories...
#> ℹ Number of repositories: 6
#> ℹ [GitLab][mbtests] Pulling commits...
#> ✔ GitLab for 'RWD' team: pulled 23 commits from 6 repositories.
#> Rows: 655
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
                  phrase = "covid")
#> ✔ Your search preferences set to phrase: covid.
#> A <GitStats> object for 2 clients:
#> Clients: https://api.github.com, https://gitlab.com/api/v4
#> Organisations: r-world-devs, openpharma, pharmaverse, mbtests
#> Search preference: phrase
#> Team: RWD (6 members)
#> Phrase: covid
#> Language: <not defined>
#> Storage: <not defined>
#> Storage On/Off: OFF

# now pull repos by default by phrase
get_repos(git_stats)
#> ✔ On GitHub [r-world-devs] found 1 repositories.
#> ✔ On GitHub [openpharma] found 3 repositories.
#> ✔ On GitHub [pharmaverse] found 3 repositories.
#> ✔ On GitLab [mbtests] found 0 repositories.
#> Rows: 7
#> Columns: 13
#> $ id               <int> 349132982, 601307131, 208896481, 586903986, 396118006…
#> $ name             <chr> "admiral", "workshop-r-swe", "visR", "GitStats", "pha…
#> $ stars            <int> 136, 8, 174, 1, 13, 13, 3
#> $ forks            <int> 35, 2, 31, 0, 3, 1, 1
#> $ created_at       <dttm> 2021-03-18, 2023-02-13, 2019-09-16, 2023-01-09, 2021-…
#> $ last_push        <chr> "2023-03-30T17:00:37Z", "2023-03-28T07:10:44Z", "2022…
#> $ last_activity_at <drtn> 0.33 days, 2.33 days, 7.33 days, 9.33 days, 14.33 da…
#> $ languages        <chr> "R", "Lua", "R", "R", "HTML", "R", "R"
#> $ issues_open      <int> 30, 3, 30, 30, 22, 18, 0
#> $ issues_closed    <int> 0, 0, 0, 0, 0, 0, 0
#> $ contributors     <list> "bundfussr, thomas-neitmann, bms63, rossfarrugia, mil…
#> $ organization     <chr> "pharmaverse", "openpharma", "openpharma", "r-world-…
#> $ api_url          <chr> "https://api.github.com", "https://api.github.com", "…
```
