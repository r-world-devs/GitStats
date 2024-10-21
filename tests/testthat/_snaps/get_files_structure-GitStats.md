# if returned files_structure is empty, do not store it and give proper message

    Code
      files_structure <- test_gitstats_priv$get_files_structure_from_hosts(pattern = "\\.png",
        depth = 1L, verbose = TRUE)
    Message
      ! No files structure found for matching pattern \.png in 1 level of dirs.
      ! Files structure will not be saved in GitStats.

