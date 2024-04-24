test_gitstats <- create_test_gitstats(
  hosts = 2,
  inject_repos = "repos_table",
  inject_commits = "commits_table"
)

test_that("show_orgs() returns orgs", {
  expect_equal(
    show_orgs(test_gitstats),
    c("r-world-devs", "mbtests")
  )
})
