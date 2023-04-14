expect_gh_repos_list <- function(object) {
  expect_list_contains(object,
  c("name", "path", "sha", "url", "git_url", "html_url", "repository", "score"))
}

expect_list_contains <- function(object, elements, level = 1) {
  act <- quasi_label(rlang::enquo(object), arg = "object")
  if (level == 1) {
    act$check <- any(elements %in% names(act$val))
  }
  if (level == 2) {
    act$check <- all(purrr::map_lgl(act$val, ~ any(elements %in% names(.))))
  }
  expect(
    act$check == TRUE,
    sprintf("%s does not contain specified elements", act$lab)
  )

  invisible(act$val)
}

expect_list_contains_only <- function(object, elements) {
  act <- quasi_label(rlang::enquo(object), arg = "object")

  act$check <- all(purrr::map_lgl(act$val, ~ all(elements %in% names(.))))
  expect(
    act$check == TRUE,
    sprintf("%s does not contain specified elements", act$lab)
  )

  invisible(act$val)
}

expect_repos_table <- function(get_repos_object) {
  repo_cols <- c('id', 'name', 'stars', 'forks', 'created_at', 'last_push',
                 'last_activity_at', 'languages', 'issues_open', 'issues_closed',
                 'contributors', 'organization', 'api_url', 'repo_url')
  expect_s3_class(get_repos_object, "data.frame")
  expect_named(get_repos_object, repo_cols)
  expect_gt(nrow(get_repos_object), 0)
}

expect_commits_table <- function(get_commits_object) {
  commit_cols <- c('id', 'committed_date', 'author', 'additions', 'deletions',
                   'repository', 'organization', 'api_url')
  expect_s3_class(get_commits_object, "data.frame")
  expect_named(get_commits_object, commit_cols)
  expect_gt(nrow(get_commits_object), 0)
  expect_s3_class(get_commits_object$committed_date, "POSIXt")
  expect_type(get_commits_object$additions, "integer")
  expect_type(get_commits_object$deletions, "integer")
}

expect_empty_table <- function(object) {
  expect_s3_class(object, "data.frame")
  expect_equal(nrow(object), 0)
}
