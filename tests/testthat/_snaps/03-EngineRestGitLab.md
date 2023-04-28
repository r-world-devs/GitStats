# `get_repos_by_phrase()` works

    Code
      result <- test_rest$get_repos(org = "erasmusmc-public-health", settings = settings)
    Message <cliMessage>
      i [GitLab][Engine:REST][phrase:covid][org:erasmusmc-public-health] Searching repositories...

# `get_commits()` works as expected

    Code
      result <- test_rest$get_commits(org = "mbtests", date_from = "2023-01-01",
        date_until = "2023-04-20", settings = settings)
    Message <cliMessage>
      i [GitLab][Engine:REST][org:mbtests] Pulling repositories...
      i [GitLab][Engine:REST][org:mbtests] Pulling commits...

