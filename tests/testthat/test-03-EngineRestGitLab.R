test_rest <- EngineRestGitLab$new(rest_api_url = "https://gitlab.com/api/v4",
                                  token = Sys.getenv("GITLAB_PAT_PUBLIC"))

# private methods

test_rest_priv <- environment(test_rest$initialize)$private

test_that("`get_group_id()` gets group's id", {
  expect_equal(test_rest_priv$get_group_id("mbtests"), 63684059)
})
