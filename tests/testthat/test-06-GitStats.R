test_gitstats <- create_gitstats()

test_that("GitStats object is created", {
  expect_s3_class(test_gitstats, "GitStats")
})

# print method

test_that("GitStats prints empty fields.", {
  expect_snapshot(test_gitstats)
})

test_gitstats <- create_test_gitstats(hosts = 2)

test_that("GitStats prints the proper info when connections are added.", {
  expect_snapshot(test_gitstats)
})

test_that("GitStats prints the proper info when repos are passed instead of orgs.", {
  suppressMessages(
    test_gitstats <- create_gitstats() %>%
      set_host(
        api_url = "https://api.github.com",
        token = Sys.getenv("GITHUB_PAT"),
        repos = c("r-world-devs/GitStats", "openpharma/GithubMetrics")
      ) %>%
      set_host(
        api_url = "https://gitlab.com/api/v4",
        token = Sys.getenv("GITLAB_PAT_PUBLIC"),
        repos = c("mbtests/gitstatstesting", "mbtests/gitstats-testing-2")
      )
  )
  expect_snapshot(test_gitstats)
})

suppressMessages({
  set_params(
    test_gitstats,
    search_param = "team",
    team_name = "RWD-IE"
  )
})

test_that("GitStats prints team name when team is added.", {
  expect_snapshot(test_gitstats)
})

# private methods
test_gitstats_priv <- create_test_gitstats(hosts = 0, priv_mode = TRUE)

test_that("Language handler works properly", {
  expect_equal(test_gitstats_priv$language_handler("r"), "R")
  expect_equal(test_gitstats_priv$language_handler("python"), "Python")
  expect_equal(test_gitstats_priv$language_handler("javascript"), "Javascript")
})

test_that("check_for_host returns error when no hosts are passed", {
  expect_snapshot_error(
    test_gitstats_priv$check_for_host()
  )
})

test_gitstats_priv <- create_test_gitstats(hosts = 1, priv_mode = TRUE)

test_that("check_R_package_loading", {
  suppressMessages(
    R_package_loading <- test_gitstats_priv$check_R_package_loading("purrr")
  )
  expect_package_usage_table(R_package_loading)
  test_mocker$cache(R_package_loading)
})

test_that("check_R_package_as_dependency", {
  suppressMessages(
    R_package_as_dependency <- test_gitstats_priv$check_R_package_as_dependency("purrr")
  )
  expect_package_usage_table(R_package_as_dependency)
  test_mocker$cache(R_package_as_dependency)
})

test_that("check_R_package does not pull files if NAMESPACE and DESCRIPTION are already loaded", {
  suppressMessages(
    R_package_as_dependency <- test_gitstats_priv$check_R_package_as_dependency("dplyr")
  )
  expect_package_usage_table(R_package_as_dependency)
})

# public methods

test_that("GitStats get users info", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  test_gitstats$pull_users(
    c("maciekbanas", "kalimu", "marcinkowskak")
  )
  users_result <- get_users(test_gitstats)
  expect_users_table(
    users_result
  )
})

test_that("pull_repos works properly", {
  test_gitstats <- create_test_gitstats(
    hosts = 2
  )
  suppressMessages(
    test_gitstats$pull_repos()
  )
  expect_repos_table(
    test_gitstats$get_repos(),
    add_col = "api_url"
  )
})

test_that("GitStats throws error when pull_repos_contributors is run with empty repos field", {
  test_gitstats_empty <- create_test_gitstats(hosts = 2)
  expect_snapshot_error(
    test_gitstats_empty$pull_repos_contributors()
  )
})

test_that("Add_repos_contributors adds repos contributors to repos table", {
  repos_table_without_contributors <- data.table::rbindlist(
    list(
      test_mocker$use("gh_repos_table_with_api_url"),
      test_mocker$use("gl_repos_table_with_api_url")
    )
  )
  test_mocker$cache(repos_table_without_contributors)
  test_gitstats <- create_test_gitstats(
    hosts = 2,
    inject_repos = "repos_table_without_contributors"
  )
  expect_snapshot(
    test_gitstats$pull_repos_contributors()
  )
  repos_table_with_contributors <- test_gitstats$get_repos()
  expect_true("contributors" %in% names(repos_table_with_contributors))
  expect_equal(nrow(repos_table_without_contributors), nrow(repos_table_with_contributors))
})

test_that("pull_commits works properly", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  suppressMessages(
    test_gitstats$pull_commits(
      date_from = "2023-06-01",
      date_until = "2023-06-15"
    )
  )
  commits_table <- test_gitstats$get_commits()
  expect_commits_table(
    commits_table
  )
  test_mocker$cache(commits_table)
})

test_that("pull_files works properly", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  suppressMessages(
    test_gitstats$pull_files(
      file_path = "meta_data.yaml"
    )
  )
  files_table <- test_gitstats$get_files()
  expect_files_table(
    files_table
  )
  test_mocker$cache(files_table)
})

test_that("get_orgs print orgs properly", {
  expect_equal(
    test_gitstats$get_orgs(),
    c("r-world-devs", "openpharma", "mbtests")
  )
})

suppressMessages(
  test_gitstats <- create_gitstats() %>%
    set_host(
      api_url = "https://gitlab.com/api/v4",
      token = Sys.getenv("GITLAB_PAT_PUBLIC"),
      orgs = "mbtests/subgroup"
    )
)

test_that("get_orgs print subgroups properly", {
  expect_equal(
    test_gitstats$get_orgs(),
    "mbtests/subgroup"
  )
})

test_that("subgroups are cleanly printed in GitStats", {
  expect_snapshot(
    test_gitstats
  )
})

test_that("pull_R_package_usage works as expected", {
  test_gitstats <- create_test_gitstats(hosts = 1)
  mockery::stub(
    test_gitstats$pull_R_package_usage,
    "private$check_R_package_as_dependency",
    test_mocker$use("R_package_as_dependency")
  )
  mockery::stub(
    test_gitstats$pull_R_package_usage,
    "private$check_R_package_loading",
    test_mocker$use("R_package_loading")
  )
  suppressMessages(
    test_gitstats$pull_R_package_usage(
      "purrr"
    )
  )
  expect_package_usage_table(
    test_gitstats$.__enclos_env__$private$R_package_usage
  )
})
