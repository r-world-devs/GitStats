# GitStats prints empty fields.

    Code
      test_gitstats
    Output
      A GitStats object for 0 hosts: 
      Hosts: 
      Scanning scope: 
       Organizations: [0] 
       Repositories: [0] 
      Storage: <no tables in storage>

# GitStats prints the proper info when connections are added.

    Code
      test_gitstats
    Output
      A GitStats object for 2 hosts: 
      Hosts: https://api.github.com, https://gitlab.com/api/v4
      Scanning scope: 
       Organizations: [2] r-world-devs, mbtests
       Repositories: [0] 
      Storage: <no tables in storage>

# GitStats prints the proper info when repos are passed instead of orgs.

    Code
      test_gitstats
    Output
      A GitStats object for 2 hosts: 
      Hosts: https://api.github.com, https://gitlab.com/api/v4
      Scanning scope: 
       Organizations: [3] r-world-devs, openpharma, mbtests
       Repositories: [4] GitStats, GithubMetrics, gitstatstesting, gitstats-testing-2
      Storage: <no tables in storage>

# check_for_host returns error when no hosts are passed

    Add first your hosts with `set_github_host()` or `set_gitlab_host()`.

# subgroups are cleanly printed in GitStats

    Code
      test_gitstats
    Output
      A GitStats object for 1 hosts: 
      Hosts: https://gitlab.com/api/v4
      Scanning scope: 
       Organizations: [1] mbtests/subgroup
       Repositories: [0] 
      Storage: <no tables in storage>

# get_release_logs works as expected

    Code
      release_logs <- test_gitstats$get_release_logs(since = "2023-05-01", until = "2023-09-30")
    Message
      i [Engine:GraphQL][org:r-world-devs] Pulling releases...
      i [GitHub][Engine:GraphQL][org:r-world-devs] Pulling repositories...
      i [Engine:GraphQL][org:openpharma] Pulling releases...
      i [GitHub][Engine:GraphQL][org:openpharma] Pulling repositories...
    Output
      Rows: 7
      Columns: 7
      $ repo_name    <chr> "shinyCohortBuilder", "GitStats", "staged.dependencies", ~
      $ repo_url     <chr> "https://github.com/r-world-devs/shinyCohortBuilder", "ht~
      $ release_name <chr> "v0.2.1", "0.1.0", "v0.3.1", "v0.3.0", "CRAN patch", "Fir~
      $ release_tag  <chr> "v0.2.1", "v0.1.0", "v0.3.1", "v0.3.0", "0.0.2", "0.0.1",~
      $ published_at <dttm> 2023-09-29 09:45:22, 2023-05-15 08:45:47, 2023-08-03 12:~
      $ release_url  <chr> "https://github.com/r-world-devs/shinyCohortBuilder/relea~
      $ release_log  <chr> "# shinyCohortBuilder 0.2.1\r\n\r\n* Fixed error showing ~

# GitStats prints with storage

    Code
      test_gitstats
    Output
      A GitStats object for 2 hosts: 
      Hosts: https://api.github.com, https://gitlab.com/api/v4
      Scanning scope: 
       Organizations: [2] r-world-devs, mbtests
       Repositories: [0] 
      Storage: 
       Repositories: 17 
       Commits: 24 [date range: 2023-06-15 - 2023-06-30]
       R_package_usage: 11 [package: purrr]

