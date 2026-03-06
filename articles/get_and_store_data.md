# Get and store your data

Set connections to hosts.

> Example workflow makes use of public GitHub and GitLab, but it is
> plausible, that you will use your internal git platforms, where you
> need to define `host` parameter. See
> [`vignette("set_hosts")`](https://r-world-devs.github.io/GitStats/articles/set_hosts.md)
> article on that.

``` r
library(GitStats)

git_stats <- create_gitstats() |>
  set_github_host(
    orgs = c("r-world-devs", "openpharma"),
    token = Sys.getenv("GITHUB_PAT")
  ) |>
  set_gitlab_host(
    orgs = c("mbtests"),
    token = Sys.getenv("GITLAB_PAT_PUBLIC")
  )
#> → Checking owners...
#> ✔ Set connection to GitHub.
#> → Checking owners...
#> ✔ Set connection to GitLab.
```

As scanning scope was set to `organizations` (`orgs` parameter in
`set_*_host()`), `GitStats` will pull all repositories from these
organizations.

``` r
repos <- get_repos(git_stats, progress = FALSE)
#> → Pulling repositories data...
#> ✔ Data pulled in 35.8 secs
dplyr::glimpse(repos)
#> Rows: 99
#> Columns: 19
#> $ repo_id          <chr> "R_kgDOHNMr2w", "R_kgDOHYNOFQ", "R_kgDOHYNrJw", "R_kg…
#> $ repo_name        <chr> "shinyGizmo", "cohortBuilder", "shinyCohortBuilder", …
#> $ repo_fullpath    <chr> "r-world-devs/shinyGizmo", "r-world-devs/cohortBuilde…
#> $ default_branch   <chr> "dev", "dev", "dev", "master", "master", "master", "m…
#> $ stars            <int> 21, 9, 10, 0, 9, 3, 0, 2, 1, 0, 0, 0, 1, 1, 3, 8, 1, …
#> $ forks            <int> 0, 2, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 2, 0, 6,…
#> $ created_at       <dttm> 2022-04-20 10:04:32, 2022-05-22 18:31:55, 2022-05-22…
#> $ last_activity_at <dttm> 2024-07-12, 2026-02-26, 2026-02-26, 2024-06-13, 2026…
#> $ languages        <chr> "R, CSS, JavaScript", "R", "R, CSS, JavaScript, SCSS"…
#> $ issues_open      <int> 6, 34, 36, 3, 100, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 11, …
#> $ issues_closed    <int> 12, 11, 17, 0, 366, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 60,…
#> $ organization     <chr> "r-world-devs", "r-world-devs", "r-world-devs", "r-wo…
#> $ repo_url         <chr> "https://github.com/r-world-devs/shinyGizmo", "https:…
#> $ commit_sha       <chr> "735ec6ea367e6f9856eb0fe650d3c51c3a1aefb5", "a404b64e…
#> $ api_url          <chr> "https://api.github.com/repos/r-world-devs/shinyGizmo…
#> $ githost          <chr> "github", "github", "github", "github", "github", "gi…
#> $ last_activity    <drtn> 602.58 days, 8.58 days, 8.58 days, 631.58 days, 0.58…
#> $ contributors     <chr> "krystian8207, stla, galachad, stlagsk", "krystian820…
#> $ contributors_n   <int> 4, 3, 4, 1, 5, 1, 6, 2, 1, 141, 2, 3, 1, 1, 1, 6, 44,…
```

You can always go for the lighter version of `get_repos`,
i.e. [`get_repos_urls()`](https://r-world-devs.github.io/GitStats/reference/get_repos_urls.md)
which will print you a vector of URLs instead of whole table.

``` r
repos_urls <- get_repos_urls(git_stats)
#> → Pulling repositories URLs...
#> ✔ Data pulled in 4.2 secs
dplyr::glimpse(repos_urls)
#>  'gitstats_repos_urls' chr [1:99] "https://api.github.com/repos/r-world-devs/shinyGizmo" ...
#>  - attr(*, "type")= chr "api"
```

## Verbose mode

If messages overwhelm you, you can switch them off in the function:

``` r
release_logs <- get_release_logs(
  gitstats = git_stats,
  since = "2024-01-01",
  verbose = FALSE
)
#> → Pulling release logs..
#> GitHub ■■■■■■■■■■■■■■■■                  50% |  ETA:  5s
#> ✔ Data pulled in 29.8 secs
dplyr::glimpse(release_logs)
#> Rows: 97
#> Columns: 7
#> $ repo_name    <chr> "cohortBuilder", "cohortBuilder", "shinyCohortBuilder", "…
#> $ repo_url     <chr> "https://github.com/r-world-devs/cohortBuilder", "https:/…
#> $ release_name <chr> "cohortBuilder 0.4.0", "cohortBuilder 0.3.0", "shinyCohor…
#> $ release_tag  <chr> "v0.4.0", "v0.3.0", "v0.4.0", "v0.3.1", "v0.3.0", "v2.3.9…
#> $ published_at <dttm> 2026-02-26 15:06:49, 2024-09-27 11:35:06, 2026-02-26 15:…
#> $ release_url  <chr> "https://github.com/r-world-devs/cohortBuilder/releases/t…
#> $ release_log  <chr> "* Multi discrete filter does not operate on `dplyr::acro…
```

Or globally:

``` r
verbose_off(git_stats)
```

## Cache

After pulling, the data is saved to `GitStats`.

``` r
commits <- get_commits(
  gitstats = git_stats,
  since = "2024-06-01",
  until = "2024-06-30",
  progress = FALSE
)
#> → Pulling commits...
#> ✔ Data pulled in 22.9 secs
dplyr::glimpse(commits)
#> Rows: 188
#> Columns: 11
#> $ repo_name      <chr> "cohortBuilder", "cohortBuilder", "cohortBuilder", "coh…
#> $ id             <chr> "C_kwDOHYNOFdoAKGU3Mjg5MTViZGM4YzYzMTIwOWEwMzEwMDIwOTA0…
#> $ committed_date <dttm> 2024-06-05 11:02:21, 2024-06-05 10:55:59, 2024-06-05 1…
#> $ author         <chr> "Kamil Koziej", "Kamil Koziej", "Kamil Koziej", "Krysti…
#> $ author_login   <chr> NA, NA, NA, "krystian8207", "krystian8207", "krystian82…
#> $ author_name    <chr> "Kamil Koziej", "Kamil Koziej", "Kamil Koziej", "Krysti…
#> $ additions      <int> 559, 0, 219, 1, 2, 108, 38, 83, 14, 1596, 973, 1292, 3,…
#> $ deletions      <int> 304, 19, 87, 1, 1, 1, 0, 29, 0, 340, 163, 799, 6, 54, 1…
#> $ organization   <chr> "r-world-devs", "r-world-devs", "r-world-devs", "r-worl…
#> $ repo_url       <chr> "https://github.com/r-world-devs/cohortBuilder", "https…
#> $ api_url        <glue> "https://api.github.com/graphql", "https://api.github.…
```

Caching feature is by default turned on. If you run the `get_*()`
function once more, data will be retrieved from `GitStats` object.

``` r
commits <- get_commits(
  gitstats = git_stats,
  since = "2024-06-01",
  until = "2024-06-30"
)
#> ! Getting cached commits data.
#> ℹ If you wish to pull the data from API once more, set `cache` parameter to `FALSE`.
#> ✔ Data pulled in 0 secs
dplyr::glimpse(commits)
#> Rows: 188
#> Columns: 11
#> $ repo_name      <chr> "cohortBuilder", "cohortBuilder", "cohortBuilder", "coh…
#> $ id             <chr> "C_kwDOHYNOFdoAKGU3Mjg5MTViZGM4YzYzMTIwOWEwMzEwMDIwOTA0…
#> $ committed_date <dttm> 2024-06-05 11:02:21, 2024-06-05 10:55:59, 2024-06-05 1…
#> $ author         <chr> "Kamil Koziej", "Kamil Koziej", "Kamil Koziej", "Krysti…
#> $ author_login   <chr> NA, NA, NA, "krystian8207", "krystian8207", "krystian82…
#> $ author_name    <chr> "Kamil Koziej", "Kamil Koziej", "Kamil Koziej", "Krysti…
#> $ additions      <int> 559, 0, 219, 1, 2, 108, 38, 83, 14, 1596, 973, 1292, 3,…
#> $ deletions      <int> 304, 19, 87, 1, 1, 1, 0, 29, 0, 340, 163, 799, 6, 54, 1…
#> $ organization   <chr> "r-world-devs", "r-world-devs", "r-world-devs", "r-worl…
#> $ repo_url       <chr> "https://github.com/r-world-devs/cohortBuilder", "https…
#> $ api_url        <glue> "https://api.github.com/graphql", "https://api.github.…
```

Unless, you switch off the cache:

``` r
commits <- get_commits(
  gitstats = git_stats,
  since = "2024-06-01",
  until = "2024-06-30",
  cache = FALSE,
  progress = FALSE
)
#> → Pulling commits...
#> ✔ Data pulled in 23.6 secs
dplyr::glimpse(commits)
#> Rows: 188
#> Columns: 11
#> $ repo_name      <chr> "cohortBuilder", "cohortBuilder", "cohortBuilder", "coh…
#> $ id             <chr> "C_kwDOHYNOFdoAKGU3Mjg5MTViZGM4YzYzMTIwOWEwMzEwMDIwOTA0…
#> $ committed_date <dttm> 2024-06-05 11:02:21, 2024-06-05 10:55:59, 2024-06-05 1…
#> $ author         <chr> "Kamil Koziej", "Kamil Koziej", "Kamil Koziej", "Krysti…
#> $ author_login   <chr> NA, NA, NA, "krystian8207", "krystian8207", "krystian82…
#> $ author_name    <chr> "Kamil Koziej", "Kamil Koziej", "Kamil Koziej", "Krysti…
#> $ additions      <int> 559, 0, 219, 1, 2, 108, 38, 83, 14, 1596, 973, 1292, 3,…
#> $ deletions      <int> 304, 19, 87, 1, 1, 1, 0, 29, 0, 340, 163, 799, 6, 54, 1…
#> $ organization   <chr> "r-world-devs", "r-world-devs", "r-world-devs", "r-worl…
#> $ repo_url       <chr> "https://github.com/r-world-devs/cohortBuilder", "https…
#> $ api_url        <glue> "https://api.github.com/graphql", "https://api.github.…
```

Or simply change the parameters for the function:

``` r
commits <- get_commits(
  gitstats = git_stats,
  since = "2024-07-01",
  progress = FALSE
)
#> → Pulling commits...
#> ✔ Data pulled in 1.1 mins
dplyr::glimpse(commits)
#> Rows: 4,711
#> Columns: 11
#> $ repo_name      <chr> "cohortBuilder", "cohortBuilder", "cohortBuilder", "coh…
#> $ id             <chr> "C_kwDOHYNOFdoAKGE0MDRiNjRlYzYxZGMxYjFkZTQ1MWFhODg2MzA2…
#> $ committed_date <dttm> 2026-02-24 14:36:07, 2026-02-24 14:15:09, 2026-02-24 1…
#> $ author         <chr> "Krystian Igras", "Krystian Igras", "Krystian Igras", "…
#> $ author_login   <chr> "krystian8207", "krystian8207", "krystian8207", "krysti…
#> $ author_name    <chr> "Krystian Igras", "Krystian Igras", "Krystian Igras", "…
#> $ additions      <int> 1, 98, 2, 1, 25, 324, 324, 8, 310, 0, 2394, 288, 2801, …
#> $ deletions      <int> 1, 18, 2, 3, 0, 9, 9, 5, 9, 299, 807, 286, 771, 227, 2,…
#> $ organization   <chr> "r-world-devs", "r-world-devs", "r-world-devs", "r-worl…
#> $ repo_url       <chr> "https://github.com/r-world-devs/cohortBuilder", "https…
#> $ api_url        <glue> "https://api.github.com/graphql", "https://api.github.…
```

## Storage

Finally, have a glimpse at your storage:

``` r
git_stats
#> A GitStats object for 2 hosts: 
#> Hosts: https://api.github.com, https://gitlab.com/api/v4
#> Scanning scope: 
#>  Organizations: [3] r-world-devs, openpharma, mbtests
#>  Repositories: [0] 
#> Storage: 
#>  Repositories: 99 
#>  Commits: 4711 [date range: 2024-07-01 - 2026-03-06]
#>  Release_logs: 97 [date range: 2024-01-01 - 2026-03-06]
#>  Repos_urls: 99 [type: api]
```

You can retrieve whole data from your `GitStats` object with:

``` r
get_storage(git_stats)
#> $repositories
#> # A tibble: 99 × 19
#>    repo_id      repo_name               repo_fullpath default_branch stars forks
#>    <chr>        <chr>                   <chr>         <chr>          <int> <int>
#>  1 R_kgDOHNMr2w shinyGizmo              r-world-devs… dev               21     0
#>  2 R_kgDOHYNOFQ cohortBuilder           r-world-devs… dev                9     2
#>  3 R_kgDOHYNrJw shinyCohortBuilder      r-world-devs… dev               10     0
#>  4 R_kgDOHYNxtw cohortBuilder.db        r-world-devs… master             0     0
#>  5 R_kgDOIvtxsg GitStats                r-world-devs… master             9     2
#>  6 R_kgDOJAtHJA shinyTimelines          r-world-devs… master             3     0
#>  7 R_kgDOJKQ8Lg ROhdsiWebApi            r-world-devs… main               0     0
#>  8 R_kgDOJWYrCA hypothesis              r-world-devs… master             2     0
#>  9 R_kgDOMHUIwg useR2024-mastering-plu… r-world-devs… main               1     0
#> 10 R_kgDOMMESGQ dbplyr                  r-world-devs… main               0     0
#> # ℹ 89 more rows
#> # ℹ 13 more variables: created_at <dttm>, last_activity_at <dttm>,
#> #   languages <chr>, issues_open <int>, issues_closed <int>,
#> #   organization <chr>, repo_url <chr>, commit_sha <chr>, api_url <chr>,
#> #   githost <chr>, last_activity <drtn>, contributors <chr>,
#> #   contributors_n <int>
#> 
#> $commits
#> # A tibble: 4,711 × 11
#>    repo_name id    committed_date      author author_login author_name additions
#>    <chr>     <chr> <dttm>              <chr>  <chr>        <chr>           <int>
#>  1 cohortBu… C_kw… 2026-02-24 14:36:07 Kryst… krystian8207 Krystian I…         1
#>  2 cohortBu… C_kw… 2026-02-24 14:15:09 Kryst… krystian8207 Krystian I…        98
#>  3 cohortBu… C_kw… 2026-02-24 13:20:36 Kryst… krystian8207 Krystian I…         2
#>  4 cohortBu… C_kw… 2026-02-24 13:03:22 Kryst… krystian8207 Krystian I…         1
#>  5 cohortBu… C_kw… 2026-02-24 13:00:32 Kryst… krystian8207 Krystian I…        25
#>  6 cohortBu… C_kw… 2026-02-24 12:41:07 Kryst… krystian8207 Krystian I…       324
#>  7 cohortBu… C_kw… 2026-02-24 12:40:39 Kryst… krystian8207 Krystian I…       324
#>  8 cohortBu… C_kw… 2026-02-24 12:00:19 Kryst… krystian8207 Krystian I…         8
#>  9 cohortBu… C_kw… 2026-02-24 11:55:14 Kryst… krystian8207 Krystian I…       310
#> 10 cohortBu… C_kw… 2026-02-24 11:45:13 Kryst… krystian8207 Krystian I…         0
#> # ℹ 4,701 more rows
#> # ℹ 4 more variables: deletions <int>, organization <chr>, repo_url <chr>,
#> #   api_url <glue>
#> 
#> $users
#> NULL
#> 
#> $files
#> NULL
#> 
#> $repos_trees
#> NULL
#> 
#> $release_logs
#> # A tibble: 97 × 7
#>    repo_name   repo_url release_name release_tag published_at        release_url
#>    <chr>       <chr>    <chr>        <chr>       <dttm>              <chr>      
#>  1 cohortBuil… https:/… cohortBuild… v0.4.0      2026-02-26 15:06:49 https://gi…
#>  2 cohortBuil… https:/… cohortBuild… v0.3.0      2024-09-27 11:35:06 https://gi…
#>  3 shinyCohor… https:/… shinyCohort… v0.4.0      2026-02-26 15:05:48 https://gi…
#>  4 shinyCohor… https:/… v0.3.1       v0.3.1      2024-10-24 08:21:19 https://gi…
#>  5 shinyCohor… https:/… v0.3.0       v0.3.0      2024-10-24 08:20:32 https://gi…
#>  6 GitStats    https:/… GitStats 2.… v2.3.9      2026-01-12 07:52:20 https://gi…
#>  7 GitStats    https:/… GitStats 2.… v2.3.8      2025-12-08 07:58:49 https://gi…
#>  8 GitStats    https:/… GitStats 2.… v2.3.7      2025-10-16 07:24:36 https://gi…
#>  9 GitStats    https:/… GitStats 2.… v2.3.6      2025-09-17 07:46:45 https://gi…
#> 10 GitStats    https:/… GitStats 2.… v2.3.5      2025-08-19 05:40:37 https://gi…
#> # ℹ 87 more rows
#> # ℹ 1 more variable: release_log <chr>
#> 
#> $repos_urls
#> # Repository URLs (showing first 5 of 99):
#> - https://api.github.com/repos/r-world-devs/shinyGizmo
#> - https://api.github.com/repos/r-world-devs/cohortBuilder
#> - https://api.github.com/repos/r-world-devs/shinyCohortBuilder
#> - https://api.github.com/repos/r-world-devs/cohortBuilder.db
#> - https://api.github.com/repos/r-world-devs/GitStats
#> 
#> # Host Summary:
#> - api.github.com: 88 URL(s)
#> - gitlab.com: 11 URL(s)
#> 
```

Or particular data set:

``` r
get_storage(
  gitstats = git_stats,
  storage = "repositories"
)
#> # A tibble: 99 × 19
#>    repo_id      repo_name               repo_fullpath default_branch stars forks
#>    <chr>        <chr>                   <chr>         <chr>          <int> <int>
#>  1 R_kgDOHNMr2w shinyGizmo              r-world-devs… dev               21     0
#>  2 R_kgDOHYNOFQ cohortBuilder           r-world-devs… dev                9     2
#>  3 R_kgDOHYNrJw shinyCohortBuilder      r-world-devs… dev               10     0
#>  4 R_kgDOHYNxtw cohortBuilder.db        r-world-devs… master             0     0
#>  5 R_kgDOIvtxsg GitStats                r-world-devs… master             9     2
#>  6 R_kgDOJAtHJA shinyTimelines          r-world-devs… master             3     0
#>  7 R_kgDOJKQ8Lg ROhdsiWebApi            r-world-devs… main               0     0
#>  8 R_kgDOJWYrCA hypothesis              r-world-devs… master             2     0
#>  9 R_kgDOMHUIwg useR2024-mastering-plu… r-world-devs… main               1     0
#> 10 R_kgDOMMESGQ dbplyr                  r-world-devs… main               0     0
#> # ℹ 89 more rows
#> # ℹ 13 more variables: created_at <dttm>, last_activity_at <dttm>,
#> #   languages <chr>, issues_open <int>, issues_closed <int>,
#> #   organization <chr>, repo_url <chr>, commit_sha <chr>, api_url <chr>,
#> #   githost <chr>, last_activity <drtn>, contributors <chr>,
#> #   contributors_n <int>
```

## Commits statistics

Pull statistics in one pipe:

``` r
commits_stats <- get_commits(
  gitstats = git_stats,
  since = "2024-06-01",
  until = "2024-06-30",
  verbose = FALSE
) |>
  get_commits_stats(
    time_aggregation = "year",
    group_var = author_name
  )
#> → Pulling commits...
#> GitHub ■■■■■■■■■■■■■■■■                  50% |  ETA:  4s
#> ✔ Data pulled in 24.1 secs
dplyr::glimpse(commits_stats)
#> Rows: 20
#> Columns: 4
#> $ stats_date  <dttm> 2024-01-01, 2024-01-01, 2024-01-01, 2024-01-01, 2024-01-0…
#> $ githost     <chr> "github", "github", "github", "github", "github", "github"…
#> $ author_name <chr> "Aaron Clark", "Björn Bornkamp", "Chao Cheng", "Daniel Sab…
#> $ stats       <int> 16, 1, 1, 9, 12, 1, 3, 1, 1, 1, 16, 6, 13, 43, 11, 3, 1, 2…
```
