test_gitstats <- create_test_gitstats(hosts = 0)

test_that("GitStats object is created", {
  expect_s3_class(test_gitstats, "GitStats")
})

test_that("GitStats prints empty fields.", {
  expect_snapshot(test_gitstats)
})

test_that("GitStats prints the proper info when connections are added.", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  expect_snapshot(test_gitstats)
})

test_that("GitStats prints the proper info when repos are passed instead of orgs.", {
  skip_on_cran()
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

test_that("print_storage_attribute", {
  expect_snapshot(
    test_gitstats_priv$print_storage_attribute(
      storage_data = test_mocker$use("commits_table"),
      storage_name = "commits"
    )
  )
  expect_snapshot(
    test_gitstats_priv$print_storage_attribute(
      storage_data = test_mocker$use("release_logs_table"),
      storage_name = "release_logs"
    )
  )
  expect_snapshot(
    test_gitstats_priv$print_storage_attribute(
      storage_data = test_mocker$use("repos_trees"),
      storage_name = "repos_trees"
    )
  )
})

test_that("show_orgs print orgs properly", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  expect_equal(
    test_gitstats$show_orgs(),
    c("github_test_org", "gitlab_test_group")
  )
})

test_that("show_orgs print subgroups properly", {
  skip_on_cran()
  suppressMessages(
    test_gitstats <- create_gitstats() %>%
      set_gitlab_host(
        token = Sys.getenv("GITLAB_PAT_PUBLIC"),
        orgs = "mbtests/subgroup"
      )
  )
  expect_equal(
    test_gitstats$show_orgs(),
    "mbtests/subgroup"
  )
})

test_that("subgroups are cleanly printed in GitStats", {
  skip_on_cran()
  suppressMessages(
    test_gitstats <- create_gitstats() %>%
      set_gitlab_host(
        token = Sys.getenv("GITLAB_PAT_PUBLIC"),
        orgs = "mbtests/subgroup"
      )
  )
  expect_snapshot(
    test_gitstats
  )
})
