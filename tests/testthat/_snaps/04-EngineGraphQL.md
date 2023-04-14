# GraphQL Engine filters repositories' table by team members

    Code
      result <- test_gql_priv$filter_repos_by_team(repos_table, team = list(Member1 = list(
        logins = "kalimu"), Member2 = list(logins = "epijim")))
    Message <cliMessage>
      i Filtering by team members.

# GraphQL Engine filters repositories' table by languages

    Code
      result <- test_gql_priv$filter_repos_by_language(repos_table, language = "JavaScript")
    Message <cliMessage>
      i Filtering by language.

