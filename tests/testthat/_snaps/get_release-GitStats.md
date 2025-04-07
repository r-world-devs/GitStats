# get_release_logs returns warning when releases table is empty

    Code
      release_logs_data <- test_gitstats$get_release_logs(since = "2023-08-01",
        until = "2023-09-30", cache = FALSE, verbose = TRUE)
    Message
      i Cache set to FALSE, I will pull data from API.
      ! No release logs found.

# get_release_logs prints time used to pull data

    Code
      release_logs_table <- get_release_logs(gitstats = test_gitstats, since = "2023-08-01",
        until = "2023-09-30", verbose = TRUE)
    Message
      v Data pulled in 0 secs

