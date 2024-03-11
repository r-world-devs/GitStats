# pull_repos pulls repos in the table format

    Code
      pull_repos(test_gitstats)
    Message
      i [GitHub][Engine:GraphQL][org:r-world-devs] Pulling repositories...
      i [GitLab][Engine:GraphQL][org:mbtests] Pulling repositories...

# pull_repos_contributors adds contributors column to repos table

    Code
      pull_repos_contributors(test_gitstats)
    Message
      i [GitHub][Engine:REST][org:r-world-devs] Pulling contributors...
      i [GitLab][Engine:REST][org:mbtests] Pulling contributors...

# pull_users shows error when no hosts are defined

    Add first your hosts with `set_host()`.

# pull_files works as expected

    Code
      pull_files(test_gitstats, "meta_data.yaml")
    Message
      i [Engine:GraphQL][org:r-world-devs] Pulling meta_data.yaml files...
      i [Engine:GraphQL][org:mbtests] Pulling meta_data.yaml files...

# pull_release_logs works as expected

    Code
      pull_release_logs(test_gitstats, date_from = "2023-05-01", date_until = "2023-09-30")
    Message
      i [Engine:GraphQL][org:r-world-devs] Pulling releases...
      i [GitHub][Engine:GraphQL][org:r-world-devs] Pulling repositories...
      i [Engine:GraphQL][org:openpharma] Pulling releases...
      i [GitHub][Engine:GraphQL][org:openpharma] Pulling repositories...

