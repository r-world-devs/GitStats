# get_orgs() pulls data from storage for the second time

    Code
      orgs_table <- test_gitstats$get_orgs()
    Message
      ! Getting cached organizations data.
      i If you wish to pull the data from API once more, set `cache` parameter to `FALSE`.

# get_orgs prints info on time used to pull data

    Code
      orgs_table <- get_orgs(test_gitstats, verbose = TRUE)
    Message
      v Data pulled in 0 secs

