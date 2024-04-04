# `set_default_token` sets default token for GitLab

    Code
      withr::with_envvar(new = c(GITLAB_PAT = Sys.getenv("GITLAB_PAT_PUBLIC")), {
        default_token <- test_host$set_default_token()
      })
    Message
      i Using PAT from GITLAB_PAT envar.

# `check_orgs_and_repos` throws error when both `orgs` and `repos` are defined

    Do not specify `orgs` while specifing `repos`.
    x Host will not be added.
    i Specify `orgs` or `repos`.

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

# pull_repos_contributors returns table with contributors for GitLab

    Code
      repos_table_2 <- test_host$pull_repos_contributors(repos_table_1, test_settings)
    Message
      i [GitLab][Engine:REST][org:mbtests] Pulling contributors...

# pull_commits throws error when search param is set to `phrase`

    unused arguments (date_from = "2023-03-01", date_until = "2023-04-01")

# pull_commits for GitLab works with repos implied

    Code
      gl_commits_table <- test_host$pull_commits(since = "2023-01-01", until = "2023-06-01",
        settings = test_settings_repo)
    Message
      i [GitLab][Engine:REST][org:mbtests][custom repositories] Pulling commits...
      i Looking up for authors' names and logins...

