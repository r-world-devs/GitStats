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
  expect_list_contains(
    object[[1]],
    c("name", "path", "sha", "url", "git_url", "html_url", "repository", "score")
  )
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

expect_gl_repos_gql_response <- function(object, type = "organization") {
  expect_type(
    object,
    "list"
  )
  repo_node <- if (type == "organization") {
    object$data$group$projects$edges[[1]]$node
  } else {
    object$data$projects$edges[[1]]$node
  }
  expect_list_contains(
    repo_node,
    c(
      "id", "name", "repository", "stars", "forks", "created_at", "last_activity_at"
    )
  )
}

expect_gh_repos_gql_response <- function(repo_node) {
  expect_true(
    all(
      colnames(repo_node) %in% c("repo_id", "repo_name", "stars", "forks", "created_at",
                                 "last_activity_at", "languages", "issues_open",
                                 "issues_closed", "repo_url")
    )
  )
}

expect_gl_commit_rest_response <- function(object) {
  expect_type(
    object,
    "list"
  )
  expect_list_contains(
    object,
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
    c("id", "committed_date", "author", "additions", "deletions", "repository")
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
    expect_equal(
      names(entry),
      c("name", "type")
    )
  })
}

expect_gitlab_files_blob_response <- function(object) {
  purrr::walk(object$data$project$repository$blobs$nodes, function(node) {
    expect_equal(
      names(node),
      c("path", "rawBlob", "size")
    )
  })
}

expect_gitlab_files_tree_response <- function(object) {
  purrr::walk(object$data$project$repository$tree$blobs$nodes, function(node) {
    expect_equal(
      names(node),
      c("name")
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
  purrr::walk(object, function(repository) {
    purrr::walk(repository, function(file_path) {
      expect_list_contains(
        file_path,
        c("repo_name", "repo_id", "repo_url", "object")
      )
      expect_list_contains(
        file_path$file,
        c("text", "byteSize")
      )
    })
  })
}

expect_gitlab_files_from_org_response <- function(object) {
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
        "path", "id", "repository"
      )
    )
    expect_list_contains(
      project$repository$blobs$nodes[[1]],
      c(
        "path", "rawBlob", "size"
      )
    )
  })
}

expect_gitlab_files_from_org_by_repos_response <- function(response, expected_files) {
  expect_type(
    response,
    "list"
  )
  expect_gt(
    length(response),
    0
  )
  purrr::walk(response, function(repo) {
    purrr::walk(repo$data$project$repository$blobs$nodes, function(file) {
      expect_equal(
        names(file),
        c("path", "rawBlob", "size")
      )
    })
  })
  files_vec <- purrr::map(response, ~ purrr::map_vec(.$data$project$repository$blobs$nodes, ~ .$path)) %>%
    unlist() %>%
    unique()
  expect_true(
    all(expected_files %in% files_vec)
  )
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

expect_gitlab_releases_response <- function(object) {
  expect_type(
    object,
    "list"
  )
  purrr::walk(object, function(response) {
    expect_gt(length(response), 0)
    expect_list_contains(
      response$data$project,
      c("releases")
    )
    purrr::walk(response$data$project$releases$nodes, function(node) {
      expect_list_contains(
        node,
        c("name", "tagName", "releasedAt", "links", "description")
      )
    })
  })
}

issue_fields <- c("number", "title", "description", "created_at", "closed_at",
                  "state", "url", "author")

expect_github_issues_page <- function(object) {
  expect_type(
    object,
    "list"
  )
  if (names(object) == "errors") {
    cli::cli_alert_danger(object$errors)
    cli::cli_abort("Errors in GraphQL response.")
  }
  expect_named(
    object$data$repository$issues,
    c("pageInfo", "edges")
  )
  expect_named(
    object$data$repository$issues$edges[[1]]$node,
    issue_fields
  )
}

expect_gitlab_issues_page <- function(object) {
  expect_type(
    object,
    "list"
  )
  if (names(object) == "errors") {
    cli::cli_alert_danger(object$errors)
    cli::cli_abort("Errors in GraphQL response.")
  }
  expect_named(
    object$data$project$issues,
    c("pageInfo", "edges")
  )
  expect_named(
    object$data$project$issues$edges[[1]]$node,
    issue_fields
  )
}

expect_issues_full_list <- function(object) {
  expect_named(
    object[[1]]$node,
    issue_fields
  )
}

github_orgs_fields <- c("name", "description", "login", "url", "repositories",
                        "membersWithRole", "avatarUrl")

expect_github_orgs_full_list <- function(object) {
  expect_named(
    object[[1]],
    github_orgs_fields
  )
}

gitlab_orgs_fields <- c("name", "description", "fullPath", "webUrl", "projectsCount",
                        "groupMembersCount", "avatarUrl")

expect_gitlab_orgs_full_list <- function(object) {
  expect_named(
    object[[1]],
    gitlab_orgs_fields
  )
}
