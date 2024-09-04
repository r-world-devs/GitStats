# private

test_host <- create_gitlab_testhost(
  orgs = "mbtests",
  mode = "private"
)

test_that("`set_default_token` sets default token for GitLab", {
  expect_snapshot(
    withr::with_envvar(new = c("GITLAB_PAT" = Sys.getenv("GITLAB_PAT_PUBLIC")), {
      default_token <- test_host$set_default_token()
    })
  )
  test_rest <- create_testrest(token = default_token,
                               mode = "private")
  expect_equal(
    test_rest$perform_request(
      endpoint = "https://gitlab.com/api/v4/projects",
      token = default_token
    )$status,
    200
  )
})

test_that("`set_searching_scope` throws error when both `orgs` and `repos` are defined", {
  expect_snapshot_error(
    test_host$set_searching_scope(
      orgs = "mbtests",
      repos = "mbtests/GitStatsTesting"
    )
  )
})

test_that("GitHost adds `repo_api_url` column to GitLab repos table", {
  repos_table <- test_mocker$use("gl_repos_table")
  gl_repos_table_with_api_url <- test_host$add_repo_api_url(repos_table)
  expect_true(all(grepl("gitlab.com/api/v4", gl_repos_table_with_api_url$api_url)))
  test_mocker$cache(gl_repos_table_with_api_url)
})

test_that("`tailor_commits_info()` retrieves only necessary info", {
  gl_commits_list <- test_mocker$use("gl_commits_org")

  gl_commits_list_cut <- test_host$tailor_commits_info(
    gl_commits_list,
    org = "mbtests"
  )
  expect_tailored_commits_list(
    gl_commits_list_cut[[1]][[1]]
  )
  test_mocker$cache(gl_commits_list_cut)
})

test_that("`prepare_commits_table()` prepares table of commits properly", {
  gl_commits_table <- test_host$prepare_commits_table(
    commits_list = test_mocker$use("gl_commits_list_cut")
  )
  expect_commits_table(
    gl_commits_table,
    exp_auth = FALSE
  )
  test_mocker$cache(gl_commits_table)
})

test_that("`get_repo_url_from_response()` works", {
  suppressMessages(
    gl_repo_web_urls <- test_host$get_repo_url_from_response(
      search_response = test_mocker$use("gl_search_response"),
      type = "web"
    )
  )
  expect_gt(length(gl_repo_web_urls), 0)
  expect_type(gl_repo_web_urls, "character")
  test_mocker$cache(gl_repo_web_urls)
})

test_that("get_commits_from_host works", {
  mockery::stub(
    test_host$get_commits_from_host,
    "rest_engine$pull_commits_from_repos",
    test_mocker$use("gl_commits_org")
  )
  suppressMessages(
    gl_commits_table <- test_host$get_commits_from_host(
      since = "2023-03-01",
      until = "2023-04-01",
      settings = test_settings
    )
  )
  expect_commits_table(
    gl_commits_table
  )
  test_mocker$cache(gl_commits_table)
})

test_that("get_files_from_orgs for GitLab works", {
  mockery::stub(
    test_host$get_files_from_orgs,
    "private$prepare_files_table",
    test_mocker$use("gl_files_table")
  )
  suppressMessages(
    gl_files_table <- test_host$get_files_from_orgs(
      file_path = "meta_data.yaml",
      verbose = FALSE
    )
  )
  expect_files_table(
    gl_files_table, with_cols = "api_url"
  )
  test_mocker$cache(gl_files_table)
})

# public

test_host <- create_gitlab_testhost(
  orgs = c("mbtests")
)

test_that("get_commits for GitLab works with repos implied", {
  test_host <- create_gitlab_testhost(
    repos = c("mbtests/gitstatstesting", "mbtests/gitstats-testing-2")
  )
  mockery::stub(
    test_host$get_commits,
    "private$get_commits_from_host",
    test_mocker$use("gl_commits_table")
  )
  expect_snapshot(
    gl_commits_table <- test_host$get_commits(
      since = "2023-01-01",
      until = "2023-06-01",
      settings = test_settings_repo
    )
  )
  expect_commits_table(
    gl_commits_table
  )
})

test_that("get_files_content for GitLab works", {
  mockery::stub(
    test_host$get_files_content,
    "private$get_files_from_orgs",
    test_mocker$use("gl_files_table")
  )
  suppressMessages(
    gl_files_table <- test_host$get_files_content(
      file_path = "meta_data.yaml"
    )
  )
  expect_files_table(
    gl_files_table, with_cols = "api_url"
  )
  test_mocker$cache(gl_files_table)
})

test_that("get_repos_urls returns repositories URLS", {
  mockery::stub(
    test_host$get_repos_urls,
    "private$get_repo_url_from_response",
    test_mocker$use("gl_repo_web_urls")
  )
  gl_repos_urls_with_code_in_files <- test_host$get_repos_urls(
    type = "web",
    with_code = "shiny",
    in_files = "DESCRIPTION",
    verbose = FALSE
  )
  expect_type(gl_repos_urls_with_code_in_files, "character")
  expect_gt(length(gl_repos_urls_with_code_in_files), 0)
  test_mocker$cache(gl_repos_urls_with_code_in_files)
})
