# `GitService` filters repositories' list by team members

    Code
      result <- test_github_priv$filter_repos_by_team(repos_table, team = list(
        Member1 = list(logins = "kalimu"), Member2 = list(logins = "epijim")))
    Message <cliMessage>
      i Filtering by team members.

