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
