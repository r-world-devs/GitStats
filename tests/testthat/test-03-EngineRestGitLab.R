test_rest <- EngineRestGitLab$new(
  rest_api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT_PUBLIC")
)

# private methods

test_rest_priv <- environment(test_rest$initialize)$private

test_that("`get_group_id()` gets group's id", {
  gl_group_id <- test_rest_priv$get_group_id("mbtests")
  expect_equal(gl_group_id, 63684059)
})
