test_that("GitStats get users info", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  users_result <- test_gitstats$get_users(
    c("maciekbanas", "kalimu", "marcinkowskak"),
    verbose = FALSE
  )
  expect_users_table(
    users_result
  )
})
