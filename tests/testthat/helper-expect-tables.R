repo_table_colnames <- c(
  "repo_id", "repo_name", "default_branch", "stars", "forks", "created_at",
  "last_activity_at", "languages", "issues_open", "issues_closed",
  "organization", "repo_url"
)

expect_package_usage_table <- function(object, add_col = NULL) {
  expect_s3_class(object, "data.frame")
  expect_named(object, c("repo_name", "repo_url", "api_url", "package_usage"))
  expect_gt(nrow(object), 0)
}

expect_repos_table <- function(pull_repos_object, add_col = NULL) {
  repo_cols <- c(
    repo_table_colnames, add_col
  )
  expect_s3_class(pull_repos_object, "data.frame")
  expect_named(pull_repos_object, repo_cols)
  expect_gt(nrow(pull_repos_object), 0)
}

expect_commits_table <- function(pull_commits_object, with_stats = TRUE) {
  commit_cols <- c(
    "id", "committed_date", "author", "additions", "deletions",
    "repository", "organization", "api_url"
  )
  expect_s3_class(pull_commits_object, "data.frame")
  expect_named(pull_commits_object, commit_cols)
  expect_gt(nrow(pull_commits_object), 0)
  expect_s3_class(pull_commits_object$committed_date, "POSIXt")
  if (with_stats) {
    expect_type(pull_commits_object$additions, "integer")
    expect_type(pull_commits_object$deletions, "integer")
  }
}

expect_users_table <- function(get_user_object, one_user = FALSE) {
  user_cols <- c(
    "id", "name", "login", "email", "location", "starred_repos",
    "commits", "issues", "pull_requests", "reviews",
    "avatar_url", "web_url"
  )
  expect_named(get_user_object, user_cols)
  if (one_user) {
    expect_equal(nrow(get_user_object), 1)
  } else {
    expect_gt(nrow(get_user_object), 1)
  }
}

expect_files_table <- function(files_object) {
  expect_s3_class(files_object, "data.frame")
  expect_named(
    files_object,
    c("repo_name", "repo_id", "organization",
      "file_path", "file_content", "file_size",
      "repo_url", "api_url")
  )
  expect_type(files_object$file_size, "integer")
  expect_type(files_object$api_url, "character")
  expect_true(
    all(purrr::map_lgl(files_object$api_url, ~ grepl("api", .)))
  )
  expect_gt(nrow(files_object), 0)
}

expect_empty_table <- function(object) {
  expect_s3_class(object, "data.frame")
  expect_equal(nrow(object), 0)
}
