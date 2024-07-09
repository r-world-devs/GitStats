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

test_gitstats_priv <- create_test_gitstats(hosts = 2, priv_mode = TRUE)

test_that("get_repos_urls_from_hosts gets data from the hosts", {
  mockery::stub(
    test_gitstats_priv$get_repos_urls_from_hosts,
    "host$get_repos_urls",
    c(test_mocker$use("gh_api_repos_urls"), test_mocker$use("gl_api_repos_urls"))
  )
  repos_urls_from_hosts <- test_gitstats_priv$get_repos_urls_from_hosts(
    type = "api",
    with_code = NULL,
    in_files = NULL,
    with_files = NULL,
    verbose = FALSE
  )
  expect_type(repos_urls_from_hosts, "character")
  expect_gt(length(repos_urls_from_hosts), 0)
  expect_true(any(grepl("gitlab.com/api", repos_urls_from_hosts)))
  expect_true(any(grepl("api.github", repos_urls_from_hosts)))
  test_mocker$cache(repos_urls_from_hosts)
})

test_that("get_repos_urls_from_hosts gets data with_code in_files from the hosts", {
  mockery::stub(
    test_gitstats_priv$get_repos_urls_from_hosts,
    "private$get_repos_urls_from_host_with_code",
    c(test_mocker$use("gh_repos_urls_with_code_in_files"), test_mocker$use("gl_repos_urls_with_code_in_files"))
  )
  repos_urls_from_hosts_with_code_in_files <- test_gitstats_priv$get_repos_urls_from_hosts(
    type = "api",
    with_code = "shiny",
    in_files = "DESCRIPTION",
    with_files = NULL,
    verbose = FALSE
  )
  expect_type(repos_urls_from_hosts_with_code_in_files, "character")
  expect_gt(length(repos_urls_from_hosts_with_code_in_files), 0)
  expect_true(any(grepl("gitlab.com", repos_urls_from_hosts_with_code_in_files)))
  expect_true(any(grepl("github.com", repos_urls_from_hosts_with_code_in_files)))
  test_mocker$cache(repos_urls_from_hosts_with_code_in_files)
})

test_that("get_repos_table with_code works", {
  mockery::stub(
    test_gitstats_priv$get_repos_table,
    "private$get_repos_from_host_with_code",
    purrr::list_rbind(
      list(test_mocker$use("gh_repos_by_code_table"),
           test_mocker$use("gl_repos_by_code_table"))
    )
  )
  repos_table <- test_gitstats_priv$get_repos_table(
    with_code = "shiny",
    in_files = "DESCRIPTION",
    with_files = NULL,
    verbose = FALSE,
    settings = test_settings
  )
  expect_repos_table(
    repos_table,
    repo_cols = repo_gitstats_colnames,
    add_col = c("contributors", "contributors_n")
  )
  test_mocker$cache(repos_table)
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
  test_gitstats <- create_test_gitstats(hosts = 2)
  repos_table <- test_gitstats$get_repos(verbose = FALSE)
  expect_repos_table(
    repos_table,
    repo_cols = repo_gitstats_colnames
  )
  test_mocker$cache(repos_table)
})

test_that("get_repos pulls repositories without contributors", {
  test_gitstats <- create_test_gitstats(hosts = 2)
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

test_that("get_repos_urls gets vector of repository URLS", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  mockery::stub(
    test_gitstats$get_repos_urls,
    "private$get_repos_urls_from_hosts",
    test_mocker$use("repos_urls_from_hosts")
  )
  repo_urls <- test_gitstats$get_repos_urls(
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

test_that("get_repos_urls gets vector of repository URLS", {
  test_gitstats <- create_test_gitstats(hosts = 2)
  mockery::stub(
    test_gitstats$get_repos_urls,
    "private$get_repos_urls_from_hosts",
    test_mocker$use("repos_urls_from_hosts_with_code_in_files")
  )
  repo_urls <- test_gitstats$get_repos_urls(
    with_code = "shiny",
    in_files = "DESCRIPTION",
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
