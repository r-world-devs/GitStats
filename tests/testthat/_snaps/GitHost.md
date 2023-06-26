# GitHost filters repositories' table by languages

    Code
      result <- test_host$filter_repos_by_language(repos_table, language = "JavaScript")
    Message <cliMessage>
      i Filtering by language.

# add_repos_contributors returns table with contributors

    Code
      repos_table_2 <- test_host$add_repos_contributors(repos_table_1)
    Message <cliMessage>
      i [GitHub][Engine:REST] Pulling contributors...

