# `search_repos_by_phrase()` works

    Code
      gl_repos_by_phrase <- test_rest_priv$search_repos_by_phrase(phrase = "covid",
        org = "erasmusmc-public-health")
    Message <cliMessage>
      i [GitLab][erasmusmc-public-health][Engine:REST] Searching repos...

# `get_commits_from_org()` works as expected

    Code
      result <- test_rest$get_commits_from_org(org = "mbtests", repos_table = NULL,
        date_from = "2023-01-01", date_until = "2023-04-20", by = "org", team = NULL)
    Message <cliMessage>
      i [GitLab][mbtests][Engine:REST] Pulling commits...

