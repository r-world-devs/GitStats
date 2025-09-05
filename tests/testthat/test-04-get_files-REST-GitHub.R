test_that("get_files_content works", {
  mockery::stub(
    test_rest_github_priv$get_files_content,
    "self$response",
    test_fixtures$github_file_rest_response
  )
  github_files_content <- test_rest_github_priv$get_files_content(
    search_result = test_fixtures$github_search_response,
    filename = "test.R"
  )
  expect_type(github_files_content, "list")
  test_mocker$cache(github_files_content)
})

test_that("get_files works as expected", {
  mockery::stub(
    test_rest_github$get_files,
    "private$get_files_content",
    test_mocker$use("github_files_content")
  )
  mockery::stub(
    test_rest_github$get_files,
    "private$search_response",
    test_fixtures$github_search_response$items
  )
  mockery::stub(
    test_rest_github$get_files,
    "self$response",
    test_fixtures$github_search_response
  )
  files <- test_rest_github$get_files(
    file_paths = "examples/test1.R",
    verbose = TRUE
  )
  expect_type(files, "list")
  expect_length(files, 1)
})
