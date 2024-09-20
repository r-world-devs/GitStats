# private

test_host <- create_gitlab_testhost(
  orgs = "mbtests",
  mode = "private"
)

test_that("`set_default_token` sets default token for GitLab", {
  expect_snapshot(
    withr::with_envvar(new = c("GITLAB_PAT" = Sys.getenv("GITLAB_PAT_PUBLIC")), {
      default_token <- test_host$set_default_token()
    })
  )
  test_rest <- create_testrest(token = default_token,
                               mode = "private")
  expect_equal(
    test_rest$perform_request(
      endpoint = "https://gitlab.com/api/v4/projects",
      token = default_token
    )$status,
    200
  )
})

test_that("`set_searching_scope` throws error when both `orgs` and `repos` are defined", {
  expect_snapshot_error(
    test_host$set_searching_scope(
      orgs = "mbtests",
      repos = "mbtests/GitStatsTesting"
    )
  )
})
