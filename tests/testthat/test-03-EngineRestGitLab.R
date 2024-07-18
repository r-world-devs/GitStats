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

test_that("`map_search_into_repos()` works", {
  gl_search_response <- test_mocker$use("gl_search_response")
  suppressMessages(
    gl_search_repos_by_code <- test_rest_priv$map_search_into_repos(
      gl_search_response
    )
  )
  expect_gl_repos_rest_response(
    gl_search_repos_by_code
  )
  test_mocker$cache(gl_search_repos_by_code)
})

test_that("`pull_repos_languages` works", {
  repos_list <- test_mocker$use("gl_search_repos_by_code")
  repos_list[[1]]$id <- "45300912"
  suppressMessages(
    repos_list_with_languages <- test_rest_priv$pull_repos_languages(
      repos_list = repos_list
    )
  )
  purrr::walk(repos_list_with_languages, ~ expect_list_contains(., "languages"))
})

# public methods

test_rest <- EngineRestGitLab$new(
  rest_api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT_PUBLIC")
)

test_that("`pull_commits_from_repos()` pulls commits from repo", {
  gl_commits_repo_1 <- test_mocker$use("gl_commits_rest_response_repo_1")

  mockery::stub(
    test_rest$pull_commits_from_repos,
    "private$pull_commits_from_one_repo",
    gl_commits_repo_1
  )
  repos_names <- c("mbtests%2Fgitstatstesting", "mbtests%2Fgitstats-testing-2")
  gl_commits_org <- test_rest$pull_commits_from_repos(
    repos_names = repos_names,
    since = "2023-01-01",
    until = "2023-04-20",
    verbose = FALSE
  )
  purrr::walk(gl_commits_org, ~ expect_gl_commit_rest_response(.))
  test_mocker$cache(gl_commits_org)
})

test_that("pull_repos_urls() works", {
  gl_repos_urls <- test_rest$pull_repos_urls(
    type = "api",
    org = "mbtests"
  )
  expect_gt(
    length(gl_repos_urls),
    0
  )
  test_mocker$cache(gl_repos_urls)
})
