test_that("get_files_content works properly", {
  mockery::stub(
    test_gitstats$get_files_content,
    "private$get_files_content_from_hosts",
    purrr::list_rbind(
      list(
        test_mocker$use("gh_files_table"),
        test_mocker$use("gl_files_table")
      )
    )
  )
  files_table <- test_gitstats$get_files_content(
    file_path = "meta_data.yaml",
    verbose = FALSE
  )
  expect_files_table(
    files_table,
    with_cols = "api_url"
  )
  test_mocker$cache(files_table)
})
