
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

Please remember to have your access tokens stored as environment
variables: `GITHUB_PAT` for access to GitHub API and `GITLAB_PAT` for
GitLab API.

You can start by creating your `GitStats` object, where you will hold
information on your multiple connections.

``` r
library(GitStats)

git_stats <- create_gitstats() %>%
  set_host(
    api_url = "https://api.github.com",
    orgs = c("r-world-devs", "openpharma"),
    token = Sys.getenv("GITHUB_PAT")
  ) %>%
  set_host(
    api_url = "https://gitlab.com/api/v4",
    orgs = c("mbtests"),
    token = Sys.getenv("GITLAB_PAT_PUBLIC")
  )
```

By default your search preferences are set to `organizations` (`org`).

``` r
git_stats
#> A <GitStats> object for 2 hosts:
#> Hosts: https://api.github.com, https://gitlab.com/api/v4
#> Organisations: [3] r-world-devs, openpharma, mbtests
#> Search preference: org
#> Team: <not defined>
#> Phrase: <not defined>
#> Language: All
#> Repositories output: <not defined>
#> Commits output: <not defined>

pull_repos(
  git_stats
)
#> Rows: 65
#> Columns: 12
#> $ id               <chr> "R_kgDOHNMr2w", "R_kgDOHYNOFQ", "R_kgDOHYNrJw", "R_kg…
#> $ name             <chr> "shinyGizmo", "cohortBuilder", "shinyCohortBuilder", …
#> $ stars            <int> 16, 3, 5, 0, 1, 2, 0, 2, 7, 176, 4, 10, 1, 19, 0, 1, …
#> $ forks            <int> 0, 2, 0, 0, 0, 0, 0, 0, 4, 31, 1, 1, 0, 4, 1, 1, 0, 0…
#> $ created_at       <dttm> 2022-04-20 10:04:32, 2022-05-22 18:31:55, 2022-05-22…
#> $ last_activity_at <drtn> 129.51 days, 132.51 days, 17.51 days, 412.51 days, 0…
#> $ languages        <chr> "R, CSS, JavaScript", "R", "R, CSS, JavaScript, SCSS"…
#> $ issues_open      <int> 6, 22, 32, 3, 79, 0, 0, 3, 6, 16, 0, 0, 0, 4, 0, 0, 0…
#> $ issues_closed    <int> 12, 1, 4, 0, 115, 0, 0, 0, 1, 167, 0, 0, 0, 16, 0, 0,…
#> $ organization     <chr> "r-world-devs", "r-world-devs", "r-world-devs", "r-wo…
#> $ repo_url         <chr> "https://github.com/r-world-devs/shinyGizmo", "https:…
#> $ api_url          <chr> "https://api.github.com/repositories/r-world-devs/shi…

pull_commits(
  git_stats,
  date_from = "2023-01-01",
  date_until = "2023-03-31"
)
#> Rows: 798
#> Columns: 8
#> $ id             <chr> "C_kwDOHNMr29oAKGI3ZmRlYTNkNjY0NmM2MmRmMzA0N2Y0NDhkODQy…
#> $ committed_date <dttm> 2023-03-01 15:05:10, 2023-03-01 14:58:22, 2023-02-28 1…
#> $ author         <chr> "Krystian Igras", "Krystian Igras", "Krystian Igras", "…
#> $ additions      <int> 296, 18, 10, 29, 8, 17, 1, 11, 267, 876, 1, 6, 3, 20, 1…
#> $ deletions      <int> 153, 11, 7, 14, 4, 8, 1, 5, 146, 146, 1, 4, 3, 9, 107, …
#> $ repository     <chr> "shinyGizmo", "shinyGizmo", "shinyGizmo", "shinyGizmo",…
#> $ organization   <chr> "r-world-devs", "r-world-devs", "r-world-devs", "r-worl…
#> $ api_url        <chr> "https://api.github.com", "https://api.github.com", "ht…
```

Finally you can retrieve your repos to separate object.

``` r
repos_dt <- get_repos(git_stats)
commits_dt <- get_commits(git_stats)
```

## Set

You can setup your search preferences, either to `org`, `team` or
`phrase`.

### Team

If you with to setup your search parameter to team, add your team
members first:

``` r

git_stats %>%
  set_team_member("Kamil Wais", "kalimu") %>%
  set_team_member("Krystian Igras", "krystian8207") %>%
  set_team_member("Karolina Marcinkowska", "marcinkowskak") %>%
  set_team_member("Kamil Koziej", "Cotau") %>%
  set_team_member("Maciej Banaś", "maciekbanas") %>% 
  set_params(
    search_param = "team",
    team_name = "RWD"
  ) %>% 
  pull_repos()
#> Rows: 18
#> Columns: 13
#> $ id               <chr> "R_kgDOIvtxsg", "R_kgDOJAtHJA", "R_kgDOHNMr2w", "R_kg…
#> $ name             <chr> "GitStats", "shinyTimelines", "shinyGizmo", "cohortBu…
#> $ stars            <int> 1, 2, 16, 3, 5, 2, 10, 22, 2, 0, 0, 0, 0, 0, 0, 0, 0,…
#> $ forks            <int> 0, 0, 0, 2, 0, 0, 1, 5, 1, NA, NA, NA, NA, NA, NA, NA…
#> $ created_at       <dttm> 2023-01-09 14:02:20, 2023-02-21 16:41:59, 2022-04-20…
#> $ last_activity_at <drtn> 0.51 days, 132.51 days, 129.51 days, 132.51 days, 17…
#> $ languages        <chr> "R", "R, CSS", "R, CSS, JavaScript", "R", "R, CSS, Ja…
#> $ issues_open      <dbl> 79, 0, 6, 22, 32, 3, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 1,…
#> $ issues_closed    <dbl> 115, 0, 12, 1, 4, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
#> $ organization     <chr> "r-world-devs", "r-world-devs", "r-world-devs", "r-wo…
#> $ repo_url         <chr> "https://github.com/r-world-devs/GitStats", "https://…
#> $ api_url          <chr> "https://api.github.com/repositories/r-world-devs/Git…
#> $ contributors     <chr> "maciekbanas, Cotau", "krystian8207", "krystian8207, …

pull_commits(
  gitstats_obj = git_stats,
  date_from = "2023-01-01",
  date_until = "2023-03-31"
)
#> Rows: 398
#> Columns: 8
#> $ id             <chr> "C_kwDOHNMr29oAKGI3ZmRlYTNkNjY0NmM2MmRmMzA0N2Y0NDhkODQy…
#> $ committed_date <dttm> 2023-03-01 15:05:10, 2023-03-01 14:58:22, 2023-02-28 1…
#> $ author         <chr> "Krystian Igras", "Krystian Igras", "Krystian Igras", "…
#> $ additions      <int> 296, 18, 10, 29, 8, 17, 1, 11, 267, 876, 1, 6, 3, 20, 1…
#> $ deletions      <int> 153, 11, 7, 14, 4, 8, 1, 5, 146, 146, 1, 4, 3, 9, 107, …
#> $ repository     <chr> "shinyGizmo", "shinyGizmo", "shinyGizmo", "shinyGizmo",…
#> $ organization   <chr> "r-world-devs", "r-world-devs", "r-world-devs", "r-worl…
#> $ api_url        <chr> "https://api.github.com", "https://api.github.com", "ht…
```

### Phrase

With `GitStats` you can look for the repos with a certain phrase in code
blobs.

``` r
set_params(
  gitstats_obj = git_stats,
  search_param = "phrase",
  phrase = "shiny"
) %>% 
  pull_repos()
#> Rows: 4
#> Columns: 12
#> $ id               <chr> "495151911", "586903986", "431378047", "512764983"
#> $ name             <chr> "shinyCohortBuilder", "GitStats", "elaborator", "open…
#> $ stars            <int> 5, 1, 2, 0
#> $ forks            <int> 0, 0, 0, 0
#> $ created_at       <dttm> 2022-05-22 19:04:12, 2023-01-09 14:02:20, 2021-11-24 …
#> $ last_activity_at <drtn> 17.17 days, 0.00 days, 579.96 days, 124.95 days
#> $ languages        <chr> "R", "R", "R", "Python"
#> $ issues_open      <int> 30, 30, 0, 0
#> $ issues_closed    <int> 0, 0, 0, 0
#> $ organization     <chr> "r-world-devs", "r-world-devs", "openpharma", "openph…
#> $ repo_url         <chr> "https://github.com/r-world-devs/shinyCohortBuilder",…
#> $ api_url          <chr> "https://api.github.com/repos/r-world-devs/shinyCoho…
```

### Language

You can define a programming language in your settings.

``` r
set_params(
  gitstats_obj = git_stats,
  search_param = "org",
  language = "JavaScript"
) %>% 
  pull_repos()
#> Rows: 6
#> Columns: 12
#> $ id               <chr> "R_kgDOHNMr2w", "R_kgDOHYNrJw", "R_kgDOJWYrCA", "MDEw…
#> $ name             <chr> "shinyGizmo", "shinyCohortBuilder", "hypothesis", "fa…
#> $ stars            <int> 16, 5, 2, 4, 0, 3
#> $ forks            <int> 0, 0, 0, 0, 0, 0
#> $ created_at       <dttm> 2022-04-20 10:04:32, 2022-05-22 19:04:12, 2023-04-13 …
#> $ last_activity_at <drtn> 129.51 days, 17.51 days, 57.51 days, 1018.51 days, 44…
#> $ languages        <chr> "R, CSS, JavaScript", "R, CSS, JavaScript, SCSS", "R…
#> $ issues_open      <int> 6, 32, 3, 1, 0, 2
#> $ issues_closed    <int> 12, 4, 0, 0, 0, 2
#> $ organization     <chr> "r-world-devs", "r-world-devs", "r-world-devs", "ope…
#> $ repo_url         <chr> "https://github.com/r-world-devs/shinyGizmo", "https:…
#> $ api_url          <chr> "https://api.github.com/repositories/r-world-devs/shi…
```

You can always get back to All languages.

``` r
reset_language(git_stats)
#> A <GitStats> object for 2 hosts:
#> Hosts: https://api.github.com, https://gitlab.com/api/v4
#> Organisations: [3] r-world-devs, openpharma, mbtests
#> Search preference: org
#> Team: RWD (5 members)
#> Phrase: shiny
#> Language: All
#> Repositories output: Rows number: 6
#> Commits output: Since: 2023-01-09 14:54:35; Until: 2023-03-30 14:35:34; Rows number: 398
```

## Users

You can retrieve data about users with GitStats.

``` r
pull_users(
  gitstats_obj = git_stats,
  users = c("maciekbanas", "kalimu", "Cotau", "marcinkowskak", "@krystian8207")
)
#> Rows: 7
#> Columns: 12
#> $ id            <chr> "MDQ6VXNlcjc0MjEyOTMz", "MDQ6VXNlcjI1MjIyMzY=", "MDQ6VXN…
#> $ name          <chr> "Maciej Banaś", "Kamil Wais", "", "Karolina Marcinkowska…
#> $ login         <chr> "maciekbanas", "kalimu", "Cotau", "marcinkowskak", "maci…
#> $ email         <chr> "", "kamil.wais@gmail.com", "", "", "", "", ""
#> $ location      <chr> "", "Rzeszów", "", "Warsaw, Poland", "", "", ""
#> $ starred_repos <int> 15, 80, 1, 0, 0, 0, 0
#> $ commits       <int> 435, 0, 1, 0, NA, NA, NA
#> $ issues        <int> 201, 0, 2, 1, NA, NA, NA
#> $ pull_requests <int> 98, 1, 6, 2, 1, 0, 0
#> $ reviews       <int> 4, 0, 27, 12, 0, 0, 0
#> $ avatar_url    <chr> "https://avatars.githubusercontent.com/u/74212933?u=f85d…
#> $ web_url       <chr> "", "kalimu.github.io", "", "", "https://gitlab.com/maci…
```

## Reset your settings

If you wish to get back to default settings, run:

``` r
reset(git_stats)
#> A <GitStats> object for 2 hosts:
#> Hosts: https://api.github.com, https://gitlab.com/api/v4
#> Organisations: [3] r-world-devs, openpharma, mbtests
#> Search preference: org
#> Team: <not defined>
#> Phrase: <not defined>
#> Language: All
#> Repositories output: Rows number: 6
#> Commits output: Since: 2023-01-09 14:54:35; Until: 2023-03-30 14:35:34; Rows number: 398
```

### Acknowledgement

Special thanks to:

- Kamil Koziej @Cotau - for reviewing permanently my pull requests and
  suggesting more efficient solutions,
- Karolina Marcinkowska @marcinkowskak - for substantial improvements on
  plots,
- Krystian Igraś @krystian8207 - for the major review of GitStats and,
- Matt Secrest @mattsecrest - for making use of your scripts to apply
  search feature,
- Kamil Wais @kalimu, Adam Foryś @galachad - for your guidelines at the
  very beginning of the project.
