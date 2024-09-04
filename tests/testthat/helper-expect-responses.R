expect_gl_search_response <- function(object) {
  expect_type(
    object,
    "list"
  )
  purrr::walk(object, ~ {
    expect_list_contains(
      .,
      c("basename", "data", "path", "filename", "id", "ref", "startline", "project_id")
    )
  })
}

expect_gh_search_response <- function(object) {
  expect_type(
    object,
    "list"
  )
  purrr::walk(object, ~ {
    expect_list_contains(
      .,
      c("name", "path", "sha", "url", "git_url", "html_url", "repository", "score")
    )
  })
}

expect_gl_repos_rest_response <- function(object) {
  expect_type(
    object,
    "list"
  )
  purrr::walk(object, ~ {
    expect_list_contains(
      .,
      c("id", "description", "name", "name_with_namespace", "path")
    )
  })
}

expect_gh_repos_rest_response <- function(object) {
  expect_type(
    object,
    "list"
  )
  purrr::walk(object, ~ {
    expect_list_contains(
      .,
      c("id", "node_id", "name", "full_name")
    )
  })
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

expect_gh_repos_gql_response <- function(object) {
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

expect_gl_commit_rest_response <- function(object) {
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

expect_gh_commit_gql_response <- function(object) {
  expect_type(
    object,
    "list"
  )
  expect_list_contains(
    object$node,
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

expect_github_files_raw_response <- function(object) {
  purrr::walk(object$data$repository$object$entries, function(entry) {
    expect_list_contains(
      entry,
      c("name", "type")
    )
  })
}

expect_github_files_response <- function(object) {
  expect_type(
    object,
    "list"
  )
  expect_gt(
    length(object[[1]]),
    0
  )
  purrr::walk(object, function(file_path) {
    purrr::walk(file_path, function(repository) {
      expect_list_contains(
        repository,
        c("name", "id", "object")
      )
      expect_list_contains(
        repository$object,
        c("text", "byteSize")
      )
    })
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

expect_github_releases_response <- function(object) {
  expect_type(
    object,
    "list"
  )
  purrr::walk(object, function(response) {
    expect_gt(length(response), 0)
    expect_list_contains(
      response$data$repository,
      c("releases")
    )
    purrr::walk(response$data$repository$releases$nodes, function(node) {
      expect_list_contains(
        node,
        c("name", "tagName", "publishedAt", "url", "description")
      )
    })
  })
}
