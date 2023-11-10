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

expect_gl_repos <- function(object) {
  expect_type(
    object,
    "list"
  )
  expect_list_contains(
    object[[1]],
    c(
      "id", "description", "name", "name_with_namespace", "path"
    )
  )
}

expect_gl_repos_gql_response <- function(object) {
  expect_type(
    object,
    "list"
  )
  expect_list_contains(
    object$data$group$projects$edges[[1]]$node,
    c(
      "id", "name", "repository", "stars", "forks", "created_at", "last_activity_at"
    )
  )
}

expect_gh_repos <- function(object) {
  expect_type(
    object,
    "list"
  )
  expect_list_contains(
    object,
    "data"
  )
  expect_list_contains(
    object$data$repositoryOwner$repositories$nodes[[1]],
    c(
      "id", "name", "stars", "forks", "created_at",
      "last_activity_at", "languages", "issues_open", "issues_closed",
      "repo_url"
    )
  )
}

expect_gh_user_repos <- function(object) {
  expect_type(
    object,
    "list"
  )
  expect_list_contains(
    object,
    "data"
  )
  expect_list_contains(
    object$data$user$repositories$nodes[[1]],
    c(
      "id", "name", "stars", "forks", "created_at",
      "last_activity_at", "languages", "issues_open", "issues_closed",
      "repo_url"
    )
  )
}

expect_gl_commit_rest <- function(object) {
  expect_type(
    object,
    "list"
  )
  expect_list_contains(
    object[[1]],
    c(
      "id", "short_id", "created_at", "parent_ids", "title", "message",
      "author_name", "author_email", "authored_date", "committer_name",
      "committer_email"
    )
  )
}

expect_gh_commit_rest <- function(object) {
  expect_type(
    object,
    "list"
  )
  expect_gt(
    length(object),
    0
  )
  expect_list_contains(object[[1]],
                       c("sha", "node_id", "commit", "url",
                         "html_url", "comments_url", "author",
                         "committer", "parents"))
}

expect_gh_commit_gql <- function(object) {
  expect_type(
    object,
    "list"
  )
  expect_list_contains(
    object,
    "data"
  )
  expect_list_contains(
    object$data$repository$defaultBranchRef$target$history$edges[[1]]$node,
    c("id", "committed_date", "author", "additions", "deletions")
  )
}

expect_user_gql_response <- function(object) {
  expect_list_contains(
    object,
    "data"
  )
  expect_list_contains(
    object$data,
    "user"
  )
  expect_list_contains(
    object$data$user,
    c("id", "name", "email", "location", "starred_repos", "avatar_url", "web_url")
  )
}

expect_gl_search_response <- function(object) {
  expect_list_contains(
    object,
    c("basename", "data", "path", "filename", "id", "ref", "startline", "project_id")
  )
}

expect_gh_search_response <- function(object) {
  expect_list_contains(
    object,
    c("name", "path", "sha", "url", "git_url", "html_url", "repository", "score")
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

expect_github_files_response <- function(object) {
  expect_type(
    object,
    "list"
  )
  expect_gt(
    length(object),
    0
  )
  purrr::walk(object, function(repository) {
    expect_list_contains(
      repository,
      c("name", "id", "object")
    )
    expect_list_contains(
      repository$object,
      c("text", "byteSize")
    )
  })
}

expect_gitlab_files_response <- function(object) {
  expect_type(
    object,
    "list"
  )
  expect_gt(
    length(object),
    0
  )
  purrr::walk(object, function(project) {
    expect_list_contains(
      project,
      c(
        "name", "id", "repository"
      )
    )
    expect_list_contains(
      project$repository$blobs$nodes[[1]],
      c(
        "name", "rawBlob", "size"
      )
    )
  })
}
