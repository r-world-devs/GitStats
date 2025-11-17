test_that("show_orgs() returns orgs", {
  expect_equal(
    show_orgs(test_gitstats),
    c("github_test_org", "gitlab_test_group")
  )
})

test_that("show_hosts() returns some details on hosts", {
  expect_equal(
    show_hosts(test_gitstats),
    list(
      list(
        "host" = "GitHub", 
        "web_url" = "https://github.com",
        "api_url" = "https://api.github.com"
      ),
      list(
        "host" = "GitLab", 
        "web_url" = "https://gitlab.com",
        "api_url" = "https://gitlab.com/api/v4"
      )
    )
  )
})
