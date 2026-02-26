# get_pull_requests gets data from storage for the second time

    Code
      pr_table <- test_gitstats$get_pull_requests(since = "2023-01-01", until = "2025-03-06",
        state = NULL, verbose = FALSE)
    Message
      ! Getting cached pull_requests data.
      i If you wish to pull the data from API once more, set `cache` parameter to `FALSE`.

# get_pull_requests() returns warning if PR table is empty

    Code
      pr_table <- test_gitstats$get_pull_requests(since = "2023-01-01", until = "2025-03-06",
        cache = FALSE, state = NULL, verbose = TRUE)
    Message
      i Cache set to FALSE, I will pull data from API.
      > Pulling pull requests...
      ! No pull requests found.

# get_pull_requests() prints data on time used

    Code
      pr_data <- get_pull_requests(test_gitstats, since = "2023-01-01", until = "2025-03-06",
        verbose = TRUE)
    Message
      v Data pulled in 0 secs

