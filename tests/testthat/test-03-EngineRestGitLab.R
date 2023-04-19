test_rest <- EngineRestGitLab$new(
  rest_api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT_PUBLIC")
)

# private methods

test_rest_priv <- environment(test_rest$initialize)$private

test_that("`get_group_id()` gets group's id", {
  expect_equal(test_rest_priv$get_group_id("mbtests"), 63684059)
})

# public methods

test_that("'get_repos_contributors' adds contributors to repos table", {

  gl_repos_table <- test_rest$get_repos_contributors(
    test_mock$mocker$gl_repos_table
  )
  expect_gt(
    length(gl_repos_table$contributors),
    0
  )
  test_mock$mock(gl_repos_table)
})
