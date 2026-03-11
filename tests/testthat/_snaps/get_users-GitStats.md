# GitStats get_users prints messages

    Code
      users_result <- test_gitstats$get_users(c("test_user1", "test_user2"),
        verbose = TRUE)
    Message
      > Pulling users 🙍 data...

# get_users prints info on data used to pull data

    Code
      users_result <- get_users(gitstats = test_gitstats, c("test_user1",
        "test_user2"), verbose = TRUE)
    Message
      v Data pulled in 0 secs

