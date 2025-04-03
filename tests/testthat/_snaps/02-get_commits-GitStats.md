# get_commits() returns error when since is not defined

    You need to pass date to `since` parameter.

# get_commits() prints time used

    Code
      commits <- get_commits(test_gitstats, since = "2023-06-15", until = "2023-06-30",
        verbose = TRUE)
    Message
      v Data pulled in 0 secs

