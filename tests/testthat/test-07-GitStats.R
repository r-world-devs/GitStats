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

test_that("get_repos works properly", {
  test_gitstats <- create_test_gitstats(
    hosts = 2
  )
  repos_table <- test_gitstats$get_repos(verbose = FALSE)
  expect_repos_table(
    repos_table,
    repo_cols = repo_gitstats_colnames
  )
  test_mocker$cache(repos_table)
})

test_that("get_repos pulls repositories without contributors", {
  repos_table <- test_gitstats$get_repos(add_contributors = FALSE, verbose = FALSE)
  expect_repos_table(repos_table, repo_cols = repo_gitstats_colnames)
  expect_false("contributors" %in% names(repos_table))
})

test_that("get_commits works properly", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  suppressMessages(
    commits_table <- test_gitstats$get_commits(
      since = "2023-06-15",
      until = "2023-06-30",
      verbose = FALSE
    )
  )
  expect_commits_table(
    commits_table
  )
  test_mocker$cache(commits_table)
})

test_that("get_files works properly", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  files_table <- test_gitstats$get_files(
    file_path = "meta_data.yaml",
    verbose = FALSE
  )
  expect_files_table(
    files_table, add_col = "api_url"
  )
  test_mocker$cache(files_table)
})

test_that("show_orgs print orgs properly", {
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

test_that("get_R_package_usage works as expected", {
  test_gitstats <- create_test_gitstats(hosts = 1)
  suppressMessages(
    R_package_usage <- test_gitstats$get_R_package_usage(
      package_name = "purrr", verbose = FALSE
    )
  )
  expect_package_usage_table(R_package_usage)
  test_mocker$cache(R_package_usage)
})

test_that("get_release_logs works as expected", {
  test_gitstats <- create_test_gitstats(hosts = 1)
  release_logs <- test_gitstats$get_release_logs(
    since = "2023-05-01",
    until = "2023-09-30",
    verbose = FALSE
  )
  expect_releases_table(release_logs)
})

test_that("get_repo_urls gets vector of repository URLS", {
  test_gitstats <- create_test_gitstats(hosts = 1)
  repo_urls <- test_gitstats$get_repos_urls(
    with_files = c("DESCRIPTION", "NEWS.md", "LICENSE"),
    verbose = FALSE
  )
  expect_type(
    repo_urls,
    "character"
  )
  expect_gt(
    length(repo_urls),
    1
  )
})
