
<!-- README.md is generated from README.Rmd. Please edit that file -->

# GitStats <img src="man/figures/GitStats_logo.png" align="right" height="138" style="float:right; height:138px;"/>

<!-- badges: start -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/r-world-devs/GitStats/workflows/R-CMD-check/badge.svg)](https://github.com/r-world-devs/GitStats/actions)
[![Codecov test
coverage](https://codecov.io/gh/r-world-devs/GitStats/branch/devel/graph/badge.svg)](https://app.codecov.io/gh/r-world-devs/GitStats?branch=devel)
<!-- badges: end -->

With GitStats you can pull git data in a uniform way (table format) from
GitHub and GitLab. For the time-being you can get data on:

- repositories,
- commits,
- users,
- release logs,
- text files content,
- R package usage.

## Installation

From CRAN:

``` r
install.packages("GitStats")
```

From GitHub:

``` r
devtools::install_github("r-world-devs/GitStats")
```

## Examples:

Setup your `GitStats`:

``` r
library(GitStats)

git_stats <- create_gitstats() |>
  set_gitlab_host(
    repos = "mbtests/gitstatstesting"
  ) |>
  set_github_host(
    orgs = "r-world-devs",
    repos = "openpharma/DataFakeR"
  ) 
```

Get commits:

``` r
commits <- git_stats |>
  get_commits(
    since = "2022-01-01"
  )

commits
#> # A tibble: 2,178 × 11
#>    id    committed_date      author author_login author_name additions deletions
#>    <chr> <dttm>              <chr>  <chr>        <chr>           <int>     <int>
#>  1 7f48… 2024-09-10 11:12:59 Macie… maciekbanas  Maciej Ban…         0         0
#>  2 9c66… 2024-09-10 10:35:37 Macie… maciekbanas  Maciej Ban…         0         0
#>  3 fca2… 2024-09-10 10:31:24 Macie… maciekbanas  Maciej Ban…         0         0
#>  4 e8f2… 2023-03-30 14:15:33 Macie… maciekbanas  Maciej Ban…         1         0
#>  5 7e87… 2023-02-10 09:48:55 Macie… maciekbanas  Maciej Ban…         1         1
#>  6 62c4… 2023-02-10 09:17:24 Macie… maciekbanas  Maciej Ban…         2        87
#>  7 55cf… 2023-02-10 09:07:54 Macie… maciekbanas  Maciej Ban…        92         0
#>  8 C_kw… 2023-05-08 09:43:31 Kryst… krystian8207 Krystian I…        18         0
#>  9 C_kw… 2023-04-28 12:30:40 Kamil… <NA>         Kamil Kozi…        18         0
#> 10 C_kw… 2023-03-01 15:05:10 Kryst… krystian8207 Krystian I…       296       153
#> # ℹ 2,168 more rows
#> # ℹ 4 more variables: repository <chr>, organization <chr>, repo_url <chr>,
#> #   api_url <glue>

commits |>
  get_commits_stats(
    time_aggregation = "month",
    group_var = author
  )
#> # A tibble: 228 × 4
#>    stats_date          githost author             stats
#>    <dttm>              <chr>   <chr>              <int>
#>  1 2022-01-01 00:00:00 github  Admin_mschuemi         1
#>  2 2022-01-01 00:00:00 github  Gowtham Rao            5
#>  3 2022-01-01 00:00:00 github  Krystian Igras         1
#>  4 2022-01-01 00:00:00 github  Martijn Schuemie       1
#>  5 2022-02-01 00:00:00 github  Hadley Wickham         3
#>  6 2022-02-01 00:00:00 github  Martijn Schuemie       2
#>  7 2022-02-01 00:00:00 github  Maximilian Girlich    13
#>  8 2022-02-01 00:00:00 github  Reijo Sund             1
#>  9 2022-02-01 00:00:00 github  eitsupi                1
#> 10 2022-03-01 00:00:00 github  Maximilian Girlich    14
#> # ℹ 218 more rows
```

Get repositories:

``` r
git_stats |>
  get_repos(
    with_code = "shiny",
    add_contributors = FALSE
  )
#> # A tibble: 6 × 16
#>   repo_id   repo_name          organization fullname   platform repo_url api_url
#>   <chr>     <chr>              <chr>        <chr>      <chr>    <chr>    <chr>  
#> 1 627452680 hypothesis         r-world-devs r-world-d… github   https:/… https:…
#> 2 604718884 shinyTimelines     r-world-devs r-world-d… github   https:/… https:…
#> 3 495151911 shinyCohortBuilder r-world-devs r-world-d… github   https:/… https:…
#> 4 495144469 cohortBuilder      r-world-devs r-world-d… github   https:/… https:…
#> 5 884789327 GitAI              r-world-devs r-world-d… github   https:/… https:…
#> 6 586903986 GitStats           r-world-devs r-world-d… github   https:/… https:…
#> # ℹ 9 more variables: created_at <dttm>, last_activity_at <dttm>,
#> #   last_activity <drtn>, default_branch <chr>, stars <int>, forks <int>,
#> #   languages <chr>, issues_open <int>, issues_closed <int>
```

Get files:

``` r
git_stats |>
  get_files(
    pattern = "\\.md",
    depth = 2L
  )
#> # A tibble: 51 × 8
#>    repo_name      repo_id organization file_path file_content file_size repo_url
#>    <chr>          <chr>   <chr>        <chr>     <chr>            <int> <chr>   
#>  1 GitStats Test… gid://… mbtests      README.md "# GitStats…       122 https:/…
#>  2 shinyGizmo     R_kgDO… r-world-devs NEWS.md   "# shinyGiz…      2186 https:/…
#>  3 shinyGizmo     R_kgDO… r-world-devs README.md "\n# shinyG…      2337 https:/…
#>  4 shinyGizmo     R_kgDO… r-world-devs cran-com… "## Test en…      1700 https:/…
#>  5 cohortBuilder  R_kgDO… r-world-devs NEWS.md   "# cohortBu…       917 https:/…
#>  6 cohortBuilder  R_kgDO… r-world-devs README.md "\n# cohort…     15828 https:/…
#>  7 shinyCohortBu… R_kgDO… r-world-devs NEWS.md   "# shinyCoh…      2018 https:/…
#>  8 shinyCohortBu… R_kgDO… r-world-devs README.md "\n# shinyC…      3355 https:/…
#>  9 cohortBuilder… R_kgDO… r-world-devs README.md "\n# cohort…      3472 https:/…
#> 10 GitStats       R_kgDO… r-world-devs LICENSE.… "# MIT Lice…      1075 https:/…
#> # ℹ 41 more rows
#> # ℹ 1 more variable: api_url <chr>
```

Get package usage:

``` r
git_stats |>
  get_R_package_usage(
    packages = c("shiny", "purrr"),
    split_output = TRUE
  )
#> $shiny
#> # A tibble: 5 × 11
#>   package package_usage   repo_id   repo_fullname       repo_name default_branch
#>   <chr>   <chr>           <chr>     <chr>               <chr>     <chr>         
#> 1 shiny   import          495144469 r-world-devs/cohor… cohortBu… dev           
#> 2 shiny   import, library 495151911 r-world-devs/shiny… shinyCoh… dev           
#> 3 shiny   import, library 604718884 r-world-devs/shiny… shinyTim… master        
#> 4 shiny   import, library 884789327 r-world-devs/GitAI  GitAI     main          
#> 5 shiny   import, library 627452680 r-world-devs/hypot… hypothes… master        
#> # ℹ 5 more variables: created_at <dttm>, organization <chr>, repo_url <chr>,
#> #   api_url <chr>, platform <chr>
#> 
#> $purrr
#> # A tibble: 6 × 11
#>   package package_usage repo_id   repo_fullname         repo_name default_branch
#>   <chr>   <chr>         <chr>     <chr>                 <chr>     <chr>         
#> 1 purrr   import        495144469 r-world-devs/cohortB… cohortBu… dev           
#> 2 purrr   import        495151911 r-world-devs/shinyCo… shinyCoh… dev           
#> 3 purrr   import        586903986 r-world-devs/GitStats GitStats  master        
#> 4 purrr   import        884789327 r-world-devs/GitAI    GitAI     main          
#> 5 purrr   import        627452680 r-world-devs/hypothe… hypothes… master        
#> 6 purrr   import        402384343 openpharma/DataFakeR  DataFakeR master        
#> # ℹ 5 more variables: created_at <dttm>, organization <chr>, repo_url <chr>,
#> #   api_url <chr>, platform <chr>
#> 
#> attr(,"class")
#> [1] "R_package_usage" "list"           
#> attr(,"packages")
#> [1] "shiny" "purrr"
#> attr(,"only_loading")
#> [1] FALSE
```

Print `GitStats` to see what it stores:

``` r
git_stats
#> A GitStats object for 2 hosts: 
#> Hosts: https://gitlab.com/api/v4, https://api.github.com
#> Scanning scope: 
#>  Organizations: [1] r-world-devs
#>  Repositories: [2] mbtests/gitstatstesting, openpharma/DataFakeR
#> Storage: 
#>  Repositories: 6 
#>  Commits: 2178 [date range: 2022-01-01 - 2025-01-10]
#>  Files: 51 [file pattern: \.md]
#>  R_package_usage: 2 [packages: shiny, purrr]
```

## Acknowledgement

Special thanks to [James Black](https://github.com/epijim), [Karolina
Marcinkowska](https://github.com/marcinkowskak), [Kamil
Koziej](https://github.com/Cotau), [Matt
Secrest](https://github.com/mattsecrest), [Krystian
Igras](https://github.com/krystian8207), [Kamil
Wais](https://github.com/kalimu), [Adam
Forys](https://github.com/galachad) - for the support in the package
development.
