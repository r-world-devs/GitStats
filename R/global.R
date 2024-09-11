# This is a solution for warnings in r-cmd checks of global variables
globalVariables(c(
  ".", "fullname", "platform", "organization", "repo_url",
  "repo_name", "created_at", "last_activity_at", "last_activity", "stats_date",
  "committed_date", "commits_n", "api_url", "row_no", ".N", ".data",
  "repository", "stars", "forks", "languages", "issues_open", "issues_closed",
  "contributors_n"
))

non_text_files_pattern <- "\\.(png||.jpg||.jpeg||.bmp||.gif||.tiff)$"
