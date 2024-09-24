test_that("show_orgs() returns orgs", {
  expect_equal(
    show_orgs(test_gitstats),
    c("r-world-devs", "mbtests")
  )
})
