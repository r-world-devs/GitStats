test_that("show_orgs() returns orgs", {
  expect_equal(
    show_orgs(test_gitstats),
    c("github_test_org", "gitlab_test_group")
  )
})
