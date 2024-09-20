# if returned files_structure is empty, do not store it and give proper message

    Code
      files_structure <- test_gitstats_priv$get_files_structure_from_hosts(pattern = "\\.png",
        depth = 1L, verbose = TRUE)
    Message
      ! No files structure found for matching pattern \.png in 1 level of dirs.
      ! Files structure will not be saved in GitStats.

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

