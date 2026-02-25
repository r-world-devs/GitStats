# get_pull_requests() returns warning if issues table is empty

    Code
      pr_table <- test_gitstats$get_pull_requests(since = "2023-01-01", until = "2025-03-06",
        cache = FALSE, state = NULL, verbose = TRUE)
    Message
      > Pulling pull requests...
      ! No pull requests found.

# get_pull_requests() prints data on time used

    Code
      pr_data <- get_pull_requests(test_gitstats, since = "2023-01-01", until = "2025-03-06",
        verbose = TRUE)
    Message
      v Data pulled in 0 secs

