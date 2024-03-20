# GitStats prints empty fields.

    Code
      test_gitstats
    Output
      A GitStats object for 0 hosts: 
      Hosts: 
      Scanning scope: 
       Organizations: [0] 
       Repositories: [0] 
       Files: <not defined>
      Search settings: 
       Search parameter: <not defined>
       Phrase: <not defined>
       Language: All
       Team: <not defined>
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
       Files: <not defined>
      Search settings: 
       Search parameter: org
       Phrase: <not defined>
       Language: All
       Team: <not defined>
      Storage: <no tables in storage>

# GitStats prints the proper info when repos are passed instead of orgs.

    Code
      test_gitstats
    Output
      A GitStats object for 2 hosts: 
      Hosts: https://api.github.com, https://gitlab.com/api/v4
      Scanning scope: 
       Organizations: [0] 
       Repositories: [4] r-world-devs/GitStats, openpharma/GithubMetrics, mbtests/gitstatstesting, mbtests/gitstats-testing-2
       Files: <not defined>
      Search settings: 
       Search parameter: repo
       Phrase: <not defined>
       Language: All
       Team: <not defined>
      Storage: <no tables in storage>

# GitStats prints team name when team is added.

    Code
      test_gitstats
    Output
      A GitStats object for 2 hosts: 
      Hosts: https://api.github.com, https://gitlab.com/api/v4
      Scanning scope: 
       Organizations: [2] r-world-devs, mbtests
       Repositories: [0] 
       Files: <not defined>
      Search settings: 
       Search parameter: team
       Phrase: <not defined>
       Language: All
       Team: RWD-IE (0 members)
      Storage: <no tables in storage>

# check_for_host returns error when no hosts are passed

    Add first your hosts with `set_host()`.

# subgroups are cleanly printed in GitStats

    Code
      test_gitstats
    Output
      A GitStats object for 1 hosts: 
      Hosts: https://gitlab.com/api/v4
      Scanning scope: 
       Organizations: [1] mbtests/subgroup
       Repositories: [0] 
       Files: <not defined>
      Search settings: 
       Search parameter: org
       Phrase: <not defined>
       Language: All
       Team: <not defined>
      Storage: <no tables in storage>

# get_release_logs works as expected

    Code
      release_logs <- test_gitstats$get_release_logs(date_from = "2023-05-01",
        date_until = "2023-09-30")
    Message
      i [Engine:GraphQL][org:r-world-devs] Pulling releases...
      i [GitHub][Engine:GraphQL][org:r-world-devs] Pulling repositories...
      i [Engine:GraphQL][org:openpharma] Pulling releases...
      i [GitHub][Engine:GraphQL][org:openpharma] Pulling repositories...

# GitStats prints with storage

    Code
      test_gitstats
    Output
      A GitStats object for 2 hosts: 
      Hosts: https://api.github.com, https://gitlab.com/api/v4
      Scanning scope: 
       Organizations: [2] r-world-devs, mbtests
       Repositories: [0] 
       Files: <not defined>
      Search settings: 
       Search parameter: org
       Phrase: <not defined>
       Language: All
       Team: <not defined>
      Storage: 
       Repositories: 17 rows x 16 cols
       Commits: 24 rows x 10 cols
       R_package_usage: 11 rows x 4 cols

