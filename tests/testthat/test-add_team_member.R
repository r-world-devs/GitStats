suppressMessages(test_gitstats <- create_gitstats())

test_gitstats_priv <- environment(test_gitstats$setup)$private

test_that("add_team_member() adds team member in `GitStats` object", {
  expect_snapshot(
    add_team_member(test_gitstats, "John Test")
  )
  expect_snapshot(
    test_gitstats_priv$settings$team
  )
  expect_snapshot(
    add_team_member(test_gitstats, "George Test", "george_test")
  )
  expect_snapshot(
    test_gitstats_priv$settings$team
  )
  expect_length(
    test_gitstats_priv$settings$team, 2
  )
})
