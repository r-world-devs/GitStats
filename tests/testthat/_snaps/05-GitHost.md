# `set_default_token` sets default token for public GitHub

    Code
      default_token <- test_host$set_default_token()
    Message
      i Using PAT from GITHUB_PAT envar.

# `set_default_token` sets default token for GitLab

    Code
      withr::with_envvar(new = c(GITLAB_PAT = Sys.getenv("GITLAB_PAT_PUBLIC")), {
        default_token <- test_gl_host$set_default_token()
      })
    Message
      i Using PAT from GITLAB_PAT envar.

# GitHost pulls repos from orgs

    Code
      gh_repos_table <- test_host$pull_repos_from_orgs(settings)
    Message
      i [GitHub][Engine:GraphQL][org:r-world-devs] Pulling repositories...

# GitHost filters GitHub repositories' (pulled by org) table by languages

    Code
      result <- test_host$filter_repos_by_language(repos_table, language = "JavaScript")
    Message
      i Filtering by language.

# GitHost filters GitHub repositories' (pulled by team) table by languages

    Code
      result <- test_host$filter_repos_by_language(repos_table, language = "CSS")
    Message
      i Filtering by language.

# GitHost filters GitHub repositories' (pulled by phrase) table by languages

    Code
      result <- test_host$filter_repos_by_language(gh_repos_table, language = "R")
    Message
      i Filtering by language.

# GitHost filters GitLab repositories' (pulled by org) table by languages

    Code
      result <- test_host$filter_repos_by_language(gl_repos_table, language = "Python")
    Message
      i Filtering by language.

# GitHost filters GitLab repositories' (pulled by team) table by languages

    Code
      result <- test_host$filter_repos_by_language(repos_table, language = "Python")
    Message
      i Filtering by language.

# GitHost filters GitLab repositories' (pulled by phrase) table by languages

    Code
      result <- test_host$filter_repos_by_language(gl_repos_table, language = "C")
    Message
      i Filtering by language.

# pull_repos returns table of repositories

    Code
      repos_table <- test_host$pull_repos(settings = list(search_param = "org",
        language = "All"))
    Message
      i [GitHub][Engine:GraphQL][org:openpharma] Pulling repositories...
      i [GitHub][Engine:GraphQL][org:r-world-devs] Pulling repositories...

# pull_repos_contributors returns table with contributors for GitHub

    Code
      repos_table_2 <- test_host$pull_repos_contributors(repos_table_1)
    Message
      i [GitHub][Engine:REST][org:r-world-devs] Pulling contributors...

# pull_repos_contributors returns table with contributors for GitLab

    Code
      repos_table_2 <- test_gl_host$pull_repos_contributors(repos_table_1)
    Message
      i [GitLab][Engine:REST][org:MB Tests] Pulling contributors...
