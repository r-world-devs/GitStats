# get_files gets data from storage for the second time

    Code
      files_table <- test_gitstats$get_files(pattern = NULL, depth = Inf, file_path = "meta_data.yaml",
        verbose = FALSE)
    Message
      ! Getting cached files data.
      i If you wish to pull the data from API once more, set `cache` parameter to `FALSE`.

# error shows when file_path and pattern are defined at the same time

    Please choose either `pattern` or `file_path`.

# get_files prints time used to pull data

    Code
      files_table <- get_files(test_gitstats, file_path = "meta_data.yaml", verbose = TRUE,
        progress = FALSE)
    Message
      v Data pulled in 0 secs

