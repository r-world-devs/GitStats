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
      Verbose: TRUE
      Use storage: TRUE
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
      Verbose: FALSE
      Use storage: TRUE
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
       Files: <not defined>
      Search settings: 
       Search parameter: repo
       Phrase: <not defined>
       Language: All
       Team: <not defined>
      Verbose: TRUE
      Use storage: TRUE
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
      Verbose: TRUE
      Use storage: TRUE
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
      Verbose: TRUE
      Use storage: TRUE
      Storage: <no tables in storage>

# get_release_logs works as expected

    Code
      release_logs <- test_gitstats$get_release_logs(since = "2023-05-01", until = "2023-09-30")

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
      Verbose: FALSE
      Use storage: TRUE
      Storage: 
       Repositories: 17 
       Commits: 24 [date range: 2023-06-15 - 2023-06-30]
       R_package_usage: 12 [package: purrr]

