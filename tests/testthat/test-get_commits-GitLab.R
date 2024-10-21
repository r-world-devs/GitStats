test_that("`get_commits_from_repos()` pulls commits from repo", {
  mockery::stub(
    test_rest_gitlab$get_commits_from_repos,
    "private$get_commits_from_one_repo",
    test_fixtures$gitlab_commits_response
  )
  repos_names <- c("mbtests%2Fgitstatstesting", "mbtests%2Fgitstats-testing-2")
  gl_commits_org <- test_rest_gitlab$get_commits_from_repos(
    repos_names = repos_names,
    since       = "2023-01-01",
    until       = "2023-04-20",
    progress    = FALSE
  )
  purrr::walk(gl_commits_org, ~ expect_gl_commit_rest_response(.))
  test_mocker$cache(gl_commits_org)
})

test_that("`tailor_commits_info()` retrieves only necessary info", {
  gl_commits_list <- test_mocker$use("gl_commits_org")

  gl_commits_list_cut <- test_rest_gitlab$tailor_commits_info(
    gl_commits_list,
    org = "mbtests"
  )
  expect_tailored_commits_list(
    gl_commits_list_cut[[1]][[1]]
  )
  test_mocker$cache(gl_commits_list_cut)
})

test_that("`prepare_commits_table()` prepares table of commits properly", {
  gl_commits_table <- test_rest_gitlab$prepare_commits_table(
    commits_list = test_mocker$use("gl_commits_list_cut")
  )
  expect_commits_table(
    gl_commits_table,
    exp_auth = FALSE
  )
  test_mocker$cache(gl_commits_table)
})

test_that("get_authors_dict() prepares dictionary with handles and names", {
  mockery::stub(
    test_rest_gitlab_priv$get_authors_dict,
    "self$response",
    test_fixtures$gitlab_user_search_response
  )
  authors_dict <- test_rest_gitlab_priv$get_authors_dict(
    commits_table = test_mocker$use("gl_commits_table"),
    progress = FALSE
  )
  expect_s3_class(authors_dict, "data.frame")
  expect_true(nrow(authors_dict) > 0)
  expect_length(authors_dict, 3)
  test_mocker$cache(authors_dict)
})

test_that("`get_commits_authors_handles_and_names()` adds author logis and names to commits table", {
  mockery::stub(
    test_rest_gitlab$get_commits_authors_handles_and_names,
    "private$get_authors_dict",
    test_mocker$use("authors_dict")
  )
  gl_commits_table <- test_rest_gitlab$get_commits_authors_handles_and_names(
    commits_table = test_mocker$use("gl_commits_table"),
    verbose = FALSE
  )
  expect_commits_table(
    gl_commits_table,
    exp_auth = TRUE
  )
  test_mocker$cache(gl_commits_table)
})

test_that("get_commits_from_orgs works", {
  mockery::stub(
    gitlab_testhost_priv$get_commits_from_orgs,
    "rest_engine$get_commits_authors_handles_and_names",
    test_mocker$use("gl_commits_table")
  )
  suppressMessages(
    gl_commits_table <- gitlab_testhost_priv$get_commits_from_orgs(
      since    = "2023-03-01",
      until    = "2023-04-01",
      verbose  = FALSE,
      progress = FALSE
    )
  )
  expect_commits_table(
    gl_commits_table
  )
  test_mocker$cache(gl_commits_table)
})

test_that("get_commits for GitLab works with repos implied", {
  mockery::stub(
    gitlab_testhost_repos$get_commits,
    "private$get_commits_from_orgs",
    test_mocker$use("gl_commits_table")
  )
  gl_commits_table <- gitlab_testhost_repos$get_commits(
    since   = "2023-01-01",
    until   = "2023-06-01",
    verbose = FALSE
  )
  expect_commits_table(
    gl_commits_table
  )
})
