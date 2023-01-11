
<!-- README.md is generated from README.Rmd. Please edit that file -->

# GitStats

<!-- badges: start -->
<!-- badges: end -->

***WORK IN PROGRESS***

The goal of GitStats is to search through multiple GitHub and GitLab
platforms for different statistics either by owners/groups of
repositories, team members or searched codephrases.

For the time being GitStats supports connections to public GitHub,
enterprise GitHub and GitLab.

## Installation

Development version:

``` r
devtools::install_github("r-world-devs/GitStats")
```

## Start - set connections

Start with setting your git connection.

``` r
library(GitStats)

my_gitstats <- GitStats$new()

my_gitstats$set_connection(api_url = "https://api.github.com",
                           token = Sys.getenv("GITHUB_PAT"),
                           owners_groups = c("r-world-devs", "openpharma"))

my_gitstats
```

### Multiple connections

As GitStats provides possibility of showing stats through multiple
platforms, you can pass more than one connection.

``` r

  cons <- tibble::tibble(api_url = c("https://api.github.com", "https://github.roche.com/api/v3", "https://code.roche.com/api/v4"),
                         token = c(Sys.getenv("GITHUB_PAT"), Sys.getenv("GITHUB_PAT_ROCHE"),Sys.getenv("GITLAB_PAT")),
                         owners_groups = list(c("openpharma", "r-world-devs"),  c("RWDScodeshare"), c("RWDInsightsEngineering", "rwdhubproducts")))
  
  cons
                         
  my_gitstats <- GitStats$new()

  purrr::pwalk(cons, function(api_url, token, owners_groups){
    my_gitstats$set_connection(api_url = api_url,
                               token = token,
                               owners_groups = owners_groups)
  })
```

## Explore

And start your exploration for repos and commits, e.g. by owners and
groups:

``` r
repos <- my_gitstats$get_repos_by_owner_or_group()

head(repos)
```

``` r
commits <- my_gitstats$get_commits_by_owner_or_group()

head(commits)
```

### Codephrase

You can search for repos by a keyword:

``` r

repos <- my_gitstats$get_repos_by_codephrase("Hobbits")

head(repos)
```

### Team

You can look for the repositories and other information, where engaged
is your team. First you need to specify your team members (by
git-platform logins), then do the search.

``` r
my_gitstats$set_team(team_name = "Avengers", "thor", "black_widow", "hulk", "spider-man", "iron-man")

my_gitstats$get_repos_by_team("Avengers")
```

## Plots

You can plot your exploration with chaining methods inside GitStats
class object:

``` r

my_gitstats$get_repos_by_owner_or_group()$plot_repos()
```

Once you’ve finished your exploration you can plot repos without calling
exploration method:

``` r

my_gitstats$plot_repos()
```

By default 10 top repositories (last active) are shown, but you can set
more to visualize:

``` r

my_gitstats$plot_repos(repos_n = 25)
```
