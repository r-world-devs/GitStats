# Package index

## Create, set and show

- [`create_gitstats()`](https://r-world-devs.github.io/GitStats/reference/create_gitstats.md)
  :

  Create a `GitStats` object

- [`set_github_host()`](https://r-world-devs.github.io/GitStats/reference/set_github_host.md)
  : Set GitHub host

- [`set_gitlab_host()`](https://r-world-devs.github.io/GitStats/reference/set_gitlab_host.md)
  : Set GitLab host

- [`is_verbose()`](https://r-world-devs.github.io/GitStats/reference/is_verbose.md)
  : Is verbose mode switched on

- [`verbose_off()`](https://r-world-devs.github.io/GitStats/reference/verbose_off.md)
  : Switch off verbose mode

- [`verbose_on()`](https://r-world-devs.github.io/GitStats/reference/verbose_on.md)
  : Switch on verbose mode

- [`show_orgs()`](https://r-world-devs.github.io/GitStats/reference/show_orgs.md)
  :

  Show organizations set in `GitStats`

- [`show_hosts()`](https://r-world-devs.github.io/GitStats/reference/show_hosts.md)
  :

  Show hosts set in `GitStats`

## Get git data

Functions to get git data in a tibble format.

- [`get_orgs()`](https://r-world-devs.github.io/GitStats/reference/get_orgs.md)
  : Get data on organizations
- [`get_repos()`](https://r-world-devs.github.io/GitStats/reference/get_repos.md)
  : Get data on repositories
- [`get_repos_urls()`](https://r-world-devs.github.io/GitStats/reference/get_repos_urls.md)
  : Get repository URLS
- [`get_repos_trees()`](https://r-world-devs.github.io/GitStats/reference/get_repos_trees.md)
  : Get data on files trees across repositories
- [`get_commits()`](https://r-world-devs.github.io/GitStats/reference/get_commits.md)
  : Get data on commits
- [`get_issues()`](https://r-world-devs.github.io/GitStats/reference/get_issues.md)
  : Get data on issues
- [`get_pull_requests()`](https://r-world-devs.github.io/GitStats/reference/get_pull_requests.md)
  : Get data on pull requests
- [`get_release_logs()`](https://r-world-devs.github.io/GitStats/reference/get_release_logs.md)
  : Get release logs
- [`get_files()`](https://r-world-devs.github.io/GitStats/reference/get_files.md)
  : Get files
- [`get_users()`](https://r-world-devs.github.io/GitStats/reference/get_users.md)
  : Get users data

## Storage

- [`set_local_storage()`](https://r-world-devs.github.io/GitStats/reference/set_local_storage.md)
  : Set local (in-memory) storage

- [`set_postgres_storage()`](https://r-world-devs.github.io/GitStats/reference/set_postgres_storage.md)
  : Set PostgreSQL storage

- [`set_sqlite_storage()`](https://r-world-devs.github.io/GitStats/reference/set_sqlite_storage.md)
  : Set SQLite storage

- [`get_storage()`](https://r-world-devs.github.io/GitStats/reference/get_storage.md)
  :

  Get data from `GitStats` storage

## Parallel processing

- [`set_parallel()`](https://r-world-devs.github.io/GitStats/reference/set_parallel.md)
  : Enable parallel processing

## Get statistics

Functions summarizing git data.

- [`get_commits_stats()`](https://r-world-devs.github.io/GitStats/reference/get_commits_stats.md)
  : Get commits statistics
- [`get_issues_stats()`](https://r-world-devs.github.io/GitStats/reference/get_issues_stats.md)
  : Get issues statistics
- [`get_pull_requests_stats()`](https://r-world-devs.github.io/GitStats/reference/get_pull_requests_stats.md)
  : Get pull requests statistics
