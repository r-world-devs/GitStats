expect_repos_table <- function(get_repos_object){
  repo_cols <- c("organisation", "name", "created_at", "last_activity_at", "description", "api_url")
  expect_s3_class(get_repos_object, "data.frame")
  expect_named(get_repos_object, repo_cols)
  expect_gt(nrow(get_repos_object), 0)
}

expect_empty_table <- function(object){
  expect_s3_class(object, "data.frame")
  expect_length(object, 0)
}
