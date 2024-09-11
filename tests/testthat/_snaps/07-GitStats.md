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
       Organizations: [2] r-world-devs, mbtests
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

# if returned files_structure is empty, do not store it and give proper message

    Code
      files_structure <- test_gitstats$get_files_structure_from_hosts(pattern = "\\.png",
        depth = 1L, verbose = TRUE)
    Message
      ! No files structure found for matching pattern \.png in 1 level of dirs.
      ! Files structure will not be saved in GitStats.

---

    Code
      files_structure <- test_gitstats$get_files_structure(pattern = "\\.png", depth = 1L,
        verbose = TRUE)

# get_repos works properly and for the second time uses cache

    Code
      repos_table <- test_gitstats$get_repos()
    Message
      ! Retrieving repositories from the GitStats storage.
      i If you wish to pull the data from API once more, set `cache` parameter to `FALSE`.

# get_files_structure works as expected

    Code
      files_structure <- test_gitstats$get_files_structure(pattern = "\\.md", depth = 2L,
        verbose = TRUE)

# get_files_content makes use of files_structure

    Code
      files_content <- test_gitstats$get_files_content(file_path = NULL,
        use_files_structure = TRUE, verbose = TRUE)
    Message
      i I will make use of files structure stored in GitStats.
      i [Host:GitHub][Engine:GraphQl][Scope:r-world-devs] Pulling files from files structure...
      i [Host:GitHub][Engine:GraphQl][Scope:openpharma] Pulling files from files structure...
      i I will make use of files structure stored in GitStats.
      i [Host:GitLab][Engine:GraphQl][Scope:mbtests] Pulling files from files structure...
      i [Host:GitLab][Engine:GraphQl][Scope:mbtestapps] Pulling files from files structure...

---

    Code
      test_gitstats
    Output
      A GitStats object for 2 hosts: 
      Hosts: https://api.github.com, https://gitlab.com/api/v4
      Scanning scope: 
       Organizations: [2] r-world-devs, mbtests
       Repositories: [0] 
      Storage: 
       character(0)
       Files_structure: 2 [files matching pattern: \.md]

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

