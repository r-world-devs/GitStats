test_that("get_files_from_hosts works properly", {
  mockery::stub(
    test_gitstats_priv$get_files_from_hosts,
    "host$get_files_content",
    purrr::list_rbind(
      list(
        test_mocker$use("gh_files_table"),
        test_mocker$use("gl_files_table")
      )
    )
  )
  files_table <- test_gitstats_priv$get_files_from_hosts(
    pattern = NULL,
    depth = Inf,
    file_path = "meta_data.yaml",
    verbose = FALSE,
    progress = FALSE
  )
  expect_files_table(
    files_table,
    with_cols = "api_url"
  )
  test_mocker$cache(files_table)
})

test_that("get_files_from_hosts works properly", {
  mockery::stub(
    test_gitstats_priv$get_files_from_hosts,
    "host$get_files_structure",
    test_mocker$use("gh_files_structure_from_orgs")
  )
  mockery::stub(
    test_gitstats_priv$get_files_from_hosts,
    "host$get_files_content",
    purrr::list_rbind(
      list(
        test_mocker$use("gh_files_table"),
        test_mocker$use("gl_files_table")
      )
    )
  )
  files_table <- test_gitstats_priv$get_files_from_hosts(
    pattern = "\\.md",
    depth = Inf,
    file_path = NULL,
    verbose = FALSE,
    progress = FALSE
  )
  expect_files_table(
    files_table,
    with_cols = "api_url"
  )
  test_mocker$cache(files_table)
})

test_that("get_files works properly", {
  mockery::stub(
    test_gitstats$get_files,
    "private$get_files_from_hosts",
    test_mocker$use("files_table")
  )
  files_table <- test_gitstats$get_files(
    pattern = NULL,
    depth = Inf,
    file_path = "meta_data.yaml",
    verbose = FALSE
  )
  expect_files_table(
    files_table,
    with_cols = "api_url"
  )
  test_mocker$cache(files_table)
  mockery::stub(
    get_files,
    "gitstats$get_files",
    test_mocker$use("files_table")
  )
  get_files(test_gitstats,
            file_path = "meta_data.yaml",
            verbose = FALSE,
            progress = FALSE)
  expect_files_table(
    files_table,
    with_cols = "api_url"
  )
})

test_that("error shows when file_path and pattern are defined at the same time", {
  expect_snapshot_error(
    get_files(test_gitstats,
              pattern = "\\.md",
              file_path = "meta_data.yaml",
              verbose = FALSE,
              progress = FALSE)
  )
})
