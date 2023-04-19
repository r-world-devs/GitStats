# GitPlatform filters GitHub repositories' table by team members

    Code
      result <- test_host$filter_repos_by_team(gh_repos_table, team = list(Member1 = list(
        logins = "krystian8207"), Member2 = list(logins = "maciekbanas")))
    Message <cliMessage>
      i Filtering by team members.

# GitPlatform filters GitLab repositories' table by team members

    Code
      result <- test_host$filter_repos_by_team(gl_repos_table, team = list(Member1 = list(
        logins = "maciekbanas")))
    Message <cliMessage>
      i Filtering by team members.

# GitPlatform filters repositories' table by languages

    Code
      result <- test_host$filter_repos_by_language(repos_table, language = "JavaScript")
    Message <cliMessage>
      i Filtering by language.

