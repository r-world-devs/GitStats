#' Create GitStats object for tests
create_test_gitstats <- function(hosts = 0,
                                 priv_mode = FALSE,
                                 inject_repos = NULL,
                                 inject_commits = NULL,
                                 inject_files = NULL,
                                 inject_files_structure = NULL,
                                 inject_users = NULL,
                                 inject_package_usage = NULL) {
  test_gitstats <- create_gitstats()
  if (hosts == 1) {
    test_gitstats$.__enclos_env__$private$hosts[[1]] <- create_github_testhost(
      orgs = "test_org"
    )
  } else if (hosts == 2) {
    test_gitstats$.__enclos_env__$private$hosts[[1]] <- create_github_testhost(
      orgs = "github_test_org"
    )
    test_gitstats$.__enclos_env__$private$hosts[[2]] <- create_gitlab_testhost(
      orgs = "gitlab_test_group"
    )
  }
  if (!is.null(inject_repos)) {
    test_gitstats$.__enclos_env__$private$storage$repositories <- test_mocker$use(inject_repos)
  }
  if (!is.null(inject_commits)) {
    test_gitstats$.__enclos_env__$private$storage$commits <- test_mocker$use(inject_commits)
  }
  if (!is.null(inject_files)) {
    test_gitstats$.__enclos_env__$private$storage$files <- test_mocker$use(inject_files)
  }
  if (!is.null(inject_files_structure)) {
    test_gitstats$.__enclos_env__$private$storage$files_structure <- test_mocker$use(inject_files_structure)
  }
  if (!is.null(inject_users)) {
    test_gitstats$.__enclos_env__$private$storage$users <- test_mocker$use(inject_users)
  }
  if (!is.null(inject_package_usage)) {
    test_gitstats$.__enclos_env__$private$storage$R_package_usage <- test_mocker$use(inject_package_usage)
  }
  if (priv_mode) {
    test_gitstats <- environment(test_gitstats$print)$private
  }
  return(test_gitstats)
}

expect_tailored_commits_list <- function(object) {
  expect_list_contains_only(
    object,
    c(
      "id", "organization", "repository", "additions", "deletions",
      "committed_date", "author"
    )
  )
}

expect_list_contains <- function(object, elements) {
  act <- quasi_label(rlang::enquo(object), arg = "object")
  act$check <- any(elements %in% names(act$val))
  expect(
    act$check == TRUE,
    sprintf("%s does not contain specified elements", act$lab)
  )

  invisible(act$val)
}

expect_list_contains_only <- function(object, elements) {
  act <- quasi_label(rlang::enquo(object), arg = "object")
  act$check <- all(elements %in% names(act$val))
  expect(
    act$check == TRUE,
    sprintf("%s does not contain specified elements", act$lab)
  )

  invisible(act$val)
}
