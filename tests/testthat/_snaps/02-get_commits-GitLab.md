# get_commits_from_orgs works

    Code
      gl_commits_table <- gitlab_testhost_priv$get_commits_from_orgs(since = "2023-03-01",
        until = "2023-04-01", verbose = TRUE, progress = FALSE)
    Message
      > [Host:GitLab][Engine:REST][Scope:test_group] Pulling commits...

# get_commits_from_repos works

    Code
      gl_commits_table <- gitlab_testhost_priv$get_commits_from_repos(since = "2023-03-01",
        until = "2023-04-01", verbose = TRUE, progress = FALSE)
    Message
      > [Host:GitLab][Engine:REST][Scope:test_org: 1 repos] Pulling commits...

