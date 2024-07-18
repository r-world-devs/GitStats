## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 4
)

## -----------------------------------------------------------------------------
library(GitStats)

git_stats <- create_gitstats() %>%
  set_github_host(
    orgs = c("r-world-devs", "openpharma"),
    token = Sys.getenv("GITHUB_PAT")
  ) %>%
  set_gitlab_host(
    orgs = c("mbtests"),
    token = Sys.getenv("GITLAB_PAT_PUBLIC")
  )

## -----------------------------------------------------------------------------
repos <- get_repos(git_stats)
dplyr::glimpse(repos)

## -----------------------------------------------------------------------------
repos <- get_repos(git_stats)

## -----------------------------------------------------------------------------
repos <- get_repos(git_stats, cache = FALSE)

