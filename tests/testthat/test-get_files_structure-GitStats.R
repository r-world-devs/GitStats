test_that("get_files_structure_from_hosts works as expected", {
  mockery::stub(
    test_gitstats_priv$get_files_structure_from_hosts,
    "host$get_files_structure",
    test_mocker$use("gh_files_structure_from_orgs")
  )
  files_structure_from_hosts <- test_gitstats_priv$get_files_structure_from_hosts(
    pattern = "\\.md|\\.qmd\\.Rmd",
    depth = 1L,
    verbose = FALSE
  )
  expect_equal(names(files_structure_from_hosts),
               c("github.com", "gitlab.com"))
  expect_equal(names(files_structure_from_hosts[[1]]), c("test-org"))
  files_structure_from_hosts[[2]] <- test_mocker$use("gl_files_structure_from_orgs")
  test_mocker$cache(files_structure_from_hosts)
})

test_that("if returned files_structure is empty, do not store it and give proper message", {
  mockery::stub(
    test_gitstats_priv$get_files_structure_from_hosts,
    "host$get_files_structure",
    list()
  )
  expect_snapshot(
    files_structure <- test_gitstats_priv$get_files_structure_from_hosts(
      pattern = "\\.png",
      depth = 1L,
      verbose = TRUE
    )
  )
})

test_that("get_files_structure works as expected", {
  mockery::stub(
    test_gitstats$get_files_structure,
    "private$get_files_structure_from_hosts",
    test_mocker$use("files_structure_from_hosts")
  )
  files_structure <- test_gitstats$get_files_structure(
    pattern = "\\.md",
    depth = 2L,
    verbose = FALSE
  )
  expect_s3_class(files_structure, "files_structure")
  test_mocker$cache(files_structure)
})
