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
      set_github_host(
        token = Sys.getenv("GITHUB_PAT"),
        repos = c("r-world-devs/GitStats", "openpharma/GithubMetrics")
      ) %>%
      set_gitlab_host(
        token = Sys.getenv("GITLAB_PAT_PUBLIC"),
        repos = c("mbtests/gitstatstesting", "mbtests/gitstats-testing-2")
      )
  )
  expect_snapshot(test_gitstats)
})

# private methods
test_gitstats_priv <- create_test_gitstats(hosts = 0, priv_mode = TRUE)

test_that("check_for_host returns error when no hosts are passed", {
  expect_snapshot_error(
    test_gitstats_priv$check_for_host()
  )
})

test_that("check_params_conflict returns error", {
  expect_snapshot_error(
    test_gitstats_priv$check_params_conflict(
      with_code = NULL,
      with_files = NULL,
      in_files = "DESCRIPTION"
    )
  )
  expect_snapshot_error(
    test_gitstats_priv$check_params_conflict(
      with_code = "shiny",
      with_files = "DESCRIPTION",
      in_files = NULL
    )
  )
})

test_gitstats_priv <- create_test_gitstats(hosts = 2, priv_mode = TRUE)

test_that("set_object_class works correctly", {
  repos_urls <- test_gitstats_priv$set_object_class(
    object = test_mocker$use("repos_urls_from_hosts_with_code_in_files"),
    class = "repos_urls",
    attr_list = list(
      "type" = "api",
      "with_code" = "shiny",
      "in_files" = c("NAMESPACE", "DESCRIPTION"),
      "with_files" = NULL
    )
  )
  expect_s3_class(repos_urls, "repos_urls")
  expect_equal(attr(repos_urls, "type"), "api")
  expect_equal(attr(repos_urls, "with_code"), "shiny")
  expect_equal(attr(repos_urls, "in_files"), c("NAMESPACE", "DESCRIPTION"))
})

test_that("get_R_package_as_dependency work correctly", {
  mockery::stub(
    test_gitstats_priv$get_R_package_as_dependency,
    "private$get_repos_table",
    test_mocker$use("repos_table")
  )
  R_package_as_dependency <- test_gitstats_priv$get_R_package_as_dependency(
    package_name = "shiny",
    verbose = FALSE
  )
  expect_s3_class(
    R_package_as_dependency,
    "data.frame"
  )
  expect_gt(
    nrow(R_package_as_dependency),
    0
  )
  test_mocker$cache(R_package_as_dependency)
})

test_that("get_R_package_usage_table works as expected", {
  test_gitstats <- create_test_gitstats(hosts = 2, priv_mode = TRUE)
  mockery::stub(
    test_gitstats$get_R_package_usage_table,
    "private$get_R_package_as_dependency",
    test_mocker$use("R_package_as_dependency")
  )
  mockery::stub(
    test_gitstats$get_R_package_usage_table,
    "private$get_R_package_loading",
    test_mocker$use("R_package_as_dependency")
  )
  R_package_usage_table <- test_gitstats$get_R_package_usage_table(
    package_name = "shiny", only_loading = FALSE, verbose = FALSE
  )
  expect_package_usage_table(R_package_usage_table)
  test_mocker$cache(R_package_usage_table)
})

test_that("get_release_logs_table works as expected", {
  test_gitstats <- create_test_gitstats(hosts = 2, priv_mode = TRUE)
  mockery::stub(
    test_gitstats$get_release_logs_table,
    "host$get_release_logs",
    test_mocker$use("releases_table")
  )
  release_logs_table <- test_gitstats$get_release_logs_table(
    since = "2023-08-01",
    until = "2023-09-30",
    verbose = FALSE
  )
  expect_releases_table(release_logs_table)
})

test_that("check_if_args_changed", {
  test_gitstats <- create_test_gitstats(
    hosts = 2,
    priv_mode = TRUE,
    inject_repos = "repos_table"
  )
  check <- test_gitstats$check_if_args_changed(
    storage = "repositories",
    args_list = list(
      "with_code" = "shiny",
      "in_files" = "DESCRIPTION",
      "with_files" = NULL
    )
  )
  # repos_table from mock should be set to with_files = 'renv.lock'
  expect_true(
    check
  )
  check <- test_gitstats$check_if_args_changed(
    storage = "repositories",
    args_list = list(
      "with_code" = NULL,
      "in_files" = NULL,
      "with_files" = "renv.lock"
    )
  )
  expect_false(
    check
  )
})

# public methods

test_that("GitStats get users info", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  users_result <- test_gitstats$get_users(
    c("maciekbanas", "kalimu", "marcinkowskak"),
    verbose = FALSE
  )
  expect_users_table(
    users_result
  )
})

test_that("show_orgs print orgs properly", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  expect_equal(
    test_gitstats$show_orgs(),
    c("r-world-devs", "mbtests")
  )
})

suppressMessages(
  test_gitstats <- create_gitstats() %>%
    set_gitlab_host(
      token = Sys.getenv("GITLAB_PAT_PUBLIC"),
      orgs = "mbtests/subgroup"
    )
)

test_that("show_orgs print subgroups properly", {
  expect_equal(
    test_gitstats$show_orgs(),
    "mbtests/subgroup"
  )
})

test_that("subgroups are cleanly printed in GitStats", {
  expect_snapshot(
    test_gitstats
  )
})
