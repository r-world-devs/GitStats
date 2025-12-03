# GitStats makes use of stored data

    Code
      repos_trees <- test_gitstats$get_repos_trees(pattern = NULL, depth = Inf,
        cache = TRUE, verbose = TRUE, progress = FALSE)
    Message
      ! Getting cached repos_trees data.
      i If you wish to pull the data from API once more, set `cache` parameter to `FALSE`.

# GitStats prints warning when no repos trees found

    Code
      repos_trees <- test_gitstats$get_repos_trees(pattern = NULL, depth = Inf,
        cache = FALSE, verbose = TRUE, progress = FALSE)
    Message
      i Cache set to FALSE, I will pull data from API.
      > Pulling repositories structure...
      ! No repos 🌳 trees found.

