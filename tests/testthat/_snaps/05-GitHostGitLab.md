# `set_default_token` sets default token for GitLab

    Code
      withr::with_envvar(new = c(GITLAB_PAT = Sys.getenv("GITLAB_PAT_PUBLIC")), {
        default_token <- test_host$set_default_token()
      })
    Message
      i Using PAT from GITLAB_PAT envar.

# `set_searching_scope` throws error when both `orgs` and `repos` are defined

    Do not specify `orgs` while specifing `repos`.
    x Host will not be added.
    i Specify `orgs` or `repos`.

# get_commits for GitLab works with repos implied

    Code
      gl_commits_table <- test_host$get_commits(since = "2023-01-01", until = "2023-06-01",
        settings = test_settings_repo)

