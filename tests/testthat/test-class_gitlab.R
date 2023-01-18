git_lab_public <- GitLab$new(
  rest_api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT"),
  orgs = c("erasmusmc-public-health")
)

test_that("Get_repos methods pulls repositories from GitLab and translates output into data.frame", {
  repos <- git_lab_public$get_repos(by = "org")

  expect_s3_class(repos, "data.frame")
  expect_named(repos, c("organisation", "name", "created_at", "last_activity_at", "description", "git_platform", "api_url"))
  expect_gt(nrow(repos), 0)

  team <- c("davidblok", "erasmgz", "PetradeVries")

  repos_by_team <- git_lab_public$get_repos(
    by = "team",
    team = team
  )

  expect_s3_class(repos_by_team, "data.frame")
  expect_named(repos_by_team, c("organisation", "name", "created_at", "last_activity_at", "description", "git_platform", "api_url"))
  expect_gt(nrow(repos_by_team), 0)
})
