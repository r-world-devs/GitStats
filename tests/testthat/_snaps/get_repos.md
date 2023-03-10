# Getting repos by phrase and language works correctly

    Code
      get_repos(gitstats_obj = test_gitstats, by = "phrase", phrase = "covid",
        language = "R", print_out = FALSE)
    Message <cliMessage>
      > [GitHub] Pulling repositories...
      v On GitHub ('pharmaverse') found 2 repositories.

---

    Code
      get_repos(gitstats_obj = test_gitstats, language = "Python", print_out = FALSE)
    Message <cliMessage>
      > [GitHub] Pulling repositories...
    Message <simpleMessage>
      Empty object - will not be saved.

# Proper information pops out when one wants to get stats by phrase without specifying phrase

    Code
      get_repos(gitstats_obj = test_gitstats, by = "phrase")
    Error <simpleError>
      You have to provide a phrase to look for.

# Getting repositories by teams works

    Code
      result <- test_github$get_repos(by = "team", team = c("kalimu", "maciekbanas"))
    Message <cliMessage>
      > [GitHub] Pulling repositories...

# `get_repos()` by team in case when no `orgs` are specified pulls organizations first, then repos

    Code
      test_gitstats %>% set_team(team_name = "RWD-IE", "galachad", "kalimu",
        "maciekbanas", "Cotau", "krystian8207", "marcinkowskak") %>% get_repos(by = "team",
        print_out = FALSE)
    Message <cliMessage>
      ! No organizations specified for GitHub.
      > Pulling organizations by team.
      v Pulled 1 organizations.
      > [GitHub] Pulling repositories...

# `get_repos()` methods pulls repositories from GitLab and translates output into `data.frame`

    Code
      repos <- test_gitlab$get_repos(by = "org")
    Message <cliMessage>
      > [GitLab] Pulling repositories...

# `get_repos()` throws empty tables for GitLab

    Code
      repos_Python <- test_gitlab$get_repos(by = "org", language = "Python")
    Message <cliMessage>
      > [GitLab] Pulling repositories...

# `get_repos()` methods pulls repositories from GitHub and translates output into `data.frame`

    Code
      repos <- test_github$get_repos(by = "org")
    Message <cliMessage>
      > [GitHub] Pulling repositories...

# `get_repos()` throws empty tables for GitHub

    Code
      repos_JS <- test_github$get_repos(by = "org", language = "Javascript")
    Message <cliMessage>
      > [GitHub] Pulling repositories...

