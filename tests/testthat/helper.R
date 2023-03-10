expect_list_contains <- function(object, elements) {
  act <- quasi_label(rlang::enquo(object), arg = "object")

  act$check <- all(purrr::map_lgl(act$val, ~ any(elements %in% names(.))))
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
  repo_cols <- c("organisation", "name", "created_at", "last_activity_at", "forks", "stars", "contributors", "issues", "issues_open", "issues_closed", "description", "api_url")
  expect_s3_class(get_repos_object, "data.frame")
  expect_named(get_repos_object, repo_cols)
  expect_gt(nrow(get_repos_object), 0)
}

expect_commits_table <- function(get_commits_object) {
  commit_cols <- c("id", "organisation", "repository", "committed_date", "additions", "deletions", "api_url")
  expect_s3_class(get_commits_object, "data.frame")
  expect_named(get_commits_object, commit_cols)
  expect_gt(nrow(get_commits_object), 0)
  expect_s3_class(get_commits_object$committed_date, "POSIXt")
  expect_type(get_commits_object$additions, "integer")
  expect_type(get_commits_object$deletions, "integer")
}

expect_empty_table <- function(object) {
  expect_s3_class(object, "data.frame")
  expect_length(object, 0)
}

TestClient <- R6::R6Class("TestClient",
                          inherit = GitService,
                          public = list(
                            rest_api_url = NULL,
                            orgs = NULL,
                            initialize  = function(rest_api_url = NA,
                                                   token = NA,
                                                   orgs = NA){
                              self$rest_api_url <- rest_api_url
                              private$token <- token
                              self$orgs <- orgs
                            }
                          ),
                          private = list(
                            token = NULL
                          ))
