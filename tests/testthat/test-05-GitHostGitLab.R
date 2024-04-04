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

test_that("`check_orgs_and_repos` throws error when both `orgs` and `repos` are defined", {
  expect_snapshot_error(
    test_host$check_orgs_and_repos(
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

test_that("GitHost filters GitLab repositories' (pulled by org) table by languages", {
  gl_repos_table <- test_mocker$use("gl_repos_table")
  expect_snapshot(
    result <- test_host$filter_repos_by_language(
      gl_repos_table,
      language = "Python"
    )
  )
  expect_length(
    result,
    length(gl_repos_table)
  )
  expect_gt(
    nrow(result),
    0
  )
  expect_true(
    all(grepl("Python", result$languages))
  )
})

test_that("GitHost filters GitLab repositories' (pulled by team) table by languages", {
  repos_table <- test_mocker$use("gl_repos_table_team")
  expect_snapshot(
    result <- test_host$filter_repos_by_language(
      repos_table,
      language = "Python"
    )
  )
  expect_length(
    result,
    length(repos_table)
  )
  expect_gt(
    nrow(result),
    0
  )
  expect_true(
    all(grepl("Python", result$languages))
  )
})

test_host <- create_gitlab_testhost(
  orgs = c("mbtests")
)

test_that("pull_repos_contributors returns table with contributors for GitLab", {
  repos_table_1 <- test_mocker$use("gl_repos_table_with_api_url")
  expect_snapshot(
    repos_table_2 <- test_host$pull_repos_contributors(repos_table_1,
                                                          test_settings)
  )
  expect_gt(
    length(repos_table_2$contributors),
    0
  )
  expect_equal(nrow(repos_table_1), nrow(repos_table_2))
})

test_that("pull_commits throws error when search param is set to `phrase`", {
  test_settings[["search_param"]] <- "phrase"
  expect_snapshot_error(
    test_host$pull_commits(
      date_from = "2023-03-01",
      date_until = "2023-04-01",
      settings = test_settings
    )
  )
})

test_that("pull_commits for GitLab works", {
  suppressMessages(
    gl_commits_table <- test_host$pull_commits(
      since = "2023-03-01",
      until = "2023-04-01",
      settings = test_settings
    )
  )
  expect_commits_table(
    gl_commits_table
  )
})

test_that("pull_commits for GitLab works with repos implied", {
  test_host <- create_gitlab_testhost(
    repos = c("mbtests/gitstatstesting", "mbtests/gitstats-testing-2")
  )
  expect_snapshot(
    gl_commits_table <- test_host$pull_commits(
      since = "2023-01-01",
      until = "2023-06-01",
      settings = test_settings_repo
    )
  )
  expect_commits_table(
    gl_commits_table
  )
})

test_that("pull_files for GitLab works", {
  suppressMessages(
    gl_files_table <- test_host$pull_files(
      file_path = "meta_data.yaml",
      settings = test_settings
    )
  )
  expect_files_table(
    gl_files_table
  )
})
