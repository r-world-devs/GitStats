test_that("add_file_info adds info to files search result", {
  mockery::stub(
    test_rest_gitlab_priv$add_file_info,
    "self$response",
    test_fixtures$gitlab_file_rest_response
  )
  file_info <- test_rest_gitlab_priv$add_file_info(
    files_search_result = test_fixtures$gitlab_search_response,
    filename = "test.R",
    clean_file_content = FALSE,
    verbose = TRUE,
    progress = FALSE
  )
  expect_type(file_info, "list")
  expect_length(file_info, 2)
  purrr::walk(file_info, ~ expect_equal(.$content, "test content"))
  test_mocker$cache(file_info)

  file_info_na <- test_rest_gitlab_priv$add_file_info(
    files_search_result = test_fixtures$gitlab_search_response,
    filename = "test.R",
    clean_file_content = TRUE,
    verbose = TRUE,
    progress = FALSE
  )
  purrr::walk(file_info_na, ~ expect_equal(.$content, NA))
})

test_that("get_files works as expected", {
  mockery::stub(
    test_rest_gitlab$get_files,
    "self$search_for_code",
    test_fixtures$gitlab_search_response
  )
  mockery::stub(
    test_rest_gitlab$get_files,
    "private$add_file_info",
    test_mocker$use("file_info")
  )
  files <- test_rest_gitlab$get_files(
    file_paths = "test.R",
    clean_files_content = FALSE,
    verbose = TRUE,
    progress = FALSE
  )
  expect_type(files, "list")
  expect_length(files, 2)
})
