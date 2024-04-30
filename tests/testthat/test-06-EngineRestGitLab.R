test_rest <- EngineRestGitLab$new(
  rest_api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT_PUBLIC")
)

test_that("`pull_repos_issues()` adds issues to repos table", {
  gl_repos_by_code_table <- test_mocker$use("gl_repos_by_code_table")
  suppressMessages(
    gl_repos_by_code_table <- test_rest$pull_repos_issues(
      gl_repos_by_code_table
    )
  )
  expect_gt(
    length(gl_repos_by_code_table$issues_open),
    0
  )
  expect_gt(
    length(gl_repos_by_code_table$issues_closed),
    0
  )
  test_mocker$cache(gl_repos_by_code_table)
})

test_that("`pull_repos_contributors()` adds contributors to repos table", {
  expect_snapshot(
    gl_repos_table_with_contributors <- test_rest$pull_repos_contributors(
      test_mocker$use("gl_repos_table_with_api_url"),
      settings = test_settings
    )
  )
  expect_repos_table(
    gl_repos_table_with_contributors,
    add_col = c("api_url", "contributors")
  )
  expect_gt(
    length(gl_repos_table_with_contributors$contributors),
    0
  )
  test_mocker$cache(gl_repos_table_with_contributors)
})

test_that("`get_commits_authors_handles_and_names()` adds author logis and names to commits table", {
  expect_snapshot(
    gl_commits_table <- test_rest$get_commits_authors_handles_and_names(
      commits_table = test_mocker$use("gl_commits_table"),
      verbose = TRUE
    )
  )
  expect_commits_table(
    gl_commits_table,
    exp_auth = TRUE
  )
  test_mocker$cache(gl_commits_table)
})
