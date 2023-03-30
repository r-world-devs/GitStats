# Error appears when no orgs are specified when pulling repos

    Please specify first organizations for [https://api.github.com] with `set_organizations()`.

# `get_repos()` returns repos table

    Code
      get_repos(gitstats_obj = test_gitstats, print_out = FALSE)
    Message <cliMessage>
      i [GitHub Public][r-world-devs] Pulling repositories...
      i Number of repositories: 7

# Getting repos by language works correctly

    Code
      get_repos(gitstats_obj = test_gitstats, language = "Python", print_out = FALSE)
    Message <cliMessage>
      i [GitHub Public][r-world-devs] Pulling repositories...
      i Number of repositories: 7
      i Filtering by language.

# Proper information pops out when one wants to get stats by phrase without specifying phrase

    Code
      get_repos(gitstats_obj = test_gitstats, by = "phrase")
    Error <rlang_error>
      You have to provide a phrase to look for.

# Getting repositories by teams works

    Code
      result <- test_github$get_repos(by = "team", team = list(Member1 = list(logins = "kalimu"),
      Member2 = list(logins = "epijim")))
    Message <cliMessage>
      i Filtering by team members.

# `get_repos()` methods pulls repositories from GitLab and translates output into `data.frame`

    Code
      repos <- test_gitlab$get_repos(by = "org")
    Message <cliMessage>
      i [GitLab][mbtests] Pulling repositories...
      i Number of repositories: 6

# `get_repos()` throws empty tables for GitLab

    Code
      repos_Python <- test_gitlab$get_repos(by = "org", language = "Python")
    Message <cliMessage>
      i [GitLab][mbtests] Pulling repositories...
      i Number of repositories: 6
      i Filtering by language.

# `get_repos()` methods pulls repositories from GitHub and translates output into `data.frame`

    Code
      repos <- test_github$get_repos(by = "org")

# `get_repos()` throws empty tables for GitHub

    Code
      repos_JS <- test_github$get_repos(by = "org", language = "Javascript")
    Message <cliMessage>
      i [GitHub Public][r-world-devs] Pulling repositories...
      i Number of repositories: 7
      i Filtering by language.

