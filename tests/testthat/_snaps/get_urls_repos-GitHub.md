# get_repos_urls_from_orgs prepares web repo_urls vector

    Code
      gh_repos_urls_from_orgs <- github_testhost_priv$get_repos_urls_from_orgs(type = "web",
        verbose = TRUE, progress = FALSE)
    Message
      > [Host:GitHub][Engine:REST][Scope:test_org] Pulling repositories (URLs)...

# get_repos_urls_from_repos prepares web repo_urls vector

    Code
      gh_repos_urls <- github_testhost_priv$get_repos_urls_from_repos(type = "web",
        verbose = TRUE, progress = FALSE)
    Message
      > [Host:GitHub][Engine:REST][Scope:test_org/TestRepo] Pulling repositories (URLs)...

# get_all_repos_urls prepares web repo_urls vector

    Code
      gh_repos_urls <- github_testhost_priv$get_all_repos_urls(type = "web", verbose = TRUE)

