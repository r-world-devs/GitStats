gl_group <- "mbtests"

gl_files_structure_shallow <- list(
  "gitstatstesting" = c("README.md"),
  "graphql_tests" = c("README.md", "CHANGELOG.md")
)
test_mocker$cache(gl_files_structure_shallow)

test_that("get_files_structure_from_orgs pulls files structure for repositories in orgs", {
  if (integration_tests_skipped) {
    mockery::stub(
      gitlab_testhost_priv$get_files_structure_from_orgs,
      "private$get_files_structure_from_repos_data",
      test_mocker$use("gl_files_structure_shallow")
    )
  }
  gl_files_structure_from_orgs <- gitlab_testhost_priv$get_files_structure_from_orgs(
    pattern = "\\.md",
    depth = 1L,
    verbose = FALSE,
    progress = FALSE
  )
  expect_equal(
    names(gl_files_structure_from_orgs),
    gl_group
  )
  purrr::walk(gl_files_structure_from_orgs[[1]], function(repo_files) {
    expect_true(all(grepl("\\.md", repo_files)))
  })
  test_mocker$cache(gl_files_structure_from_orgs)
})

test_that("get_files_structure_from_orgs prints messages without pattern", {
  mockery::stub(
    gitlab_testhost_priv$get_files_structure_from_orgs,
    "private$get_files_structure_from_repos_data",
    test_mocker$use("gl_files_structure_shallow")
  )
  gitlab_testhost_priv$searching_scope <- "org"
  expect_snapshot(
    gl_files_structure <- gitlab_testhost_priv$get_files_structure_from_orgs(
      pattern = NULL,
      depth = Inf,
      verbose = TRUE,
      progress = FALSE
    )
  )
})

test_that("get_files_structure_from_orgs warns when no structure found", {
  mockery::stub(
    gitlab_testhost_priv$get_files_structure_from_orgs,
    "private$get_files_structure_from_repos_data",
    list()
  )
  gitlab_testhost_priv$searching_scope <- "org"
  expect_snapshot(
    gl_files_structure <- gitlab_testhost_priv$get_files_structure_from_orgs(
      pattern = NULL,
      depth = Inf,
      verbose = TRUE,
      progress = FALSE
    )
  )
})

test_that("get_files_structure_from_repos pulls files structure for repositories", {
  mockery::stub(
    gitlab_testhost_priv$get_files_structure_from_repos,
    "private$get_files_structure_from_repos_data",
    test_mocker$use("gl_files_structure_shallow")
  )
  test_org <- "mbtests"
  attr(test_org, "type") <- "organization"
  mockery::stub(
    gitlab_testhost_priv$get_files_structure_from_repos,
    "graphql_engine$set_owner_type",
    test_org
  )
  gitlab_testhost_priv$searching_scope <- "repo"
  gl_files_structure_from_repos <- gitlab_testhost_priv$get_files_structure_from_repos(
    pattern = "\\.md",
    depth = 1L,
    verbose = FALSE,
    progress = FALSE
  )
  expect_equal(
    names(gl_files_structure_from_repos),
    gl_group
  )
  purrr::walk(gl_files_structure_from_repos[[1]], function(repo_files) {
    expect_true(all(grepl("\\.md", repo_files)))
  })
  gitlab_testhost_priv$searching_scope <- "org"
})

test_that("get_files_structure_from_repos prints message", {
  mockery::stub(
    gitlab_testhost_priv$get_files_structure_from_repos,
    "private$get_files_structure_from_repos_data",
    test_mocker$use("gl_files_structure_shallow")
  )
  test_org <- "test_group"
  attr(test_org, "type") <- "organization"
  mockery::stub(
    gitlab_testhost_priv$get_files_structure_from_repos,
    "graphql_engine$set_owner_type",
    test_org
  )
  gitlab_testhost_priv$searching_scope <- "repo"
  expect_snapshot(
    gl_files_structure_from_repos <- gitlab_testhost_priv$get_files_structure_from_repos(
      pattern = "\\.md",
      depth = 1L,
      verbose = TRUE,
      progress = FALSE
    )
  )
  gitlab_testhost_priv$searching_scope <- "org"
})

test_that("get_path_from_files_structure gets file path from files structure", {
  test_graphql_gitlab <- EngineGraphQLGitLab$new(
    gql_api_url = "https://gitlab.com/api/v4/graphql",
    token = Sys.getenv("GITHLAB_PAT_PUBLIC")
  )
  test_graphql_gitlab <- environment(test_graphql_gitlab$initialize)$private
  file_path <- test_graphql_gitlab$get_path_from_files_structure(
    host_files_structure = test_mocker$use("gl_files_structure_from_orgs"),
    org = gl_group # this will need fixing and repo parameter must come back
  )
  expect_type(file_path, "character")
  expect_gt(length(file_path), 0)
})

test_that("get_files_structure pulls files structure for repositories in orgs", {
  mockery::stub(
    gitlab_testhost$get_files_structure,
    "private$get_files_structure_from_orgs",
    test_mocker$use("gl_files_structure_from_orgs")
  )
  gl_files_structure_from_orgs <- gitlab_testhost$get_files_structure(
    pattern = "\\.md",
    depth = 1L,
    verbose = FALSE,
    progress = FALSE
  )
  expect_equal(
    names(gl_files_structure_from_orgs),
    gl_group
  )
  purrr::walk(gl_files_structure_from_orgs[[1]], function(repo_files) {
    expect_true(all(grepl("\\.md", repo_files)))
  })
  test_mocker$cache(gl_files_structure_from_orgs)
})

test_that("get_files_structure pulls empty files structure", {
  gl_empty_files_stucture <- gitlab_testhost$get_files_structure(
    pattern = "\\.test",
    depth = 1L,
    verbose = FALSE,
    progress = FALSE
  )
  expect_type(
    gl_empty_files_stucture,
    "list"
  )
  expect_length(
    gl_empty_files_stucture,
    0L
  )
  test_mocker$cache(gl_empty_files_stucture)
})
