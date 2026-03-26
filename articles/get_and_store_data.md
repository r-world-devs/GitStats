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
    orgs = c("r-world-devs"),
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

set_parallel(10)
#> ✔ Parallel processing enabled with 10 workers.
```

As scanning scope was set to `organizations` (`orgs` parameter in
`set_*_host()`), `GitStats` will pull all repositories from these
organizations.

``` r
repos <- get_repos(git_stats, progress = FALSE, add_contributors = FALSE)
#> → Pulling repositories 🌐 data...
#> ✔ Data pulled in 3.9 secs
dplyr::glimpse(repos)
#> Rows: 28
#> Columns: 17
#> $ repo_id          <chr> "R_kgDOHNMr2w", "R_kgDOHYNOFQ", "R_kgDOHYNrJw", "R_kg…
#> $ repo_name        <chr> "shinyGizmo", "cohortBuilder", "shinyCohortBuilder", …
#> $ repo_fullpath    <chr> "r-world-devs/shinyGizmo", "r-world-devs/cohortBuilde…
#> $ default_branch   <chr> "dev", "dev", "dev", "master", "master", "master", "m…
#> $ stars            <int> 21, 9, 10, 0, 9, 3, 0, 2, 1, 0, 0, 0, 1, 1, 3, 8, 1, …
#> $ forks            <int> 0, 2, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 2, 0, 0,…
#> $ created_at       <dttm> 2022-04-20 10:04:32, 2022-05-22 18:31:55, 2022-05-22…
#> $ last_activity_at <dttm> 2024-07-12, 2026-02-26, 2026-02-26, 2024-06-13, 2026…
#> $ languages        <chr> "R, CSS, JavaScript", "R", "R, CSS, JavaScript, SCSS"…
#> $ issues_open      <int> 6, 34, 36, 3, 68, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 12, 0…
#> $ issues_closed    <int> 12, 11, 17, 0, 402, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 60,…
#> $ organization     <chr> "r-world-devs", "r-world-devs", "r-world-devs", "r-wo…
#> $ repo_url         <chr> "https://github.com/r-world-devs/shinyGizmo", "https:…
#> $ commit_sha       <chr> "735ec6ea367e6f9856eb0fe650d3c51c3a1aefb5", "a404b64e…
#> $ api_url          <chr> "https://api.github.com/repos/r-world-devs/shinyGizmo…
#> $ githost          <chr> "github", "github", "github", "github", "github", "gi…
#> $ last_activity    <drtn> 622.36 days, 28.36 days, 28.36 days, 651.36 days, 0.…
```

You can always go for the lighter version of `get_repos`,
i.e. [`get_repos_urls()`](https://r-world-devs.github.io/GitStats/reference/get_repos_urls.md)
which will print you a vector of URLs instead of whole table.

``` r
repos_urls <- get_repos_urls(git_stats)
#> → Pulling repositories 🌐 URLs...
#> ✔ Data pulled in 1.5 secs
dplyr::glimpse(repos_urls)
#>  'gitstats_repos_urls' chr [1:28] "https://api.github.com/repos/r-world-devs/shinyGizmo" ...
#>  - attr(*, "type")= chr "api"
```

## Local Storage

After pulling, the data is saved to `GitStats`.

``` r
commits <- get_commits(
  gitstats = git_stats,
  since = "2024-06-01",
  until = "2024-06-14",
  progress = FALSE
)
#> → Pulling commits 🕒...
#> ✔ Data pulled in 9.6 secs
dplyr::glimpse(commits)
#> Rows: 17
#> Columns: 11
#> $ repo_name      <chr> "cohortBuilder", "cohortBuilder", "cohortBuilder", "coh…
#> $ id             <chr> "C_kwDOHYNOFdoAKGU3Mjg5MTViZGM4YzYzMTIwOWEwMzEwMDIwOTA0…
#> $ committed_date <dttm> 2024-06-05 11:02:21, 2024-06-05 10:55:59, 2024-06-05 1…
#> $ author         <chr> "Kamil Koziej", "Kamil Koziej", "Kamil Koziej", "Krysti…
#> $ author_login   <chr> NA, NA, NA, "krystian8207", "krystian8207", "krystian82…
#> $ author_name    <chr> "Kamil Koziej", "Kamil Koziej", "Kamil Koziej", "Krysti…
#> $ additions      <int> 559, 0, 219, 1, 2, 108, 38, 83, 14, 1596, 973, 1292, 3,…
#> $ deletions      <int> 304, 19, 87, 1, 1, 1, 0, 29, 0, 340, 163, 799, 6, 0, 11…
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
  until = "2024-06-14"
)
#> ! Getting cached commits data.
#> ℹ If you wish to pull the data from API once more, set `cache` parameter to `FALSE`.
#> ✔ Data pulled in 0 secs
dplyr::glimpse(commits)
#> Rows: 17
#> Columns: 11
#> $ repo_name      <chr> "cohortBuilder", "cohortBuilder", "cohortBuilder", "coh…
#> $ id             <chr> "C_kwDOHYNOFdoAKGU3Mjg5MTViZGM4YzYzMTIwOWEwMzEwMDIwOTA0…
#> $ committed_date <dttm> 2024-06-05 11:02:21, 2024-06-05 10:55:59, 2024-06-05 1…
#> $ author         <chr> "Kamil Koziej", "Kamil Koziej", "Kamil Koziej", "Krysti…
#> $ author_login   <chr> NA, NA, NA, "krystian8207", "krystian8207", "krystian82…
#> $ author_name    <chr> "Kamil Koziej", "Kamil Koziej", "Kamil Koziej", "Krysti…
#> $ additions      <int> 559, 0, 219, 1, 2, 108, 38, 83, 14, 1596, 973, 1292, 3,…
#> $ deletions      <int> 304, 19, 87, 1, 1, 1, 0, 29, 0, 340, 163, 799, 6, 0, 11…
#> $ organization   <chr> "r-world-devs", "r-world-devs", "r-world-devs", "r-worl…
#> $ repo_url       <chr> "https://github.com/r-world-devs/cohortBuilder", "https…
#> $ api_url        <glue> "https://api.github.com/graphql", "https://api.github.…
```

Unless, you switch off the cache:

``` r
commits <- get_commits(
  gitstats = git_stats,
  since = "2024-06-01",
  until = "2024-06-14",
  cache = FALSE,
  progress = FALSE
)
#> → Pulling commits 🕒...
#> ✔ Data pulled in 9.4 secs
dplyr::glimpse(commits)
#> Rows: 17
#> Columns: 11
#> $ repo_name      <chr> "cohortBuilder", "cohortBuilder", "cohortBuilder", "coh…
#> $ id             <chr> "C_kwDOHYNOFdoAKGU3Mjg5MTViZGM4YzYzMTIwOWEwMzEwMDIwOTA0…
#> $ committed_date <dttm> 2024-06-05 11:02:21, 2024-06-05 10:55:59, 2024-06-05 1…
#> $ author         <chr> "Kamil Koziej", "Kamil Koziej", "Kamil Koziej", "Krysti…
#> $ author_login   <chr> NA, NA, NA, "krystian8207", "krystian8207", "krystian82…
#> $ author_name    <chr> "Kamil Koziej", "Kamil Koziej", "Kamil Koziej", "Krysti…
#> $ additions      <int> 559, 0, 219, 1, 2, 108, 38, 83, 14, 1596, 973, 1292, 3,…
#> $ deletions      <int> 304, 19, 87, 1, 1, 1, 0, 29, 0, 340, 163, 799, 6, 0, 11…
#> $ organization   <chr> "r-world-devs", "r-world-devs", "r-world-devs", "r-worl…
#> $ repo_url       <chr> "https://github.com/r-world-devs/cohortBuilder", "https…
#> $ api_url        <glue> "https://api.github.com/graphql", "https://api.github.…
```

Or simply change the parameters for the function:

``` r
commits <- get_commits(
  gitstats = git_stats,
  since = "2024-06-15",
  until = "2024-06-20",
  progress = FALSE
)
#> → Pulling commits 🕒...
#> ✔ Data pulled in 9.2 secs
dplyr::glimpse(commits)
#> Rows: 5
#> Columns: 11
#> $ repo_name      <chr> "dbplyr", "IncidencePrevalence", "IncidencePrevalence",…
#> $ id             <chr> "C_kwDOMMESGdoAKGEwMjk3NGNmNjU3M2I2Y2EyMTMzN2JjODk4ZjEy…
#> $ committed_date <dttm> 2024-06-20 20:43:00, 2024-06-20 20:48:05, 2024-06-17 0…
#> $ author         <chr> "Krystian Igras", "Krystian Igras", "edward-burn", "Kry…
#> $ author_login   <chr> "krystian8207", "krystian8207", "edward-burn", "krystia…
#> $ author_name    <chr> "Krystian Igras", "Krystian Igras", "Ed Burn", "Krystia…
#> $ additions      <int> 9, 7, 74, 3, 786
#> $ deletions      <int> 1, 7, 186, 3, 850
#> $ organization   <chr> "r-world-devs", "r-world-devs", "r-world-devs", "r-worl…
#> $ repo_url       <chr> "https://github.com/r-world-devs/dbplyr", "https://gith…
#> $ api_url        <glue> "https://api.github.com/graphql", "https://api.github.c…
```

## Database Storage

For more permanent storage, you can set up a connection to your database
with
[`set_postgres_storage()`](https://r-world-devs.github.io/GitStats/reference/set_postgres_storage.md)
function. Then, all data pulled with `get_*()` functions will be stored
in the database and retrieved from there when you run the function
again.

``` r
git_stats <- git_stats |>
  set_postgres_storage(
    host = "hostname",
    port = 5432,
    dbname = "dbname",
    user = Sys.getenv("POSTGRES_USERNAME"),
    password = Sys.getenv("POSTGRES_PASSWORD"),
    schema = "git_stats"
  )

# Pulling and saving to database
git_stats |>
  get_commits(
    since = "2024-06-01",
    until = "2024-06-14",
    progress = FALSE
  )
```

Stored data is now not dependent on `GitStats` object but on database
credentials. If you set up same credentials in another `GitStats`
object, you will be able to retrieve data from the database with that
object as well.

``` r
new_git_stats <- git_stats |>
  set_postgres_storage(
    host = "hostname",
    port = 5432,
    dbname = "dbname",
    user = Sys.getenv("POSTGRES_USERNAME"),
    password = Sys.getenv("POSTGRES_PASSWORD"),
    schema = "git_stats"
  )

# Data is cached and retrieved instantly
new_git_stats |>
  get_commits(
    since = "2024-06-01",
    until = "2024-06-14",
    progress = FALSE
  )
```
