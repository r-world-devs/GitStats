create_test_gitstats <- function(
    hosts = 0,
    priv_mode = FALSE,
    inject_repos = NULL,
    inject_commits = NULL
  ) {
  test_gitstats <- create_gitstats() %>%
    set_params(print_out = FALSE)

  if (hosts == 1) {
    suppressMessages({
      test_gitstats$set_host(
        api_url = "https://api.github.com",
        token = Sys.getenv("GITHUB_PAT"),
        orgs = c("r-world-devs", "openpharma")
      )
    })
  } else if (hosts == 2) {
    suppressMessages({
      test_gitstats$set_host(
        api_url = "https://api.github.com",
        token = Sys.getenv("GITHUB_PAT"),
        orgs = c("r-world-devs", "openpharma")
      )
      test_gitstats$set_host(
        api_url = "https://gitlab.com/api/v4",
        token = Sys.getenv("GITLAB_PAT_PUBLIC"),
        orgs = "mbtests"
      )
    })
  }
  if (!is.null(inject_repos)) {
    test_gitstats$.__enclos_env__$private$repos <- test_mocker$use(inject_repos)
  }
  if (!is.null(inject_commits)) {
    test_gitstats$.__enclos_env__$private$commits <- test_mocker$use(inject_commits)
  }
  if (priv_mode) {
    test_gitstats <- environment(test_gitstats$set_params)$private
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
