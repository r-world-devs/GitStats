test_that("pull_users shows error when no hosts are defined", {
  test_gitstats <- create_gitstats()
  expect_snapshot_error(
    pull_users(test_gitstats,
              c("maciekbanas", "kalimu"))
  )
})

test_that("pull_users works as expected", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  pull_users(test_gitstats,
            c("maciekbanas", "kalimu"))
  users_table <- test_gitstats$get_users()
  expect_users_table(
    users_table
  )
})
