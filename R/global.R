# This is a solution for warnings in r-cmd checks of global variables
globalVariables(c(
  ".", "fullname", "platform", "organization", "repo_url",
  "name", "last_activity_at", "stats_date", "committed_date",
  "api_url", "row_no", ".N"
))
