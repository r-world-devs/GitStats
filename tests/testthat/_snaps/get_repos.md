# Getting repos by language works correctly

    Code
      get_repos(gitstats_obj = test_gitstats, language = "R", print_out = FALSE)
    Message <cliMessage>
      > Pulling repositories...

---

    Code
      get_repos(gitstats_obj = test_gitstats, language = "Python", print_out = FALSE)
    Message <cliMessage>
      > Pulling repositories...
    Message <simpleMessage>
      Empty object - will not be saved.

# Proper information pops out when one wants to get stats by phrase without specifying phrase

    Code
      get_repos(gitstats_obj = test_gitstats, by = "phrase")
    Error <simpleError>
      You have to provide a phrase to look for.

# `get_repos()` by team in case when no `orgs` are specified

    Code
      test_gitstats %>% set_team(team_name = "RWD-IE", "galachad", "kalimu",
        "maciekbanas", "Cotau", "krystian8207", "marcinkowskak") %>% get_repos(by = "team",
        print_out = FALSE)
    Warning <simpleWarning>
      No organizations specified for GitHub.
    Message <cliMessage>
      > Pulling organizations by team.
      v Pulled 1 organizations.
      > Pulling repositories...

