# get_issues() returns warning if issues table is empty

    Code
      issues_table <- test_gitstats$get_issues(since = "2023-01-01", until = "2025-03-06",
        cache = FALSE, state = NULL, verbose = TRUE)
    Message
      i Cache set to FALSE, I will pull data from API.
      ! No issues found.

# get_issues() prints data on time used

    Code
      issues_data <- get_issues(test_gitstats, since = "2023-01-01", until = "2025-03-06",
        verbose = TRUE)
    Message
      v Data pulled in 0 secs

