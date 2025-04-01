test_that("get_R_package_as_dependency work correctly", {
  mockery::stub(
    test_gitstats_priv$get_R_package_as_dependency,
    "private$get_repos_from_hosts",
    test_mocker$use("repos_from_hosts")
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

test_that("get_R_package_loading work correctly", {
  mockery::stub(
    test_gitstats_priv$get_R_package_loading,
    "private$get_repos_from_hosts",
    test_mocker$use("repos_from_hosts")
  )
  R_package_loading <- test_gitstats_priv$get_R_package_loading(
    package_name = "purrr",
    verbose = FALSE
  )
  expect_s3_class(
    R_package_loading,
    "data.frame"
  )
  expect_gt(
    nrow(R_package_loading),
    0
  )
  test_mocker$cache(R_package_loading)
})

test_that("get_R_package_loading turns to othed method if it reaches 10 thous. limit", {
  mocked_error <- function(with_code, force_orgs, output, verbose, progress) {
    if (force_orgs) {
      return(data.frame())
    } else {
      stop(structure(list(
        message = "",
        parent = structure(list(
          message = "",
          parent = structure(list(
            message = "Reached 10 thousand response limit."
          ))
        ))
      ), class = c("error", "condition")))
    }
  }
  mockery::stub(
    test_gitstats_priv$get_R_package_loading,
    "private$get_repos_from_hosts",
    mocked_error
  )
  mockery::stub(
    test_gitstats_priv$get_R_package_loading,
    "private$get_orgs_from_hosts",
    "test_org"
  )
  expect_snapshot(
    R_package_loading <- test_gitstats_priv$get_R_package_loading(
      package_name = "purrr",
      verbose = TRUE
    )
  )
})

test_that("get_repos_with_R_packages_from_hosts works as expected", {
  test_gitstats <- create_test_gitstats(hosts = 2, priv_mode = TRUE)
  mockery::stub(
    test_gitstats$get_repos_with_R_packages_from_hosts,
    "private$get_R_package_as_dependency",
    test_mocker$use("R_package_as_dependency")
  )
  mockery::stub(
    test_gitstats$get_repos_with_R_packages_from_hosts,
    "private$get_R_package_loading",
    test_mocker$use("R_package_loading")
  )
  R_package_usage_table <- test_gitstats$get_repos_with_R_packages_from_hosts(
    packages = c("shiny", "purrr"),
    only_loading = FALSE,
    verbose = FALSE
  )
  expect_package_usage_table(R_package_usage_table)
  test_mocker$cache(R_package_usage_table)
})

test_that("get_repos_with_R_packages_from_hosts with split_output works", {
  test_gitstats <- create_test_gitstats(hosts = 2, priv_mode = TRUE)
  mockery::stub(
    test_gitstats$get_repos_with_R_packages_from_hosts,
    "private$get_R_package_as_dependency",
    test_mocker$use("R_package_as_dependency")
  )
  mockery::stub(
    test_gitstats$get_repos_with_R_packages_from_hosts,
    "private$get_R_package_loading",
    test_mocker$use("R_package_loading")
  )
  R_package_usage_list <- test_gitstats$get_repos_with_R_packages_from_hosts(
    packages = c("shiny", "purrr"),
    only_loading = FALSE,
    split_output = TRUE,
    verbose = FALSE
  )
  expect_equal(names(R_package_usage_list), c("shiny", "purrr"))
  purrr::walk(R_package_usage_list, expect_package_usage_table)
})

test_that("when get_repos_with_R_packages_from_hosts output is empty return warning", {
  test_gitstats <- create_test_gitstats(hosts = 2, priv_mode = TRUE)
  mockery::stub(
    test_gitstats$get_repos_with_R_packages_from_hosts,
    "private$get_R_package_loading",
    data.frame()
  )
  mockery::stub(
    test_gitstats$get_repos_with_R_packages_from_hosts,
    "private$get_R_package_as_dependency",
    data.frame()
  )
  expect_snapshot(
    test_gitstats$get_repos_with_R_packages_from_hosts(
      packages = "non-existing-package",
      only_loading = FALSE,
      verbose = TRUE
    )
  )
})

test_that("get_repos_with_R_packages works", {
  mockery::stub(
    test_gitstats$get_repos_with_R_packages,
    "private$get_repos_with_R_packages_from_hosts",
    test_mocker$use("R_package_usage_table")
  )
  R_package_usage_table <- test_gitstats$get_repos_with_R_packages(
    packages = c("shiny", "purrr"),
    verbose = FALSE
  )
  expect_package_usage_table(R_package_usage_table)
  expect_s3_class(
    R_package_usage_table,
    "gitstats_package_usage"
  )
  test_mocker$cache(R_package_usage_table)
})

test_that("get_repos_with_R_packages works", {
  mockery::stub(
    get_repos_with_R_packages,
    "gitstats$get_repos_with_R_packages",
    test_mocker$use("R_package_usage_table")
  )
  R_package_usage_table <- get_repos_with_R_packages(
    gitstats = test_gitstats,
    packages = c("shiny", "purrr"),
    verbose = FALSE
  )
  expect_package_usage_table(R_package_usage_table)
  expect_s3_class(
    R_package_usage_table,
    "gitstats_package_usage"
  )
})

test_that("get_repos_with_R_packages records timespan of the process", {
  mockery::stub(
    get_repos_with_R_packages,
    "gitstats$get_repos_with_R_packages",
    test_mocker$use("R_package_usage_table")
  )
  expect_snapshot(
    R_package_usage_table <- get_repos_with_R_packages(
      gitstats = test_gitstats,
      packages = c("shiny", "purrr"),
      verbose = TRUE
    )
  )
})
