git_lab_wrong_groups <- GitLabClient$new(
  groups = "Avengers",
  rest_api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT")
)

test_that("warning pops-up when wrong owners are submitted", {
  expect_warning(git_lab_wrong_groups$get_repos_by_owner())
})
