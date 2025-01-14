# This is a solution for warnings in r-cmd checks of global variables
globalVariables(c(
  ".", "fullname", "platform", "organization", "repo_url",
  "repo_name", "created_at", "last_activity_at", "last_activity", "stats_date",
  "committed_date", "commits_n", "api_url", "row_no", ".N", ".data",
  "repository", "stars", "forks", "languages", "issues_open", "issues_closed",
  "contributors_n", "githost"
))

text_ext_files <- "\\.(txt|md|qmd|Rmd|markdown|yaml|yml|csv|json|xml|html|htm|css|js|r|py|sh|bat|ini|conf|log|sql|tsv|mdx)$"
no_ext_files <- "^[^\\.]+$"

text_files_pattern <- paste0("(", text_ext_files, "|", no_ext_files, ")")
