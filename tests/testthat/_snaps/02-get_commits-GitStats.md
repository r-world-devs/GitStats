# get_commits prints warning when commits table is empty

    Code
      commits_table <- test_gitstats$get_commits(since = "2023-06-15", until = "2023-06-30",
        cache = FALSE, verbose = TRUE)
    Message
      i Cache set to FALSE, I will pull data from API.
      ! No commits found.

# get_commits() returns error when since is not defined

    You need to pass date to `since` parameter.

# get_commits() prints time used

    Code
      commits <- get_commits(test_gitstats, since = "2023-06-15", until = "2023-06-30",
        verbose = TRUE)
    Message
      v Data pulled in 0 secs

