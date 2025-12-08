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
#> ✔ Data pulled in 36 secs
dplyr::glimpse(repos)
#> Rows: 95
#> Columns: 19
#> $ repo_id          <chr> "R_kgDOHNMr2w", "R_kgDOHYNOFQ", "R_kgDOHYNrJw", "R_kg…
#> $ repo_name        <chr> "shinyGizmo", "cohortBuilder", "shinyCohortBuilder", …
#> $ repo_fullpath    <chr> "r-world-devs/shinyGizmo", "r-world-devs/cohortBuilde…
#> $ default_branch   <chr> "dev", "dev", "dev", "master", "master", "master", "m…
#> $ stars            <int> 21, 9, 10, 0, 8, 3, 0, 2, 1, 0, 0, 0, 1, 1, 3, 8, 1, …
#> $ forks            <int> 0, 2, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 2, 0, 6,…
#> $ created_at       <dttm> 2022-04-20 10:04:32, 2022-05-22 18:31:55, 2022-05-22…
#> $ last_activity_at <dttm> 2024-07-12, 2025-08-27, 2025-10-13, 2024-06-13, 2025…
#> $ languages        <chr> "R, CSS, JavaScript", "R", "R, CSS, JavaScript, SCSS"…
#> $ issues_open      <int> 6, 39, 39, 3, 102, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 11, …
#> $ issues_closed    <int> 12, 5, 14, 0, 355, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 60, …
#> $ organization     <chr> "r-world-devs", "r-world-devs", "r-world-devs", "r-wo…
#> $ repo_url         <chr> "https://github.com/r-world-devs/shinyGizmo", "https:…
#> $ commit_sha       <chr> "735ec6ea367e6f9856eb0fe650d3c51c3a1aefb5", "adc27861…
#> $ api_url          <chr> "https://api.github.com/repos/r-world-devs/shinyGizmo…
#> $ githost          <chr> "github", "github", "github", "github", "github", "gi…
#> $ last_activity    <drtn> 514.34 days, 103.34 days, 56.34 days, 543.34 days, 0…
#> $ contributors     <chr> "krystian8207, stla, galachad, stlagsk", "krystian820…
#> $ contributors_n   <int> 4, 3, 4, 1, 4, 1, 6, 2, 1, 141, 2, 3, 1, 1, 1, 6, 44,…
```

You can always go for the lighter version of `get_repos`,
i.e. [`get_repos_urls()`](https://r-world-devs.github.io/GitStats/reference/get_repos_urls.md)
which will print you a vector of URLs instead of whole table.

``` r
repos_urls <- get_repos_urls(git_stats)
#> → Pulling repositories URLs...
#> ✔ Data pulled in 3.7 secs
dplyr::glimpse(repos_urls)
#>  'gitstats_repos_urls' chr [1:95] "https://api.github.com/repos/r-world-devs/shinyGizmo" ...
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
#> ✔ Data pulled in 33.4 secs
dplyr::glimpse(release_logs)
#> Rows: 72
#> Columns: 7
#> $ repo_name    <chr> "cohortBuilder", "shinyCohortBuilder", "shinyCohortBuilde…
#> $ repo_url     <chr> "https://github.com/r-world-devs/cohortBuilder", "https:/…
#> $ release_name <chr> "cohortBuilder 0.3.0", "v0.3.1", "v0.3.0", "GitStats 2.3.…
#> $ release_tag  <chr> "v0.3.0", "v0.3.1", "v0.3.0", "v2.3.8", "v2.3.7", "v2.3.6…
#> $ published_at <dttm> 2024-09-27 11:35:06, 2024-10-24 08:21:19, 2024-10-24 08:…
#> $ release_url  <chr> "https://github.com/r-world-devs/cohortBuilder/releases/t…
#> $ release_log  <chr> "* Add new filter of type `\"query\"` that allows to conf…
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
#> ✔ Data pulled in 25.6 secs
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
#> ✔ Data pulled in 23.3 secs
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
#> ✔ Data pulled in 1.6 mins
dplyr::glimpse(commits)
#> Rows: 3,985
#> Columns: 11
#> $ repo_name      <chr> "cohortBuilder", "cohortBuilder", "cohortBuilder", "coh…
#> $ id             <chr> "C_kwDOHYNOFdoAKGFkYzI3ODYxNTQxY2M5MmMyYWJlMTNkZTAzNDNj…
#> $ committed_date <dttm> 2025-05-02 10:45:58, 2025-03-18 11:08:51, 2025-03-12 1…
#> $ author         <chr> "Dawid Borysiak", "Adam Foryś", "Adam Foryś", "Adam For…
#> $ author_login   <chr> "syroBx", "galachad", "galachad", "galachad", "syroBx",…
#> $ author_name    <chr> "Dawid Borysiak", "Adam Foryś", "Adam Foryś", "Adam For…
#> $ additions      <int> 443, 2, 24, 31, 404, 65, 35, 99, 99, 259, 207, 0, 83, 5…
#> $ deletions      <int> 0, 1, 10, 1, 405, 0, 32, 0, 0, 1, 0, 3, 1, 1, 2, 1, 1, …
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
#>  Repositories: 95 
#>  Commits: 3985 [date range: 2024-07-01 - 2025-12-09]
#>  Release_logs: 72 [date range: 2024-01-01 - 2025-12-09]
#>  Repos_urls: 95 [type: api]
```

You can retrieve whole data from your `GitStats` object with:

``` r
get_storage(git_stats)
#> $repositories
#> # A tibble: 95 × 19
#>    repo_id      repo_name               repo_fullpath default_branch stars forks
#>    <chr>        <chr>                   <chr>         <chr>          <int> <int>
#>  1 R_kgDOHNMr2w shinyGizmo              r-world-devs… dev               21     0
#>  2 R_kgDOHYNOFQ cohortBuilder           r-world-devs… dev                9     2
#>  3 R_kgDOHYNrJw shinyCohortBuilder      r-world-devs… dev               10     0
#>  4 R_kgDOHYNxtw cohortBuilder.db        r-world-devs… master             0     0
#>  5 R_kgDOIvtxsg GitStats                r-world-devs… master             8     2
#>  6 R_kgDOJAtHJA shinyTimelines          r-world-devs… master             3     0
#>  7 R_kgDOJKQ8Lg ROhdsiWebApi            r-world-devs… main               0     0
#>  8 R_kgDOJWYrCA hypothesis              r-world-devs… master             2     0
#>  9 R_kgDOMHUIwg useR2024-mastering-plu… r-world-devs… main               1     0
#> 10 R_kgDOMMESGQ dbplyr                  r-world-devs… main               0     0
#> # ℹ 85 more rows
#> # ℹ 13 more variables: created_at <dttm>, last_activity_at <dttm>,
#> #   languages <chr>, issues_open <int>, issues_closed <int>,
#> #   organization <chr>, repo_url <chr>, commit_sha <chr>, api_url <chr>,
#> #   githost <chr>, last_activity <drtn>, contributors <chr>,
#> #   contributors_n <int>
#> 
#> $commits
#> # A tibble: 3,985 × 11
#>    repo_name id    committed_date      author author_login author_name additions
#>    <chr>     <chr> <dttm>              <chr>  <chr>        <chr>           <int>
#>  1 cohortBu… C_kw… 2025-05-02 10:45:58 Dawid… syroBx       Dawid Bory…       443
#>  2 cohortBu… C_kw… 2025-03-18 11:08:51 Adam … galachad     Adam Foryś          2
#>  3 cohortBu… C_kw… 2025-03-12 12:17:22 Adam … galachad     Adam Foryś         24
#>  4 cohortBu… C_kw… 2025-02-19 16:30:51 Adam … galachad     Adam Foryś         31
#>  5 cohortBu… C_kw… 2025-02-19 12:37:13 Dawid… syroBx       Dawid Bory…       404
#>  6 cohortBu… C_kw… 2025-02-18 16:20:50 Dawid… syroBx       Dawid Bory…        65
#>  7 cohortBu… C_kw… 2025-02-10 11:52:23 Adam … galachad     Adam Foryś         35
#>  8 cohortBu… C_kw… 2025-02-06 08:44:21 Adam … galachad     Adam Foryś         99
#>  9 cohortBu… C_kw… 2025-02-04 15:05:46 Borys  syroBx       Dawid Bory…        99
#> 10 cohortBu… C_kw… 2025-02-04 14:03:43 Borys  syroBx       Dawid Bory…       259
#> # ℹ 3,975 more rows
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
#> # A tibble: 72 × 7
#>    repo_name   repo_url release_name release_tag published_at        release_url
#>    <chr>       <chr>    <chr>        <chr>       <dttm>              <chr>      
#>  1 cohortBuil… https:/… cohortBuild… v0.3.0      2024-09-27 11:35:06 https://gi…
#>  2 shinyCohor… https:/… v0.3.1       v0.3.1      2024-10-24 08:21:19 https://gi…
#>  3 shinyCohor… https:/… v0.3.0       v0.3.0      2024-10-24 08:20:32 https://gi…
#>  4 GitStats    https:/… GitStats 2.… v2.3.8      2025-12-08 07:58:49 https://gi…
#>  5 GitStats    https:/… GitStats 2.… v2.3.7      2025-10-16 07:24:36 https://gi…
#>  6 GitStats    https:/… GitStats 2.… v2.3.6      2025-09-17 07:46:45 https://gi…
#>  7 GitStats    https:/… GitStats 2.… v2.3.5      2025-08-19 05:40:37 https://gi…
#>  8 GitStats    https:/… GitStats 2.… v2.3.4      2025-07-08 13:33:50 https://gi…
#>  9 GitStats    https:/… GitStats 2.… v2.3.3      2025-06-03 08:06:26 https://gi…
#> 10 GitStats    https:/… GitStats 2.… v2.3.2      2025-05-20 09:21:19 https://gi…
#> # ℹ 62 more rows
#> # ℹ 1 more variable: release_log <chr>
#> 
#> $repos_urls
#>  [1] "https://api.github.com/repos/r-world-devs/shinyGizmo"                          
#>  [2] "https://api.github.com/repos/r-world-devs/cohortBuilder"                       
#>  [3] "https://api.github.com/repos/r-world-devs/shinyCohortBuilder"                  
#>  [4] "https://api.github.com/repos/r-world-devs/cohortBuilder.db"                    
#>  [5] "https://api.github.com/repos/r-world-devs/GitStats"                            
#>  [6] "https://api.github.com/repos/r-world-devs/shinyTimelines"                      
#>  [7] "https://api.github.com/repos/r-world-devs/ROhdsiWebApi"                        
#>  [8] "https://api.github.com/repos/r-world-devs/hypothesis"                          
#>  [9] "https://api.github.com/repos/r-world-devs/useR2024-mastering-plumber-api"      
#> [10] "https://api.github.com/repos/r-world-devs/dbplyr"                              
#> [11] "https://api.github.com/repos/r-world-devs/IncidencePrevalence"                 
#> [12] "https://api.github.com/repos/r-world-devs/MegaStudy"                           
#> [13] "https://api.github.com/repos/r-world-devs/useR2024-cohortBuilder-minidemo"     
#> [14] "https://api.github.com/repos/r-world-devs/queryBuilder"                        
#> [15] "https://api.github.com/repos/r-world-devs/shinyQueryBuilder"                   
#> [16] "https://api.github.com/repos/r-world-devs/GitAI"                               
#> [17] "https://api.github.com/repos/r-world-devs/ellmer"                              
#> [18] "https://api.github.com/repos/openpharma/openpharma.github.io"                  
#> [19] "https://api.github.com/repos/openpharma/crmPack"                               
#> [20] "https://api.github.com/repos/openpharma/visR"                                  
#> [21] "https://api.github.com/repos/openpharma/pypharma_nlp"                          
#> [22] "https://api.github.com/repos/openpharma/RDO"                                   
#> [23] "https://api.github.com/repos/openpharma/syntrial"                              
#> [24] "https://api.github.com/repos/openpharma/simaerep"                              
#> [25] "https://api.github.com/repos/openpharma/CTP"                                   
#> [26] "https://api.github.com/repos/openpharma/sas7bdat"                              
#> [27] "https://api.github.com/repos/openpharma/visR-docs"                             
#> [28] "https://api.github.com/repos/openpharma/facetsr"                               
#> [29] "https://api.github.com/repos/openpharma/GithubMetrics"                         
#> [30] "https://api.github.com/repos/openpharma/BBS-causality-training"                
#> [31] "https://api.github.com/repos/openpharma/synthetic.data.submission.shiny"       
#> [32] "https://api.github.com/repos/openpharma/synthetic.data.archive"                
#> [33] "https://api.github.com/repos/openpharma/tester"                                
#> [34] "https://api.github.com/repos/openpharma/staged.dependencies"                   
#> [35] "https://api.github.com/repos/openpharma/openpharma_log"                        
#> [36] "https://api.github.com/repos/openpharma/quality_risk_assesment_clinical_trials"
#> [37] "https://api.github.com/repos/openpharma/stageddeps.house"                      
#> [38] "https://api.github.com/repos/openpharma/stageddeps.garden"                     
#> [39] "https://api.github.com/repos/openpharma/stageddeps.food"                       
#> [40] "https://api.github.com/repos/openpharma/stageddeps.electricity"                
#> [41] "https://api.github.com/repos/openpharma/stageddeps.elecinfra"                  
#> [42] "https://api.github.com/repos/openpharma/stageddeps.water"                      
#> [43] "https://api.github.com/repos/openpharma/DataFakeR"                             
#> [44] "https://api.github.com/repos/openpharma/rinpharma_workshop_2021_old"           
#> [45] "https://api.github.com/repos/openpharma/rinpharma_workshop_2021"               
#> [46] "https://api.github.com/repos/openpharma/elaborator"                            
#> [47] "https://api.github.com/repos/openpharma/graphicalMCP"                          
#> [48] "https://api.github.com/repos/openpharma/mmrm"                                  
#> [49] "https://api.github.com/repos/openpharma/opensource_dashboard"                  
#> [50] "https://api.github.com/repos/openpharma/phuse-scripts"                         
#> [51] "https://api.github.com/repos/openpharma/trialreport"                           
#> [52] "https://api.github.com/repos/openpharma/openpharma_ml"                         
#> [53] "https://api.github.com/repos/openpharma/mtdesign"                              
#> [54] "https://api.github.com/repos/openpharma/rbqmR"                                 
#> [55] "https://api.github.com/repos/openpharma/.github"                               
#> [56] "https://api.github.com/repos/openpharma/hta-collaborations"                    
#> [57] "https://api.github.com/repos/openpharma/savvyr"                                
#> [58] "https://api.github.com/repos/openpharma/roxytypes"                             
#> [59] "https://api.github.com/repos/openpharma/roxylint"                              
#> [60] "https://api.github.com/repos/openpharma/autoquarto"                            
#> [61] "https://api.github.com/repos/openpharma/workshop-r-swe"                        
#> [62] "https://api.github.com/repos/openpharma/brms.mmrm"                             
#> [63] "https://api.github.com/repos/openpharma/workshop-r-swe-sf"                     
#> [64] "https://api.github.com/repos/openpharma/RobinCar2"                             
#> [65] "https://api.github.com/repos/openpharma/filters"                               
#> [66] "https://api.github.com/repos/openpharma/workshop-r-swe-md"                     
#> [67] "https://api.github.com/repos/openpharma/workshop-r-swe-mtl"                    
#> [68] "https://api.github.com/repos/openpharma/CAMIS"                                 
#> [69] "https://api.github.com/repos/openpharma/clindata"                              
#> [70] "https://api.github.com/repos/openpharma/SafetySignalDetection.jl"              
#> [71] "https://api.github.com/repos/openpharma/os-metadata"                           
#> [72] "https://api.github.com/repos/openpharma/diffdf"                                
#> [73] "https://api.github.com/repos/openpharma/clinsight"                             
#> [74] "https://api.github.com/repos/openpharma/beeca"                                 
#> [75] "https://api.github.com/repos/openpharma/beeca-simulations"                     
#> [76] "https://api.github.com/repos/openpharma/DoseFinding"                           
#> [77] "https://api.github.com/repos/openpharma/generate_badges"                       
#> [78] "https://api.github.com/repos/openpharma/workshop-r-swe-rinpharma-2024"         
#> [79] "https://api.github.com/repos/openpharma/rbmiUtils"                             
#> [80] "https://api.github.com/repos/openpharma/bfboin"                                
#> [81] "https://api.github.com/repos/openpharma/bunsen"                                
#> [82] "https://api.github.com/repos/openpharma/BayesInDrugDevelopment"                
#> [83] "https://api.github.com/repos/openpharma/graphical-multiple-comparisons"        
#> [84] "https://api.github.com/repos/openpharma/bonsaiforest2"                         
#> [85] "https://gitlab.com/api/v4/projects/73876499"                                   
#> [86] "https://gitlab.com/api/v4/projects/61399846"                                   
#> [87] "https://gitlab.com/api/v4/projects/47383376"                                   
#> [88] "https://gitlab.com/api/v4/projects/45334037"                                   
#> [89] "https://gitlab.com/api/v4/projects/45300912"                                   
#> [90] "https://gitlab.com/api/v4/projects/44565479"                                   
#> [91] "https://gitlab.com/api/v4/projects/44346961"                                   
#> [92] "https://gitlab.com/api/v4/projects/44293594"                                   
#> [93] "https://gitlab.com/api/v4/projects/43875717"                                   
#> [94] "https://gitlab.com/api/v4/projects/43400864"                                   
#> [95] "https://gitlab.com/api/v4/projects/43398933"                                   
#> attr(,"class")
#> [1] "gitstats_repos_urls" "character"          
#> attr(,"type")
#> [1] "api"
```

Or particular data set:

``` r
get_storage(
  gitstats = git_stats,
  storage = "repositories"
)
#> # A tibble: 95 × 19
#>    repo_id      repo_name               repo_fullpath default_branch stars forks
#>    <chr>        <chr>                   <chr>         <chr>          <int> <int>
#>  1 R_kgDOHNMr2w shinyGizmo              r-world-devs… dev               21     0
#>  2 R_kgDOHYNOFQ cohortBuilder           r-world-devs… dev                9     2
#>  3 R_kgDOHYNrJw shinyCohortBuilder      r-world-devs… dev               10     0
#>  4 R_kgDOHYNxtw cohortBuilder.db        r-world-devs… master             0     0
#>  5 R_kgDOIvtxsg GitStats                r-world-devs… master             8     2
#>  6 R_kgDOJAtHJA shinyTimelines          r-world-devs… master             3     0
#>  7 R_kgDOJKQ8Lg ROhdsiWebApi            r-world-devs… main               0     0
#>  8 R_kgDOJWYrCA hypothesis              r-world-devs… master             2     0
#>  9 R_kgDOMHUIwg useR2024-mastering-plu… r-world-devs… main               1     0
#> 10 R_kgDOMMESGQ dbplyr                  r-world-devs… main               0     0
#> # ℹ 85 more rows
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
#> ✔ Data pulled in 26 secs
dplyr::glimpse(commits_stats)
#> Rows: 20
#> Columns: 4
#> $ stats_date  <dttm> 2024-01-01, 2024-01-01, 2024-01-01, 2024-01-01, 2024-01-0…
#> $ githost     <chr> "github", "github", "github", "github", "github", "github"…
#> $ author_name <chr> "Aaron Clark", "Björn Bornkamp", "Chao Cheng", "Daniel Sab…
#> $ stats       <int> 16, 1, 1, 9, 12, 1, 3, 1, 1, 1, 16, 6, 13, 43, 11, 3, 1, 2…
```
