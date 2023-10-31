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
      "id", "name", "createdAt", "starCount", "forksCount"
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

expect_user_table <- function(get_user_object) {
  user_cols <- c(
    "id", "name", "login", "email", "location", "starred_repos",
    "commits", "issues", "pull_requests", "reviews",
    "avatar_url", "web_url"
  )
  expect_named(get_user_object, user_cols)
  expect_equal(nrow(get_user_object), 1)
}

expect_users_table <- function(get_user_object) {
  user_cols <- c(
    "id", "name", "login", "email", "location", "starred_repos",
    "commits", "issues", "pull_requests", "reviews",
    "avatar_url", "web_url"
  )
  expect_named(get_user_object, user_cols)
  expect_gt(nrow(get_user_object), 1)
}

repo_table_colnames <- c(
  "id", "name", "stars", "forks", "created_at",
  "last_activity_at", "languages", "issues_open", "issues_closed",
  "organization", "repo_url"
)

expect_repos_table_with_contributors <- function(pull_repos_object) {
  repo_cols <- c(
    repo_table_colnames, "contributors"
  )
  expect_s3_class(pull_repos_object, "data.frame")
  expect_named(pull_repos_object, repo_cols)
  expect_gt(nrow(pull_repos_object), 0)
}

expect_repos_table_with_api_url <- function(pull_repos_object) {
  repo_cols <- c(
    repo_table_colnames, "api_url"
  )
  expect_s3_class(pull_repos_object, "data.frame")
  expect_named(pull_repos_object, repo_cols)
  expect_gt(nrow(pull_repos_object), 0)
}

expect_repos_table <- function(pull_repos_object) {
  expect_s3_class(pull_repos_object, "data.frame")
  expect_named(pull_repos_object, repo_table_colnames)
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

expect_empty_table <- function(object) {
  expect_s3_class(object, "data.frame")
  expect_equal(nrow(object), 0)
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
      c(
        "name", "object"
      )
    )
    expect_list_contains(
      repository$object,
      c(
        "text", "byteSize"
      )
    )
  })
}
