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

test_that("`find_repos_by_id()` works", {
  gl_search_response <- test_mocker$use("gl_search_response")
  gl_search_repos_by_code <- test_rest_priv$find_repos_by_id(
    gl_search_response
  )
  expect_gl_repos_rest_response(
    gl_search_repos_by_code
  )
  test_mocker$cache(gl_search_repos_by_code)
})

test_that("`pull_repos_languages` works", {
  repos_list <- test_mocker$use("gl_search_repos_by_code")
  repos_list[[1]]$id <- "45300912"
  repos_list_with_languages <- test_rest_priv$pull_repos_languages(
    repos_list = repos_list
  )
  expect_list_contains(
    repos_list_with_languages[[1]],
    "languages"
  )
})

test_that("`tailor_repos_info()` tailors precisely `repos_list`", {
  gl_repos_by_code <- test_mocker$use("gl_search_repos_by_code")

  gl_repos_by_code_tailored <-
    test_rest_priv$tailor_repos_info(gl_repos_by_code)

  gl_repos_by_code_tailored %>%
    expect_type("list") %>%
    expect_length(length(gl_repos_by_code))

  expect_list_contains_only(
    gl_repos_by_code_tailored[[1]],
    c(
      "repo_id", "repo_name", "created_at", "last_activity_at",
      "forks", "stars", "languages", "issues_open",
      "issues_closed", "organization"
    )
  )
  expect_lt(
    length(gl_repos_by_code_tailored[[1]]),
    length(gl_repos_by_code[[1]])
  )
  test_mocker$cache(gl_repos_by_code_tailored)
})

test_that("`prepare_repos_table()` prepares repos table", {
  gl_repos_by_code_table <- test_rest_priv$prepare_repos_table(
    repos_list = test_mocker$use("gl_repos_by_code_tailored")
  )

  expect_repos_table(
    gl_repos_by_code_table
  )
  test_mocker$cache(gl_repos_by_code_table)
})

test_that("`pull_commits_from_repos()` pulls commits from repo", {
  gl_commits_repo_1 <- test_mocker$use("gl_commits_rest_response_repo_1")

  mockery::stub(
    test_rest_priv$pull_commits_from_repos,
    "private$pull_commits_from_one_repo",
    gl_commits_repo_1
  )
  repos_table <- test_mocker$use("gl_repos_by_code_table")
  repos_names <- stringr::str_remove(repos_table$repo_url, "https://gitlab.com/") %>%
    stringr::str_replace_all("/", "%2f")
  gl_commits_org <- test_rest_priv$pull_commits_from_repos(
    repos_names = repos_names,
    date_from = "2023-01-01",
    date_until = "2023-04-20"
  )
  expect_gl_commit_rest_response(
    gl_commits_org[[1]]
  )
  test_mocker$cache(gl_commits_org)
})

test_that("`tailor_commits_info()` retrieves only necessary info", {
  gl_commits_list <- test_mocker$use("gl_commits_org")

  gl_commits_list_cut <- test_rest_priv$tailor_commits_info(
    gl_commits_list,
    org = "mbtests"
  )
  expect_tailored_commits_list(
    gl_commits_list_cut[[1]][[1]]
  )
  test_mocker$cache(gl_commits_list_cut)
})

test_that("`prepare_commits_table()` prepares table of commits properly", {
  gl_commits_table <- test_rest_priv$prepare_commits_table(
    commits_list = test_mocker$use("gl_commits_list_cut")
  )
  expect_commits_table(
    gl_commits_table,
    exp_auth = FALSE
  )
  test_mocker$cache(gl_commits_table)
})

test_that("`get_commits_authors_handles_and_names()` adds author logis and names to commits table", {
  expect_snapshot(
    gl_commits_table <- test_rest_priv$get_commits_authors_handles_and_names(
      commits_table = test_mocker$use("gl_commits_table"),
      settings = test_settings
    )
  )
  expect_commits_table(
    gl_commits_table,
    exp_auth = TRUE
  )
  test_mocker$cache(gl_commits_table)
})

test_that("`pull_repos_issues()` adds issues to repos table", {
  gl_repos_by_code_table <- test_mocker$use("gl_repos_by_code_table")
  gl_repos_by_code_table <- test_rest_priv$pull_repos_issues(
    gl_repos_by_code_table
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

# public methods

test_that("`pull_repos_contributors()` adds contributors to repos table", {
  expect_snapshot(
    gl_repos_table_with_contributors <- test_rest$pull_repos_contributors(
      test_mocker$use("gl_repos_table"),
      settings = test_settings
    )
  )
  expect_repos_table(
    gl_repos_table_with_contributors,
    add_col = "contributors"
  )
  expect_gt(
    length(gl_repos_table_with_contributors$contributors),
    0
  )
  test_mocker$cache(gl_repos_table_with_contributors)
})

test_that("`pull_repos_by_code()` works", {
  mockery::stub(
    test_rest$pull_repos,
    "private$pull_repos_by_code",
    test_mocker$use("gl_search_repos_by_code")
  )
  test_settings[["search_mode"]] <- "code"
  expect_snapshot(
    result <- test_rest$pull_repos(
      org = "gitlab-org",
      code = "covid",
      settings = test_settings
    )
  )
  expect_repos_table(result)
})

test_that("`pull_commits()` works as expected", {
  mockery::stub(
    test_rest$pull_commits,
    "private$pull_commits_from_repos",
    test_mocker$use("gl_commits_org")
  )
  expect_snapshot(
    result <- test_rest$pull_commits(
      org = "mbtests",
      date_from = "2023-01-01",
      date_until = "2023-04-20",
      settings = test_settings
    )
  )
  expect_commits_table(result)
})

test_that("`pull_commits()` works with repositories implied", {
  expect_snapshot(
    result <- test_rest$pull_commits(
      org = "mbtests",
      repos = c("gitstatstesting", "gitstats-testing-2"),
      date_from = "2023-01-01",
      date_until = "2023-04-20",
      settings = test_settings_repo
    )
  )
  expect_commits_table(result)
})
