test_host <- create_github_testhost(orgs = "r-world-devs", mode = "private")

test_that("`check_orgs_and_repos` does not throw error when `orgs` or `repos` are defined", {
  expect_snapshot(
    test_host$check_orgs_and_repos(orgs = "mbtests", repos = NULL)
  )
  expect_snapshot(
    test_host$check_orgs_and_repos(orgs = NULL, repos = "mbtests/GitStatsTesting")
  )
})

test_that("`check_orgs_and_repos` throws error when host is public one", {
  expect_snapshot_error(
    test_host$check_orgs_and_repos(orgs = "mbtests", repos = "mbtests/GitStatsTesting")
  )
})

test_that("`extract_repos_and_orgs` extracts fullnames vector into a list of GitLab organizations with assigned repositories", {
  repos_fullnames <- c(
    "mbtests/gitstatstesting", "mbtests/gitstats-testing-2", "mbtests/subgroup/test-project-in-subgroup"
  )
  expect_equal(
    test_host$extract_repos_and_orgs(repos_fullnames),
    list(
      "mbtests" = c("gitstatstesting", "gitstats-testing-2"),
      "mbtests/subgroup" = c("test-project-in-subgroup")
    )
  )
})
