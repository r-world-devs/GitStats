repo_gitstats_colnames <- c(
  "repo_id", "repo_name", "organization", "fullname", "platform", "repo_url", "api_url",
  "created_at", "last_activity_at", "last_activity", "default_branch", "stars", "forks",
  "languages", "issues_open", "issues_closed"
)

repo_host_colnames <- c("repo_id", "repo_name", "default_branch", "stars", "forks",
                        "created_at", "last_activity_at", "languages", "issues_open",
                        "issues_closed", "organization", "repo_url")

repo_min_colnames <- c("repo_id", "repo_name", "default_branch",
                       "created_at", "organization", "repo_url")

expect_package_usage_table <- function(object, with_cols = NULL) {
  expect_s3_class(object, "data.frame")
  expect_named(object, c("package", "package_usage", "repo_id", "repo_fullname", "repo_name", "organization", "fullname", "platform", "repo_url", "api_url", "created_at", "last_activity_at", "last_activity", "default_branch", "stars", "forks", "languages", "issues_open", "issues_closed", "contributors", "contributors_n"))
  expect_gt(nrow(object), 0)
}

expect_orgs_table <- function(object, add_cols = NULL) {
  expect_s3_class(object, "data.frame")
  expect_named(object, c("name", "description", "path", "url", "avatar_url",
                         "repos_count", "members_count", add_cols))
  expect_gt(nrow(object), 0)
}

expect_repos_table_object <- function(repos_object, with_cols = NULL) {
  expect_repos_table(
    repos_object = repos_object,
    repo_cols = c(repo_gitstats_colnames, with_cols)
  )
  expect_s3_class(repos_object, "repos_table")
}

expect_repos_table <- function(repos_object, repo_cols = repo_host_colnames, with_cols = NULL) {
  repo_cols <- c(
    repo_cols, with_cols
  )
  expect_s3_class(repos_object, "data.frame")
  expect_named(repos_object, repo_cols)
  expect_gt(nrow(repos_object), 0)
}

expect_issues_table <- function(get_issues_object, with_stats = TRUE, exp_author = TRUE) {
  issue_cols <- c("number", "title", "description", "created_at", "closed_at", "state", "url",
                  "author", "repository", "organization", "api_url")

  expect_s3_class(get_issues_object, "data.frame")
  expect_named(get_issues_object, issue_cols)
  expect_gt(nrow(get_issues_object), 0)
  expect_s3_class(get_issues_object$created_at, "POSIXt")
  expect_s3_class(get_issues_object$closed_at, "POSIXt")
}


expect_commits_table <- function(get_commits_object, with_stats = TRUE, exp_author = TRUE) {
  commit_cols <- if (exp_author) {
    c(
      "id", "committed_date", "author", "author_login", "author_name", "additions", "deletions",
      "repository", "organization", "repo_url", "api_url"
    )
  } else {
    c(
      "id", "committed_date", "author", "additions", "deletions",
      "repository", "organization", "repo_url", "api_url"
    )
  }
  expect_s3_class(get_commits_object, "data.frame")
  expect_named(get_commits_object, commit_cols)
  expect_gt(nrow(get_commits_object), 0)
  expect_s3_class(get_commits_object$committed_date, "POSIXt")
  if (with_stats) {
    expect_type(get_commits_object$additions, "integer")
    expect_type(get_commits_object$deletions, "integer")
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

expect_files_table <- function(files_object, with_cols = NULL) {
  expect_s3_class(files_object, "data.frame")
  expect_named(
    files_object,
    c("repo_name", "repo_id", "organization",
      "file_path", "file_content", "file_size",
      "repo_url", with_cols)
  )
  expect_type(files_object$file_size, "integer")
  expect_gt(nrow(files_object), 0)
}

expect_releases_table <- function(releases_object) {
  expect_s3_class(releases_object, "data.frame")
  expect_named(
    releases_object,
    c("repo_name", "repo_url",
      "release_name", "release_tag", "published_at", "release_url",
      "release_log")
  )
  expect_gt(nrow(releases_object), 0)
}

expect_empty_table <- function(object) {
  expect_s3_class(object, "data.frame")
  expect_equal(nrow(object), 0)
}
