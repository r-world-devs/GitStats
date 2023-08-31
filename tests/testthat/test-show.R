test_that("show_orgs() shows orgs", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  expect_equal(
    show_orgs(test_gitstats),
    c("r-world-devs", "openpharma", "mbtests")
  )
})
