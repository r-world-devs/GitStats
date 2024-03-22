# public methods
test_host <- create_testhost(
  api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = c("openpharma", "r-world-devs")
)

test_that("GitHost gets users tables", {
  users_table <- test_host$pull_users(
    users = c("maciekbanas", "kalimu", "galachad")
  )
  expect_users_table(users_table)
  test_mocker$cache(users_table)
})

# private methods

test_that("`check_if_public` and `set_host_name` work correctly", {
  test_host <- create_testhost(
    api_url = "https://api.github.com",
    mode = "private"
  )
  expect_true(
    test_host$check_if_public()
  )
  expect_equal(
    test_host$set_host_name(),
    "GitHub"
  )
  test_host <- create_testhost(
    api_url = "https://gitlab.com/api/v4",
    mode = "private"
  )
  expect_true(
    test_host$check_if_public()
  )
  expect_equal(
    test_host$set_host_name(),
    "GitLab"
  )
  test_host <- create_testhost(
    api_url = "https://code.internal.com/api/v4",
    mode = "private"
  )
  expect_false(
    test_host$check_if_public()
  )
  expect_equal(
    test_host$set_host_name(),
    "GitLab"
  )
  test_host <- create_testhost(
    api_url = "https://github.internal.com/api/v4",
    mode = "private"
  )
  expect_false(
    test_host$check_if_public()
  )
  expect_equal(
    test_host$set_host_name(),
    "GitHub"
  )
})

test_host <- create_testhost(
  api_url = "https://api.github.com",
  mode = "private"
)

test_that("`set_default_token` sets default token for public GitHub", {
  expect_snapshot(
    default_token <- test_host$set_default_token()
  )
  test_rest <- create_testrest(token = default_token,
                               mode = "private")
  expect_equal(
    test_rest$perform_request(
      endpoint = "https://api.github.com",
      token = default_token
    )$status,
    200
  )
})

test_that("`set_default_token` sets default token for GitLab", {
  test_gl_host <- create_testhost(
    api_url = "https://gitlab.com/api/v4",
    token = Sys.getenv("GITLAB_PAT_PUBLIC"),
    orgs = c("openpharma", "r-world-devs"),
    mode = "private"
  )
  expect_snapshot(
    withr::with_envvar(new = c("GITLAB_PAT" = Sys.getenv("GITLAB_PAT_PUBLIC")), {
      default_token <- test_gl_host$set_default_token()
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

test_that("`test_token` works properly", {
  expect_true(
    test_host$test_token(Sys.getenv("GITHUB_PAT"))
  )
  expect_false(
    test_host$test_token("false_token")
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

test_that("`check_orgs_and_repos` does not throw error when `orgs` or `repos` are defined", {
  expect_no_condition(
    test_host$check_orgs_and_repos(orgs = "mbtests", repos = NULL)
  )
  expect_no_condition(
    test_host$check_orgs_and_repos(orgs = NULL, repos = "mbtests/GitStatsTesting")
  )
})

test_that("`check_orgs_and_repos` throws error when host is public one", {
  expect_snapshot_error(
    test_host$check_orgs_and_repos(orgs = "mbtests", repos = "mbtests/GitStatsTesting")
  )
})

test_that("`extract_repos_and_orgs` extracts fullnames vector into a list of GitHub organizations with assigned repositories", {
  repos_fullnames <- c(
    "r-world-devs/GitStats", "r-world-devs/shinyCohortBuilder",
    "openpharma/DataFakeR", "openpharma/GithubMetrics"
  )
  expect_equal(
    test_host$extract_repos_and_orgs(repos_fullnames),
    list(
      "r-world-devs" = c("GitStats", "shinyCohortBuilder"),
      "openpharma" = c("DataFakeR", "GithubMetrics")
    )
  )
})

test_that("`extract_repos_and_orgs` extracts fullnames vector into a list of GitLab organizations with assigned repositories", {
  test_gl_host <- create_testhost(
    api_url = "https://gitlab.com/api/v4",
    token = Sys.getenv("GITLAB_PAT_PUBLIC"),
    mode = "private"
  )
  repos_fullnames <- c(
    "mbtests/gitstatstesting", "mbtests/gitstats-testing-2", "mbtests/subgroup/test-project-in-subgroup"
  )
  expect_equal(
    test_gl_host$extract_repos_and_orgs(repos_fullnames),
    list(
      "mbtests" = c("gitstatstesting", "gitstats-testing-2"),
      "mbtests/subgroup" = c("test-project-in-subgroup")
    )
  )
})

# do not use create_testhost as full initializing with setup_engine has to be tested
suppressMessages(
  test_host <- GitHost$new(
    api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = "r-world-devs",
    repos = NULL
  )
)
test_host <- test_host$.__enclos_env__$private

test_that("`setup_engine` adds engines to host", {
  expect_s3_class(
    test_host$setup_engine(type = "rest"),
    "EngineRest"
  )
  expect_s3_class(
    test_host$setup_engine(type = "graphql"),
    "EngineGraphQL"
  )
})

test_that("`set_gql_url()` correctly sets gql api url - for public GitHub", {
  expect_equal(
    test_host$set_gql_url("https://api.github.com"),
    "https://api.github.com/graphql"
  )
})

test_that("`set_gql_url()` correctly sets gql api url - for public GitLab", {
  expect_equal(
    test_host$set_gql_url("https://gitlab.com/api/v4"),
    "https://gitlab.com/api/graphql"
  )
})

test_that("GitHost pulls repos from orgs", {
  expect_snapshot(
    gh_repos_table <- test_host$pull_repos_from_orgs(test_settings)
  )
  expect_repos_table(
    gh_repos_table
  )
})

test_that("GitHost adds `repo_api_url` column to GitHub repos table", {
  repos_table <- test_mocker$use("gh_repos_table")
  gh_repos_table_with_api_url <- test_host$add_repo_api_url(repos_table)
  expect_true(all(grepl("api.github.com", gh_repos_table_with_api_url$api_url)))
  test_mocker$cache(gh_repos_table_with_api_url)
})

suppressMessages(
  test_gl_host <- GitHost$new(
    api_url = "https://gitlab.com/api/v4",
    token = Sys.getenv("GITLAB_PAT_PUBLIC"),
    orgs = "mbtests",
    repos = NULL
  )
)
test_gl_host <- test_gl_host$.__enclos_env__$private

test_that("GitHost adds `repo_api_url` column to GitLab repos table", {
  repos_table <- test_mocker$use("gl_repos_table")
  gl_repos_table_with_api_url <- test_gl_host$add_repo_api_url(repos_table)
  expect_true(all(grepl("gitlab.com/api/v4", gl_repos_table_with_api_url$api_url)))
  test_mocker$cache(gl_repos_table_with_api_url)
})

test_that("GitHost filters GitHub repositories' (pulled by org) table by languages", {
  repos_table <- test_mocker$use("gh_repos_table")
  expect_snapshot(
    result <- test_host$filter_repos_by_language(
      repos_table,
      language = "JavaScript"
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
    all(grepl("JavaScript", result$languages))
  )
})

test_that("GitHost filters GitHub repositories' (pulled by team) table by languages", {
  repos_table <- test_mocker$use("gh_repos_table_team")
  expect_snapshot(
    result <- test_host$filter_repos_by_language(
      repos_table,
      language = "CSS"
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
    all(grepl("CSS", result$languages))
  )
})

test_that("GitHost filters GitHub repositories' (pulled by phrase) table by languages", {
  gh_repos_table <- test_mocker$use("gh_repos_by_phrase_table")
  expect_snapshot(
    result <- test_host$filter_repos_by_language(
      gh_repos_table,
      language = "R"
    )
  )
  expect_length(
    result,
    length(gh_repos_table)
  )
  expect_gt(
    nrow(result),
    0
  )
  expect_true(
    all(grepl("R", result$languages))
  )
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

# public methods

test_host <- create_testhost(
  api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = c("openpharma", "r-world-devs")
)

test_that("pull_repos returns table of repositories", {
  mockery::stub(
    test_host$pull_repos,
    "private$pull_repos_from_org",
    test_mocker$use("gh_repos_table")
  )
  expect_snapshot(
    repos_table <- test_host$pull_repos(
      settings = test_settings
    )
  )
  expect_repos_table(
    repos_table,
    add_col = "api_url"
  )
})

test_that("pull_repos_contributors returns table with contributors for GitHub", {
  repos_table_1 <- test_mocker$use("gh_repos_table_with_api_url")
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

test_gl_host <- create_testhost(
  api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT_PUBLIC"),
  orgs = c("mbtests")
)

test_that("pull_repos_contributors returns table with contributors for GitLab", {
  repos_table_1 <- test_mocker$use("gl_repos_table_with_api_url")
  expect_snapshot(
    repos_table_2 <- test_gl_host$pull_repos_contributors(repos_table_1,
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
    test_gl_host$pull_commits(
      date_from = "2023-03-01",
      date_until = "2023-04-01",
      settings = test_settings
    )
  )
})

test_that("pull_commits for GitLab works", {
  skip_if(!interactive())
  suppressMessages(
    gl_commits_table <- test_gl_host$pull_commits(
      date_from = "2023-03-01",
      date_until = "2023-04-01",
      settings = test_settings
    )
  )
  expect_commits_table(
    gl_commits_table
  )
})

test_that("pull_commits for GitLab works with repos implied", {
  skip_if(!interactive())
  test_host <- create_testhost(
    api_url = "https://gitlab.com/api/v4",
    token = Sys.getenv("GITLAB_PAT_PUBLIC"),
    repos = c("mbtests/gitstatstesting", "mbtests/gitstats-testing-2")
  )
  expect_snapshot(
    gl_commits_table <- test_host$pull_commits(
      date_from = "2023-01-01",
      date_until = "2023-06-01",
      settings = test_settings_repo
    )
  )
  expect_commits_table(
    gl_commits_table
  )
})

test_that("pull_commits for GitHub works", {
  suppressMessages(
    gh_commits_table <- test_host$pull_commits(
      date_from = "2023-03-01",
      date_until = "2023-04-01",
      settings = test_settings
    )
  )
  expect_commits_table(
    gh_commits_table
  )
})

test_that("pull_commits for GitHub works with repos implied", {
  test_host <- create_testhost(
    api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    repos = c("openpharma/DataFakeR", "r-world-devs/GitStats", "r-world-devs/cohortBuilder")
  )
  suppressMessages(
    gh_commits_table <- test_host$pull_commits(
      date_from = "2023-03-01",
      date_until = "2023-04-01",
      settings = test_settings_repo
    )
  )
  expect_commits_table(
    gh_commits_table
  )
})

test_that("pull_files for GitLab works", {
  suppressMessages(
    gl_files_table <- test_gl_host$pull_files(
      file_path = "meta_data.yaml",
      settings = test_settings
    )
  )
  expect_files_table(
    gl_files_table
  )
})

test_that("pull_files for GitHub works", {
  suppressMessages(
    gh_files_table <- test_host$pull_files(
      file_path = "DESCRIPTION",
      settings = test_settings
    )
  )
  expect_files_table(
    gh_files_table
  )
})

test_that("pull_release logs for GitHub works", {
  suppressMessages(
    gh_releases_table <- test_host$pull_release_logs(
      date_from = "2023-05-01",
      date_until = "2023-09-30",
      settings = test_settings
    )
  )
  expect_releases_table(
    gh_releases_table
  )
})
