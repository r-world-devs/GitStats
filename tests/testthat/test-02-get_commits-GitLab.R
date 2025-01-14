test_that("`get_commits_from_one_repo()` pulls commits from repository", {
  mockery::stub(
    test_rest_gitlab_priv$get_commits_from_one_repo,
    "private$paginate_results",
    test_fixtures$gitlab_commits_response
  )
  gl_commits_repo <- test_rest_gitlab_priv$get_commits_from_one_repo(
    repo_path = "TestRepo",
    since     = "2023-01-01",
    until     = "2023-04-20"
  )
  expect_gt(length(gl_commits_repo), 1)
  purrr::walk(gl_commits_repo, ~ expect_gl_commit_rest_response(.))
  test_mocker$cache(gl_commits_repo)
})

test_that("`get_commits_from_repos()` pulls commits from repositories", {
  mockery::stub(
    test_rest_gitlab$get_commits_from_repos,
    "private$get_commits_from_one_repo",
    test_mocker$use("gl_commits_repo")
  )
  repos_names <- c("test_org/TestRepo1", "test_org/TestRepo2")
  gl_commits_org <- test_rest_gitlab$get_commits_from_repos(
    repos_names = repos_names,
    since       = "2023-01-01",
    until       = "2023-04-20",
    progress    = FALSE
  )
  expect_equal(names(gl_commits_org), c("test_org/TestRepo1", "test_org/TestRepo2"))
  purrr::walk(gl_commits_org[[1]], ~ expect_gl_commit_rest_response(.))
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

test_authors_dict <- data.frame(
  author = c("TestFamily, TestName {TestID}", "TestName TestFamily", "testlogin"),
  author_login = rep(NA, 3),
  author_name = rep(NA, 3)
)

test_that("clean_authors_with_comma parses properly authors data", {
  test_authors_dict <- test_rest_gitlab_priv$clean_authors_with_comma(test_authors_dict)
  expect_equal(
    test_authors_dict$author_name[test_authors_dict$author == "TestFamily, TestName {TestID}"],
    "TestName TestFamily"
  )
  test_mocker$cache(test_authors_dict)
})

test_that("fill_empty_authors fills properly authors data", {
  test_authors_dict <- test_rest_gitlab_priv$fill_empty_authors(
    authors_dict = test_mocker$use("test_authors_dict")
  )
  expect_equal(
    test_authors_dict$author_name[test_authors_dict$author == "TestName TestFamily"],
    "TestName TestFamily"
  )
  expect_equal(
    test_authors_dict$author_login[test_authors_dict$author == "testlogin"],
    "testlogin"
  )
  test_mocker$cache(test_authors_dict)
})

test_that("clean_authors_dict", {
  test_authors_dict <- test_rest_gitlab_priv$clean_authors_dict(
    authors_dict = test_authors_dict
  )
  expect_equal(
    test_authors_dict$author_name[test_authors_dict$author == "TestFamily, TestName {TestID}"],
    "TestName TestFamily"
  )
  expect_equal(
    test_authors_dict$author_name[test_authors_dict$author == "TestName TestFamily"],
    "TestName TestFamily"
  )
  expect_equal(
    test_authors_dict$author_login[test_authors_dict$author == "testlogin"],
    "testlogin"
  )
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
  expect_snapshot(
    gl_commits_table <- gitlab_testhost_priv$get_commits_from_orgs(
      since    = "2023-03-01",
      until    = "2023-04-01",
      verbose  = TRUE,
      progress = FALSE
    )
  )
  expect_commits_table(
    gl_commits_table
  )
  test_mocker$cache(gl_commits_table)
})

test_that("get_commits_from_repos works", {
  gitlab_testhost_priv <- create_gitlab_testhost(
    repos = "TestRepo",
    mode = "private"
  )
  test_org <- "test_org"
  attr(test_org, "type") <- "organization"
  mockery::stub(
    gitlab_testhost_priv$get_repos_from_repos,
    "graphql_engine$set_owner_type",
    test_org
  )
  mockery::stub(
    gitlab_testhost_priv$get_commits_from_repos,
    "rest_engine$get_commits_authors_handles_and_names",
    test_mocker$use("gl_commits_table")
  )
  gitlab_testhost_priv$searching_scope <- "repo"
  gitlab_testhost_priv$orgs_repos <- list("test_org" = "TestRepo")
  expect_snapshot(
    gl_commits_table <- gitlab_testhost_priv$get_commits_from_repos(
      since    = "2023-03-01",
      until    = "2023-04-01",
      verbose  = TRUE,
      progress = FALSE
    )
  )
  expect_commits_table(
    gl_commits_table
  )
})
