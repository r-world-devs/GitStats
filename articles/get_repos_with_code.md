# Getting repositories with specific code or files

Apart from pulling all repositories from organizations, you can look for
those that have a particular text in a `code blob`:

``` r
library(GitStats)

github_stats <- create_gitstats() %>%
  set_github_host(
    orgs = c("r-world-devs", "openpharma"),
    token = Sys.getenv("GITHUB_PAT")
  ) %>%
  verbose_off()

repos_urls <- get_repos_urls(
  gitstats = github_stats,
  with_code = "shiny"
)
```

You can limit your search, as it is allowed with GitLab and GitHub API
search endpoints, to certain files.

``` r
repos_urls <- get_repos_urls(
  gitstats = github_stats,
  with_code =  c("purrr", "shiny"),
  in_files = c("DESCRIPTION", "NAMESPACE", "renv.lock")
)
```

You can also search for repositories with certain files (do not confuse
`with_files` with `in_files`!).

``` r
repos_urls <- get_repos_urls(
  gitstats = github_stats,
  with_files = c("renv.lock", "DESCRIPTION")
)
```
