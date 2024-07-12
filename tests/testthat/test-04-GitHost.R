test_host <- create_github_testhost(orgs = "r-world-devs", mode = "private")

test_that("`set_searching_scope` does not throw error when `orgs` or `repos` are defined", {
  expect_snapshot(
    test_host$set_searching_scope(orgs = "mbtests", repos = NULL)
  )
  expect_snapshot(
    test_host$set_searching_scope(orgs = NULL, repos = "mbtests/GitStatsTesting")
  )
})

test_that("`extract_repos_and_orgs` extracts fullnames vector into a list of GitLab organizations with assigned repositories", {
  repos_fullnames <- c(
    "mbtests/gitstatstesting", "mbtests/gitstats-testing-2", "mbtests/subgroup/test-project-in-subgroup"
  )
  expect_equal(
    test_host$extract_repos_and_orgs(repos_fullnames),
    list(
      "mbtests" = c("gitstatstesting", "gitstats-testing-2"),
      "mbtests/subgroup" = c("test-project-in-subgroup")
    )
  )
})

test_that("GitHub tailors precisely `repos_list`", {
  gh_repos_by_code <- test_mocker$use("gh_repos_by_code")
  gh_repos_by_code_tailored <-
    test_host$tailor_repos_response(gh_repos_by_code)
  gh_repos_by_code_tailored %>%
    expect_type("list") %>%
    expect_length(length(gh_repos_by_code))
  expect_list_contains_only(
    gh_repos_by_code_tailored[[1]],
    c(
      "repo_id", "repo_name", "created_at", "last_activity_at",
      "forks", "stars", "issues_open", "issues_closed",
      "organization"
    )
  )
  expect_lt(
    length(gh_repos_by_code_tailored[[1]]),
    length(gh_repos_by_code[[1]])
  )
  test_mocker$cache(gh_repos_by_code_tailored)
})

test_that("`prepare_repos_table()` prepares repos table", {
  expect_snapshot(
    gh_repos_by_code_table <- test_host$prepare_repos_table_from_rest(
      repos_list = test_mocker$use("gh_repos_by_code_tailored")
    )
  )
  expect_repos_table(
    gh_repos_by_code_table
  )
  gh_repos_by_code_table <- test_host$add_repo_api_url(gh_repos_by_code_table)
  test_mocker$cache(gh_repos_by_code_table)
})

test_that("`prepare_releases_table()` prepares releases table", {
  releases_table <- test_host$prepare_releases_table(
    releases_response = test_mocker$use("releases_from_repos"),
    org = "r-world-devs",
    date_from = "2023-05-01",
    date_until = "2023-09-30"
  )
  expect_releases_table(releases_table)
  expect_gt(min(releases_table$published_at), as.POSIXct("2023-05-01"))
  expect_lt(max(releases_table$published_at), as.POSIXct("2023-09-30"))
  test_mocker$cache(releases_table)
})

test_that("`prepare_commits_table()` prepares commits table", {
  commits_table <- test_host$prepare_commits_table(
    repos_list_with_commits = test_mocker$use("commits_from_repos"),
    org = "r-world-devs"
  )
  expect_commits_table(
    commits_table
  )
  test_mocker$cache(commits_table)
})

test_that("GitHub prepares user table", {
  gh_user_table <- test_host$prepare_user_table(
    user_response = test_mocker$use("gh_user_response")
  )
  expect_users_table(
    gh_user_table,
    one_user = TRUE
  )
  test_mocker$cache(gh_user_table)
})

test_that("`get_all_repos()` works as expected", {
  expect_snapshot(
    gh_repos_table <- test_host$get_all_repos(
      settings = test_settings
    )
  )
  expect_repos_table(
    gh_repos_table
  )
  test_mocker$cache(gh_repos_table)
})

test_that("get_all_repos_urls prepares api repo_urls vector", {
  test_host <- create_github_testhost(orgs = c("r-world-devs", "openpharma"),
                                      mode = "private")
  gh_api_repos_urls <- test_host$get_all_repos_urls(
    type = "api",
    verbose = FALSE
  )
  expect_gt(length(gh_api_repos_urls), 0)
  expect_true(any(grepl("openpharma", gh_api_repos_urls)))
  expect_true(any(grepl("r-world-devs", gh_api_repos_urls)))
  expect_true(all(grepl("api", gh_api_repos_urls)))
  test_mocker$cache(gh_api_repos_urls)
})

test_that("get_all_repos_urls prepares web repo_urls vector", {
  test_host <- create_github_testhost(orgs = "r-world-devs",
                                      mode = "private")
  mockery::stub(
    test_host$get_all_repos_urls,
    "rest_engine$pull_repos_urls",
    test_mocker$use("gh_repos_urls")
  )
  gh_repos_urls <- test_host$get_all_repos_urls(
    type = "web",
    verbose = FALSE
  )
  expect_gt(length(gh_repos_urls), 0)
  expect_true(any(grepl("r-world-devs", gh_repos_urls)))
  expect_true(all(grepl("https://github.com/", gh_repos_urls)))
  test_mocker$cache(gh_repos_urls)
})

test_that("`get_repos_with_code()` works", {
  suppressMessages(
    result <- test_host$get_repos_with_code(
      code = "Shiny",
      settings = test_settings
    )
  )
  expect_repos_table(result)
})

test_that("GitHub prepares table from files response", {
  gh_files_table <- test_host$prepare_files_table(
    files_response = test_mocker$use("github_files_response"),
    org = "r-world-devs",
    file_path = "LICENSE"
  )
  expect_files_table(gh_files_table)
  test_mocker$cache(gh_files_table)
})

# public methods

test_host <- create_github_testhost(orgs = "r-world-devs")


test_that("`get_commits()` retrieves commits in the table format", {
  mockery::stub(
    test_host$get_commits,
    "private$get_commits_from_host",
    test_mocker$use("commits_table")
  )
  suppressMessages(
    commits_table <- test_host$get_commits(
      since = "2023-01-01",
      until = "2023-02-28",
      settings = test_settings
    )
  )
  expect_commits_table(
    commits_table
  )
})

test_that("`get_files()` pulls files in the table format", {
  mockery::stub(
    test_host$get_files,
    "private$get_files_from_orgs",
    test_mocker$use("gh_files_table")
  )
  expect_snapshot(
    gh_files_table <- test_host$get_files(
      file_path = "LICENSE"
    )
  )
  expect_files_table(gh_files_table)
  test_mocker$cache(gh_files_table)
})

test_that("`get_files()` pulls files only for the repositories specified", {
  test_host <- create_github_testhost(
    repos = c("r-world-devs/GitStats", "openpharma/visR", "openpharma/DataFakeR"),
  )
  expect_snapshot(
    gh_files_table <- test_host$get_files(
      file_path = "renv.lock"
    )
  )
  expect_files_table(gh_files_table, add_col = "api_url")
  expect_equal(nrow(gh_files_table), 2) # visR does not have renv.lock
})

test_that("`get_release_logs()` pulls release logs in the table format", {
  expect_snapshot(
    releases_table <- test_host$get_release_logs(
      since = "2023-05-01",
      until = "2023-09-30",
      verbose = TRUE,
      settings = test_settings
    )
  )
  expect_releases_table(releases_table)
  expect_gt(min(releases_table$published_at), as.POSIXct("2023-05-01"))
  expect_lt(max(releases_table$published_at), as.POSIXct("2023-09-30"))
  test_mocker$cache(releases_table)
})

# GitLab - private methods

test_host_gitlab <- create_gitlab_testhost(orgs = "mbtests", mode = "private")

test_that("`prepare_repos_table()` prepares repos table", {
  gl_repos_table <- test_host_gitlab$prepare_repos_table_from_graphql(
    repos_list = test_mocker$use("gl_repos_from_org")
  )
  expect_repos_table(
    gl_repos_table
  )
  test_mocker$cache(gl_repos_table)
})

test_that("get_all_repos_urls prepares api repo_urls vector", {
  mockery::stub(
    test_host_gitlab$get_all_repos_urls,
    "rest_engine$pull_repos_urls",
    test_mocker$use("gl_repos_urls")
  )
  gl_api_repos_urls <- test_host_gitlab$get_all_repos_urls(
    type = "api",
    verbose = FALSE
  )
  expect_gt(length(gl_api_repos_urls), 0)
  expect_true(all(grepl("api", gl_api_repos_urls)))
  test_mocker$cache(gl_api_repos_urls)
})

test_that("get_all_repos_urls prepares web repo_urls vector", {
  gl_repos_urls <- test_host_gitlab$get_all_repos_urls(
    type = "web",
    verbose = FALSE
  )
  expect_gt(length(gl_repos_urls), 0)
  expect_true(all(!grepl("api", gl_repos_urls)))
})

test_that("GitLab prepares user table", {
  gl_user_table <- test_host_gitlab$prepare_user_table(
    user_response = test_mocker$use("gl_user_response")
  )
  expect_users_table(
    gl_user_table,
    one_user = TRUE
  )
  test_mocker$cache(gl_user_table)
})

test_that("GitLab prepares table from files response", {
  gl_files_table <- test_host_gitlab$prepare_files_table(
    files_response = test_mocker$use("gitlab_files_response"),
    org = "mbtests",
    file_path = "meta_data.yaml"
  )
  expect_files_table(gl_files_table)
  test_mocker$cache(gl_files_table)
})

test_that("`tailor_repos_response()` tailors precisely `repos_list`", {
  gl_repos_by_code <- test_mocker$use("gl_search_repos_by_code")

  gl_repos_by_code_tailored <-
    test_host_gitlab$tailor_repos_response(gl_repos_by_code)

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

test_that("GitHost prepares table from GitLab repositories response", {
  expect_snapshot(
    gl_repos_by_code_table <- test_host_gitlab$prepare_repos_table_from_rest(
      repos_list = test_mocker$use("gl_repos_by_code_tailored")
    )
  )
  expect_repos_table(
    gl_repos_by_code_table
  )
  gl_repos_by_code_table <- test_host_gitlab$add_repo_api_url(gl_repos_by_code_table)
  test_mocker$cache(gl_repos_by_code_table)
})

# public - GitLab

test_host_gitlab <- create_gitlab_testhost(orgs = "mbtests")

test_that("`get_files()` pulls files in the table format", {
  mockery::stub(
    test_host_gitlab$get_files,
    "private$get_files_from_orgs",
    test_mocker$use("gl_files_table")
  )
  expect_snapshot(
    gl_files_table <- test_host_gitlab$get_files(
      file_path = "README.md"
    )
  )
  expect_files_table(gl_files_table)
  test_mocker$cache(gl_files_table)
})

test_that("`get_files()` pulls two files in the table format", {
  expect_snapshot(
    gl_files_table <- test_host_gitlab$get_files(
      file_path = c("meta_data.yaml", "README.md")
    )
  )
  expect_files_table(gl_files_table, add_col = "api_url")
  expect_true(
    all(c("meta_data.yaml", "README.md") %in% gl_files_table$file_path)
  )
})

test_that("get_users build users table for GitHub", {
  users_result <- test_host$get_users(
    users = c("maciekbanas", "Cotau", "marcinkowskak")
  )
  expect_users_table(
    users_result
  )
})

test_that("get_users build users table for GitLab", {
  users_result <- test_host_gitlab$get_users(
    users = c("maciekbanas", "Cotau", "marcinkowskak")
  )
  expect_users_table(
    users_result
  )
})
