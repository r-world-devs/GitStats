test_that("get_users_from_hosts work", {
  mockery::stub(
    test_gitstats_priv$get_users_from_hosts,
    "host$get_users",
    test_mocker$use("github_users")
  )
  users_from_hosts <- test_gitstats_priv$get_users_from_hosts()
  expect_users_table(users_from_hosts)
  test_mocker$cache(users_from_hosts)
})

test_that("GitStats get users info", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  mockery::stub(
    test_gitstats$get_users,
    "private$get_users_from_hosts",
    test_mocker$use("users_from_hosts")
  )
  users_result <- test_gitstats$get_users(
    c("test_user1", "test_user2"),
    verbose = FALSE
  )
  expect_users_table(
    users_result
  )
  test_mocker$cache(users_result)
})

test_that("get users works correctly", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  mockery::stub(
    get_users,
    "gitstats$get_users",
    test_mocker$use("users_result")
  )
  users_result <- get_users(
    gitstats = test_gitstats,
    c("test_user1", "test_user2"),
    verbose = FALSE
  )
  expect_users_table(
    users_result
  )
})

test_that("get_users prints info on data used to pull data", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  mockery::stub(
    get_users,
    "gitstats$get_users",
    test_mocker$use("users_result")
  )
  expect_snapshot(
    users_result <- get_users(
      gitstats = test_gitstats,
      c("test_user1", "test_user2"),
      verbose = TRUE
    )
  )
})
