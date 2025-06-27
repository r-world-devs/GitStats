# GitStats prints empty fields.

    Code
      test_gitstats
    Output
      A GitStats object for 0 hosts: 
      Hosts: 
      Scanning scope: 
       Organizations: [0] 
       Repositories: [0] 
      Storage: <no data in storage>

# GitStats prints the proper info when connections are added.

    Code
      test_gitstats
    Output
      A GitStats object for 2 hosts: 
      Hosts: https://api.github.com, https://gitlab.com/api/v4
      Scanning scope: 
       Organizations: [2] github_test_org, gitlab_test_group
       Repositories: [0] 
      Storage: <no data in storage>

# GitStats prints the proper info when repos are passed instead of orgs.

    Code
      test_gitstats
    Output
      A GitStats object for 2 hosts: 
      Hosts: https://api.github.com, https://gitlab.com/api/v4
      Scanning scope: 
       Organizations: [0] 
       Repositories: [4] r-world-devs/GitStats, openpharma/GithubMetrics, mbtests/gitstatstesting, mbtests/gitstats-testing-2
      Storage: <no data in storage>

# check_for_host returns error when no hosts are passed

    Add first your hosts with `set_github_host()` or `set_gitlab_host()`.

# check_params_conflict returns error

    ! Passing files to `in_files` parameter works only when you search code with `with_code` parameter.
    i If you want to search for repositories with [DESCRIPTION] files you should instead use `with_files` parameter.

---

    x Both `with_code` and `with_files` parameters are defined.
    ! Use either `with_code` of `with_files` parameter.
    i If you want to search for [shiny] code in given files - use `in_files` parameter together with `with_code` instead.

# print_storage_attribute

    Code
      test_gitstats_priv$print_storage_attribute(storage_data = test_mocker$use(
        "commits_table"), storage_name = "commits")
    Output
      <cli_ansi_string>
      [1] [date range: 2023-06-15 - 2023-06-30]

---

    Code
      test_gitstats_priv$print_storage_attribute(storage_data = test_mocker$use(
        "release_logs_table"), storage_name = "release_logs")
    Output
      <cli_ansi_string>
      [1] [date range: 2023-08-01 - 2023-09-30]

---

    Code
      test_gitstats_priv$print_storage_attribute(storage_data = test_mocker$use(
        "repos_trees"), storage_name = "repos_trees")
    Output
      <cli_ansi_string>
      [1] [file pattern: ]

# subgroups are cleanly printed in GitStats

    Code
      test_gitstats
    Output
      A GitStats object for 1 hosts: 
      Hosts: https://gitlab.com/api/v4
      Scanning scope: 
       Organizations: [1] mbtests/subgroup
       Repositories: [0] 
      Storage: <no data in storage>

