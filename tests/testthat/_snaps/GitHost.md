# `set_default_token` sets default token for public GitHub

    Code
      default_token <- test_host$set_default_token()
    Message <cliMessage>
      i Using PAT from GITHUB_PAT envar.

# `set_default_token` sets default token for GitLab

    Code
      withr::with_envvar(new = c(GITLAB_PAT = Sys.getenv("GITLAB_PAT_PUBLIC")), {
        default_token <- test_gl_host$set_default_token()
      })
    Message <cliMessage>
      i Using PAT from GITLAB_PAT envar.

# GitHost filters GitHub repositories' (pulled by org) table by languages

    Code
      result <- test_host$filter_repos_by_language(repos_table, language = "JavaScript")
    Message <cliMessage>
      i Filtering by language.

# GitHost filters GitHub repositories' (pulled by team) table by languages

    Code
      result <- test_host$filter_repos_by_language(repos_table, language = "CSS")
    Message <cliMessage>
      i Filtering by language.

# GitHost filters GitHub repositories' (pulled by phrase) table by languages

    Code
      result <- test_host$filter_repos_by_language(gh_repos_table, language = "R")
    Message <cliMessage>
      i Filtering by language.

# GitHost filters GitLab repositories' (pulled by org) table by languages

    Code
      result <- test_host$filter_repos_by_language(gl_repos_table, language = "Python")
    Message <cliMessage>
      i Filtering by language.

# GitHost filters GitLab repositories' (pulled by team) table by languages

    Code
      result <- test_host$filter_repos_by_language(repos_table, language = "Python")
    Message <cliMessage>
      i Filtering by language.

# GitHost filters GitLab repositories' (pulled by phrase) table by languages

    Code
      result <- test_host$filter_repos_by_language(gl_repos_table, language = "C")
    Message <cliMessage>
      i Filtering by language.

# add_repos_contributors returns table with contributors

    Code
      repos_table_2 <- test_host$add_repos_contributors(repos_table_1)
    Message <cliMessage>
      i [GitHub][Engine:REST] Pulling contributors...

