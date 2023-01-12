git_lab_wrong_groups <- GitLabClient$new(
  groups = "Avengers",
  rest_api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT")
)
