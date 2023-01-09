
<!-- README.md is generated from README.Rmd. Please edit that file -->

# GitStats

Please be reminded, that this work is still IN PROGRESS!

<!-- badges: start -->
<!-- badges: end -->

The goal of GitStats is to search through multiple GitHub and GitLab
platforms for statistics.

For the time being GitStats supports connections to public GitHub,
enterprise GitHub and GitLab.

## Installation

You can install the development version of GitStats like so:

``` r
devtools::install_github("r-world-devs/GitStats")
```

## How to start

Start with setting your git connections: choose GitHub Client or GitLab
Client class. Choose your owners (GitHub) or group/groups (GitLab).
Provide API url and a token.

``` r
my_github <- GitHubClient$new(
  owners = "r-world-devs",
  rest_api_url = "api.github.com",
  token = Sys.getenv("GITHUB_PAT")
)

my_gitlab <- GitLabClient$new(
  groups = c("my_group", "my_second_group"),
  rest_api_url = "your_api_url.com",
  token = Sys.getenv("GITLAB_PAT)
)
```

Wrap all your Clients into new GitStats object (you can have them more
than two):

``` r
MyGitStats <- GitStats$new(
    my_github, my_gitlab
  )
```

And start your exploration:

``` r
MyGitStats$get_repos_by_owner()
```

## Team

You can look for the repositories and other information, where engaged
is your team. First you need to specify your team members (by
git-platform logins), then do the search.

``` r
MyGitStats$set_team(team_name = "Avengers", "thor", "black_widow", "hulk", "spider-man", "iron-man")

MyGitStats$get_repos_by_team("Avengers")
```
