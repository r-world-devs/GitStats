# Store your data

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
    orgs = "r-world-devs",
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
set_parallel(10) # optionally speed up processing
#> ✔ Parallel processing enabled with 10 workers.
```

As scanning scope was set to `organizations` (`orgs` parameter in
`set_*_host()`), `GitStats` will pull all repositories from these
organizations.

``` r
repos <- get_repos(git_stats, progress = FALSE)
#> → Pulling repositories 🌐 data...
#> ✔ Data pulled in 4.7 secs
dplyr::glimpse(repos)
#> Rows: 28
#> Columns: 19
#> $ repo_id          <chr> "R_kgDOHNMr2w", "R_kgDOHYNOFQ", "R_kgDOHYNrJw", "R_kg…
#> $ repo_name        <chr> "shinyGizmo", "cohortBuilder", "shinyCohortBuilder", …
#> $ repo_fullpath    <chr> "r-world-devs/shinyGizmo", "r-world-devs/cohortBuilde…
#> $ default_branch   <chr> "dev", "dev", "dev", "master", "master", "master", "m…
#> $ stars            <int> 21, 9, 10, 0, 9, 3, 0, 2, 1, 0, 0, 0, 1, 1, 3, 8, 1, …
#> $ forks            <int> 0, 2, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 2, 0, 0,…
#> $ created_at       <dttm> 2022-04-20 10:04:32, 2022-05-22 18:31:55, 2022-05-22…
#> $ last_activity_at <dttm> 2024-07-12, 2026-02-26, 2026-02-26, 2024-06-13, 2026…
#> $ languages        <chr> "R, CSS, JavaScript", "R", "R, CSS, JavaScript, SCSS"…
#> $ issues_open      <int> 7, 34, 36, 3, 71, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 12, 0…
#> $ issues_closed    <int> 12, 11, 17, 0, 406, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 60,…
#> $ organization     <chr> "r-world-devs", "r-world-devs", "r-world-devs", "r-wo…
#> $ repo_url         <chr> "https://github.com/r-world-devs/shinyGizmo", "https:…
#> $ commit_sha       <chr> "735ec6ea367e6f9856eb0fe650d3c51c3a1aefb5", "a404b64e…
#> $ api_url          <chr> "https://api.github.com/repos/r-world-devs/shinyGizmo…
#> $ githost          <chr> "github", "github", "github", "github", "github", "gi…
#> $ last_activity    <drtn> 627.34 days, 33.34 days, 33.34 days, 656.34 days, 0.…
#> $ contributors     <chr> "krystian8207, stla, galachad, stlagsk", "krystian820…
#> $ contributors_n   <int> 4, 3, 4, 1, 5, 1, 6, 2, 1, 141, 2, 3, 1, 1, 1, 6, 44,…
```

You can always go for the lighter version of `get_repos`,
i.e. [`get_repos_urls()`](https://r-world-devs.github.io/GitStats/reference/get_repos_urls.md)
which will print you a vector of URLs instead of whole table.

``` r
repos_urls <- get_repos_urls(git_stats)
#> → Pulling repositories 🌐 URLs...
#> ✔ Data pulled in 1.4 secs
dplyr::glimpse(repos_urls)
#>  'gitstats_repos_urls' chr [1:28] "https://api.github.com/repos/r-world-devs/shinyGizmo" ...
#>  - attr(*, "type")= chr "api"
```

## Local Storage

After pulling, the data is saved by default to `GitStats`.

``` r
commits <- git_stats |>
  get_commits(
    since = "2025-06-01",
    until = "2025-06-14",
    progress = FALSE
  )
#> ✔ Data pulled in 8.7 secs
git_stats
#> A GitStats object for 2 hosts: 
#> Hosts: https://api.github.com, https://gitlab.com/api/v4
#> Scanning scope: 
#>  Organizations: [2] r-world-devs, mbtests
#>  Repositories: [0] 
#> Storage [local]:
#>  Repositories: 28 
#>  Repos_urls: 28 [type: api]
#>  Commits: 20 [date range: 2025-06-01 - 2025-06-14]
dplyr::glimpse(commits)
#> Rows: 20
#> Columns: 11
#> $ repo_name      <chr> "cohortBuilder", "GitStats", "GitStats", "GitAI", "ellm…
#> $ id             <chr> "C_kwDOHYNOFdoAKDc0OWM3NjNmZDFlYWU1M2EyMzFhYzk1NmE1ZTk0…
#> $ committed_date <dttm> 2025-06-03 10:37:29, 2025-06-13 07:32:02, 2025-06-03 0…
#> $ author         <chr> "Borys", "Maciej Banas", "Maciej Banaś", "Colin Gillesp…
#> $ author_login   <chr> "syroBx", "maciekbanas", "maciekbanas", "csgillespie", …
#> $ author_name    <chr> "Dawid Borysiak", "Maciej Banaś", "Maciej Banaś", "Coli…
#> $ additions      <int> 30, 3, 71, 1, 267, 1, 0, 41, 109, 2, 84, 11, 95, 7, 0, …
#> $ deletions      <int> 0, 1, 23, 0, 0, 1, 1, 0, 16, 2, 83, 6, 0, 0, 3, 1, 2, 6…
#> $ organization   <chr> "r-world-devs", "r-world-devs", "r-world-devs", "r-worl…
#> $ repo_url       <chr> "https://github.com/r-world-devs/cohortBuilder", "https…
#> $ api_url        <glue> "https://api.github.com/graphql", "https://api.github.…
```

## SQLite Storage

For local saving we recommend though using `SQLite` storage. You can set
it up with
[`set_sqlite_storage()`](https://r-world-devs.github.io/GitStats/reference/set_sqlite_storage.md)
function. Then, all data pulled with `get_*()` functions will be stored
in the `SQLite` database and retrieved from there when you run the
function again.

``` r
commits <- git_stats |>
  set_sqlite_storage("my_local_db") |>
  get_commits(
    since = "2025-06-01",
    until = "2025-06-14",
    progress = FALSE
  )
#> ✔ Storage set to "SQLite".
#> ℹ Database is empty.
#> ✔ Data pulled in 9.9 secs
dplyr::glimpse(commits)
#> Rows: 20
#> Columns: 11
#> $ repo_name      <chr> "cohortBuilder", "GitStats", "GitStats", "GitAI", "ellm…
#> $ id             <chr> "C_kwDOHYNOFdoAKDc0OWM3NjNmZDFlYWU1M2EyMzFhYzk1NmE1ZTk0…
#> $ committed_date <dttm> 2025-06-03 10:37:29, 2025-06-13 07:32:02, 2025-06-03 0…
#> $ author         <chr> "Borys", "Maciej Banas", "Maciej Banaś", "Colin Gillesp…
#> $ author_login   <chr> "syroBx", "maciekbanas", "maciekbanas", "csgillespie", …
#> $ author_name    <chr> "Dawid Borysiak", "Maciej Banaś", "Maciej Banaś", "Coli…
#> $ additions      <int> 30, 3, 71, 1, 267, 1, 0, 41, 109, 2, 84, 11, 95, 7, 0, …
#> $ deletions      <int> 0, 1, 23, 0, 0, 1, 1, 0, 16, 2, 83, 6, 0, 0, 3, 1, 2, 6…
#> $ organization   <chr> "r-world-devs", "r-world-devs", "r-world-devs", "r-worl…
#> $ repo_url       <chr> "https://github.com/r-world-devs/cohortBuilder", "https…
#> $ api_url        <glue> "https://api.github.com/graphql", "https://api.github.…
git_stats
#> A GitStats object for 2 hosts: 
#> Hosts: https://api.github.com, https://gitlab.com/api/v4
#> Scanning scope: 
#>  Organizations: [2] r-world-devs, mbtests
#>  Repositories: [0] 
#> Storage [SQLite]:
#>  Commits: 20 [date range: 2025-06-01 - 2025-06-14]
```

Therefore, it is now not be dependent on the `GitStats` object, but on
the local database, so you can even create a new `GitStats` and connect
it to the same database and data will be there.

``` r
new_git_stats <- create_gitstats() |>
  set_github_host(
    orgs = "r-world-devs",
    token = Sys.getenv("GITHUB_PAT")
  ) |>
  set_gitlab_host(
    orgs = c("mbtests"),
    token = Sys.getenv("GITLAB_PAT_PUBLIC")
  ) |>
  set_sqlite_storage("my_local_db")
#> → Checking owners...
#> ✔ Set connection to GitHub.
#> → Checking owners...
#> ✔ Set connection to GitLab.
#> ✔ Storage set to "SQLite".
#> ℹ Database contains data:
#>   commits: 20 records

commits <- new_git_stats |>
  get_commits(
    since = "2025-06-01",
    until = "2025-06-14",
    verbose = TRUE
  )
#> ! Getting cached commits data.
#> ℹ If you wish to pull the data from API once more, set `cache` parameter to `FALSE`.
#> ✔ Data pulled in 0 secs
dplyr::glimpse(commits)
#> Rows: 20
#> Columns: 11
#> $ repo_name      <chr> "cohortBuilder", "GitStats", "GitStats", "GitAI", "ellm…
#> $ id             <chr> "C_kwDOHYNOFdoAKDc0OWM3NjNmZDFlYWU1M2EyMzFhYzk1NmE1ZTk0…
#> $ committed_date <dttm> 2025-06-03 10:37:29, 2025-06-13 07:32:02, 2025-06-03 0…
#> $ author         <chr> "Borys", "Maciej Banas", "Maciej Banaś", "Colin Gillesp…
#> $ author_login   <chr> "syroBx", "maciekbanas", "maciekbanas", "csgillespie", …
#> $ author_name    <chr> "Dawid Borysiak", "Maciej Banaś", "Maciej Banaś", "Coli…
#> $ additions      <int> 30, 3, 71, 1, 267, 1, 0, 41, 109, 2, 84, 11, 95, 7, 0, …
#> $ deletions      <int> 0, 1, 23, 0, 0, 1, 1, 0, 16, 2, 83, 6, 0, 0, 3, 1, 2, 6…
#> $ organization   <chr> "r-world-devs", "r-world-devs", "r-world-devs", "r-worl…
#> $ repo_url       <chr> "https://github.com/r-world-devs/cohortBuilder", "https…
#> $ api_url        <chr> "https://api.github.com/graphql", "https://api.github.c…
```

Caching feature is by default turned on. You may switch it off:

``` r
commits <- new_git_stats |>
  get_commits(
    since = "2025-06-01",
    until = "2025-06-14",
    verbose = TRUE,
    cache = FALSE,
    progress = FALSE
  )
#> ℹ Cache set to FALSE, I will pull data from API.
#> → Pulling commits 🕒...
#> ✔ Data pulled in 8.5 secs
dplyr::glimpse(commits)
#> Rows: 20
#> Columns: 11
#> $ repo_name      <chr> "cohortBuilder", "GitStats", "GitStats", "GitAI", "ellm…
#> $ id             <chr> "C_kwDOHYNOFdoAKDc0OWM3NjNmZDFlYWU1M2EyMzFhYzk1NmE1ZTk0…
#> $ committed_date <dttm> 2025-06-03 10:37:29, 2025-06-13 07:32:02, 2025-06-03 0…
#> $ author         <chr> "Borys", "Maciej Banas", "Maciej Banaś", "Colin Gillesp…
#> $ author_login   <chr> "syroBx", "maciekbanas", "maciekbanas", "csgillespie", …
#> $ author_name    <chr> "Dawid Borysiak", "Maciej Banaś", "Maciej Banaś", "Coli…
#> $ additions      <int> 30, 3, 71, 1, 267, 1, 0, 41, 109, 2, 84, 11, 95, 7, 0, …
#> $ deletions      <int> 0, 1, 23, 0, 0, 1, 1, 0, 16, 2, 83, 6, 0, 0, 3, 1, 2, 6…
#> $ organization   <chr> "r-world-devs", "r-world-devs", "r-world-devs", "r-worl…
#> $ repo_url       <chr> "https://github.com/r-world-devs/cohortBuilder", "https…
#> $ api_url        <glue> "https://api.github.com/graphql", "https://api.github.…
```

## Incremental pulling

When you pull data with `get_*()` functions, it is stored in the local
database. If you run the same function again, it will check if there is
already data for the same parameters and pull only the missing data.
This way, you can keep your database up to date without pulling all data
again.

``` r
commits <- new_git_stats |>
  get_commits(
    since = "2025-06-01",
    until = "2025-06-30",
    verbose = TRUE,
    progress = FALSE
  )
#> ℹ Parameters changed, I will pull data from API.
#> ℹ Using cached commits 🕒 from "2025-06-01" to "2025-06-14".
#> → Pulling commits 🕒 from API for: "2025-06-15 to 2025-06-30".
#> ✔ Data pulled in 9.6 secs
dplyr::glimpse(commits)
#> Rows: 62
#> Columns: 11
#> $ repo_name      <chr> "cohortBuilder", "GitStats", "GitStats", "GitAI", "ellm…
#> $ id             <chr> "C_kwDOHYNOFdoAKDc0OWM3NjNmZDFlYWU1M2EyMzFhYzk1NmE1ZTk0…
#> $ committed_date <dttm> 2025-06-03 10:37:29, 2025-06-13 07:32:02, 2025-06-03 0…
#> $ author         <chr> "Borys", "Maciej Banas", "Maciej Banaś", "Colin Gillesp…
#> $ author_login   <chr> "syroBx", "maciekbanas", "maciekbanas", "csgillespie", …
#> $ author_name    <chr> "Dawid Borysiak", "Maciej Banaś", "Maciej Banaś", "Coli…
#> $ additions      <int> 30, 3, 71, 1, 267, 1, 0, 41, 109, 2, 84, 11, 95, 7, 0, …
#> $ deletions      <int> 0, 1, 23, 0, 0, 1, 1, 0, 16, 2, 83, 6, 0, 0, 3, 1, 2, 6…
#> $ organization   <chr> "r-world-devs", "r-world-devs", "r-world-devs", "r-worl…
#> $ repo_url       <chr> "https://github.com/r-world-devs/cohortBuilder", "https…
#> $ api_url        <glue> "https://api.github.com/graphql", "https://api.github.…
```

## Postgres Storage

For more permanent storage, you can set up a connection to your database
with
[`set_postgres_storage()`](https://r-world-devs.github.io/GitStats/reference/set_postgres_storage.md)
function. Then, all data pulled with `get_*()` functions will be stored
in the database and retrieved from there when you run the function
again.
