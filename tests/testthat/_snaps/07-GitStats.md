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
       Organizations: [0] 
       Repositories: [4] r-world-devs/GitStats, openpharma/GithubMetrics, mbtests/gitstatstesting, mbtests/gitstats-testing-2
      Storage: <no tables in storage>

# check_for_host returns error when no hosts are passed

    Add first your hosts with `set_github_host()` or `set_gitlab_host()`.

# check_params_conflict returns error

    ! Passing files to `in_files` parameter works only when you search code with `with_code` parameter.
    i If you want to search for repositories with [DESCRIPTION] files you should instead use `with_files` parameter.

---

    x Both `with_code` and `with_files` parameters are defined.
    ! Use either `with_code` of `with_files` parameter.
    i If you want to search for [shiny] code in given files - use `in_files` parameter together with `with_code` instead.

# get_repos works properly and for the second time uses cache

    Code
      repos_table <- test_gitstats$get_repos()
    Message
      ! Retrieving repositories from the GitStats storage.
      i If you wish to pull the data from API once more, set `cache` parameter to `FALSE`.

# get_files_structure_from_hosts works as expected

    Code
      files_structure <- test_gitstats$get_files_structure(pattern = "\\md", depth = 1L,
        verbose = TRUE)

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

