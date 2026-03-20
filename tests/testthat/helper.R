#' Create GitStats object for tests
create_test_gitstats <- function(hosts = 0,
                                 priv_mode = FALSE,
                                 test_mocker = NULL,
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
  storage <- test_gitstats$.__enclos_env__$private$storage_backend
  if (!is.null(inject_repos)) {
    storage$save("repositories", test_mocker$use(inject_repos))
  }
  if (!is.null(inject_commits)) {
    storage$save("commits", test_mocker$use(inject_commits))
  }
  if (!is.null(inject_files)) {
    storage$save("files", test_mocker$use(inject_files))
  }
  if (!is.null(inject_files_structure)) {
    storage$save("files_structure", test_mocker$use(inject_files_structure))
  }
  if (!is.null(inject_users)) {
    storage$save("users", test_mocker$use(inject_users))
  }
  if (!is.null(inject_package_usage)) {
    storage$save("R_package_usage", test_mocker$use(inject_package_usage))
  }
  if (priv_mode) {
    test_gitstats <- environment(test_gitstats$print)$private
  }
  return(test_gitstats)
}
