test_that("files tree query for GitHub are built properly", {
  gh_files_tree_query <-
    test_gqlquery_gh$files_tree_from_repo()
  expect_snapshot(
    gh_files_tree_query
  )
  test_mocker$cache(gh_files_tree_query)
})

if (integration_tests_skipped) {
  gh_org <- "test_org"
  gh_repo <- "TestRepo"
} else {
  gh_org <- "r-world-devs"
  gh_repo <- "GitStats"
}

test_that("get_file_response works", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_github_priv$get_file_response,
      "self$gql_response",
      test_fixtures$github_files_tree_response
    )
  }
  gh_files_tree_response <- test_graphql_github_priv$get_file_response(
    org = gh_org,
    repo = gh_repo,
    def_branch = "master",
    file_path = "",
    files_query = test_mocker$use("gh_files_tree_query")
  )
  expect_github_files_raw_response(
    gh_files_tree_response
  )
  test_mocker$cache(gh_files_tree_response)
})

test_that("get_dirs_and_files returns list with directories and files", {
  files_and_dirs_list <- test_graphql_github_priv$get_files_and_dirs(
    files_tree_response = test_mocker$use("gh_files_tree_response")
  )
  expect_type(
    files_and_dirs_list,
    "list"
  )
  expect_list_contains(
    files_and_dirs_list,
    c("files", "dirs")
  )
  test_mocker$cache(files_and_dirs_list)
})

test_that("get_files_structure_from_repo returns list with files and dirs vectors", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_github_priv$get_files_structure_from_repo,
      "private$get_file_response",
      test_mocker$use("gh_files_tree_response")
    )
    files_and_dirs <- test_mocker$use("files_and_dirs_list")
    files_and_dirs$dirs <- character()
    mockery::stub(
      test_graphql_github_priv$get_files_structure_from_repo,
      "private$get_files_and_dirs",
      files_and_dirs
    )
  }
  files_structure <- test_graphql_github_priv$get_files_structure_from_repo(
    org = gh_org,
    repo = gh_repo,
    def_branch = "master"
  )
  expect_type(
    files_structure,
    "character"
  )
})

test_that("get_files_structure_from_repo returns list of files up to 2 tier of dirs", {
  mockery::stub(
    test_graphql_github_priv$get_files_structure_from_repo,
    "private$get_file_response",
    test_mocker$use("gh_files_tree_response")
  )
  mockery::stub(
    test_graphql_github_priv$get_files_structure_from_repo,
    "private$get_files_and_dirs",
    files_and_dirs <- test_mocker$use("files_and_dirs_list")
  )
  files_structure_very_shallow <- test_graphql_github_priv$get_files_structure_from_repo(
    org = gh_org,
    repo = gh_repo,
    def_branch = "master",
    depth = 1L
  )
  files_structure_shallow <- test_graphql_github_priv$get_files_structure_from_repo(
    org = gh_org,
    repo = gh_repo,
    def_branch = "master",
    depth = 2L
  )
  expect_type(
    files_structure_shallow,
    "character"
  )
  expect_true(
    length(files_structure_very_shallow) < length(files_structure_shallow)
  )
  files_structure <- files_structure_shallow
  test_mocker$cache(files_structure)
})

test_that("only files with certain pattern are retrieved", {
  md_files_structure <- test_graphql_github_priv$filter_files_by_pattern(
    files_structure = test_mocker$use("files_structure"),
    pattern = "\\.md|\\.qmd|\\.Rmd"
  )
  files_structure <- test_mocker$use("files_structure")
  expect_true(
    length(md_files_structure) > 0
  )
  expect_true(
    length(md_files_structure) < length(files_structure)
  )
  test_mocker$cache(md_files_structure)
})

test_that("get_repos_data pulls data on repos and branches", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_github_priv$get_repos_data,
      "self$get_repos_from_org",
      test_mocker$use("gh_repos_from_org")
    )
  }
  gh_repos_data <- test_graphql_github_priv$get_repos_data(
    org = gh_org,
    owner_type = "organization",
    repos = NULL
  )
  expect_equal(
    names(gh_repos_data),
    c("repositories", "def_branches")
  )
  expect_true(
    length(gh_repos_data$repositories) > 0
  )
  expect_true(
    length(gh_repos_data$def_branches) > 0
  )
  test_mocker$cache(gh_repos_data)
})

test_that("GitHub GraphQL Engine pulls files structure from repositories", {
  if (integration_tests_skipped) {
    mockery::stub(
      test_graphql_github$get_files_structure_from_org,
      "private$get_repos_data",
      test_mocker$use("gh_repos_data")
    )
    mockery::stub(
      test_graphql_github$get_files_structure_from_org,
      "private$get_files_structure_from_repo",
      test_mocker$use("files_structure")
    )
    gh_repos <- c("TestRepo", "TestRepo1", "TestRepo2", "TestRepo3", "TestRepo4")
  } else {
    gh_repos <- c("cohortBuilder", "GitStats", "GitAI")
  }
  gh_files_structure <- test_graphql_github$get_files_structure_from_org(
    org = gh_org,
    owner_type = "organization",
    repos = gh_repos
  )
  purrr::walk(gh_files_structure, ~ expect_true(length(.) > 0))
  expect_equal(
    names(gh_files_structure),
    gh_repos
  )
  test_mocker$cache(gh_files_structure)
})

test_that("GitHub GraphQL Engine pulls files structure with pattern from repositories", {
  mockery::stub(
    test_graphql_github$get_files_structure_from_org,
    "private$get_repos_data",
    test_mocker$use("gh_repos_data")
  )
  mockery::stub(
    test_graphql_github$get_files_structure_from_org,
    "private$get_files_structure_from_repo",
    test_mocker$use("md_files_structure")
  )
  gh_md_files_structure <- test_graphql_github$get_files_structure_from_org(
    org = gh_org,
    owner_type = "organization",
    repos = gh_repo,
    pattern = "\\.md|\\.qmd|\\.Rmd"
  )
  purrr::walk(gh_md_files_structure, ~ expect_true(all(grepl("\\.md|\\.qmd|\\.Rmd", .))))
  test_mocker$cache(gh_md_files_structure)
})

test_that("get_files_structure_from_orgs() works", {
  mockery::stub(
    github_testhost_priv$get_files_structure_from_orgs,
    "graphql_engine$get_files_structure_from_org",
    test_mocker$use("gh_md_files_structure")
  )
  github_testhost_priv$searching_scope <- "org"
  gh_files_structure_from_orgs <- github_testhost_priv$get_files_structure_from_orgs(
    pattern = "\\.md|\\.qmd|\\.Rmd",
    depth = Inf,
    verbose = FALSE
  )
  expect_gt(
    length(gh_files_structure_from_orgs),
    0
  )
  expect_equal(
    names(gh_files_structure_from_orgs),
    gh_org
  )
  test_mocker$cache(gh_files_structure_from_orgs)
})

test_that("get_files_structure_from_orgs() prints message", {
  mockery::stub(
    github_testhost_priv$get_files_structure_from_orgs,
    "graphql_engine$get_files_structure_from_org",
    test_mocker$use("gh_md_files_structure")
  )
  github_testhost_priv$searching_scope <- "org"
  expect_snapshot(
    gh_files_structure_from_orgs <- github_testhost_priv$get_files_structure_from_orgs(
      pattern = "\\.md|\\.qmd|\\.Rmd",
      depth = Inf,
      verbose = TRUE
    )
  )
  expect_snapshot(
    gh_files_structure_from_orgs <- github_testhost_priv$get_files_structure_from_orgs(
      pattern = NULL,
      depth = Inf,
      verbose = TRUE
    )
  )
})

test_that("get_files_structure_from_repos() works", {
  test_org <- "test_org"
  attr(test_org, "type") <- "organization"
  mockery::stub(
    github_testhost_priv$get_files_structure_from_repos,
    "graphql_engine$set_owner_type",
    test_org
  )
  mockery::stub(
    github_testhost_priv$get_files_structure_from_repos,
    "graphql_engine$get_files_structure_from_org",
    test_mocker$use("gh_md_files_structure")
  )
  github_testhost_priv$searching_scope <- "repo"
  gh_files_structure_from_repos <- github_testhost_priv$get_files_structure_from_repos(
    pattern = "\\.md|\\.qmd|\\.Rmd",
    depth = Inf,
    verbose = FALSE
  )
  expect_gt(
    length(gh_files_structure_from_repos),
    0
  )
  expect_equal(
    names(gh_files_structure_from_repos),
    gh_org
  )
  test_mocker$cache(gh_files_structure_from_repos)
})

test_that("get_files_structure_from_repos() prints message", {
  test_org <- "test_org"
  attr(test_org, "type") <- "organization"
  mockery::stub(
    github_testhost_priv$get_files_structure_from_repos,
    "graphql_engine$set_owner_type",
    test_org
  )
  mockery::stub(
    github_testhost_priv$get_files_structure_from_repos,
    "graphql_engine$get_files_structure_from_org",
    test_mocker$use("gh_md_files_structure")
  )
  github_testhost_priv$searching_scope <- "repo"
  expect_snapshot(
    gh_files_structure_from_repos <- github_testhost_priv$get_files_structure_from_repos(
      pattern = "\\.md|\\.qmd|\\.Rmd",
      depth = Inf,
      verbose = TRUE
    )
  )
  expect_snapshot(
    gh_files_structure_from_repos <- github_testhost_priv$get_files_structure_from_repos(
      pattern = NULL,
      depth = Inf,
      verbose = TRUE
    )
  )
})

test_that("get_orgs_and_repos_from_files_structure", {
  result <- github_testhost_priv$get_orgs_and_repos_from_files_structure(
    files_structure = test_mocker$use("gh_files_structure_from_orgs")
  )
  expect_equal(
    names(result),
    c("orgs", "repos")
  )
  purrr::walk(result, ~ expect_true(length(.) > 0))
})

test_that("when files_structure is empty, appropriate message is returned", {
  github_testhost_priv <- create_github_testhost(
    repos = c("r-world-devs/GitStats", "openpharma/DataFakeR", "openpharma/VisR"),
    mode = "private"
  )
  mockery::stub(
    github_testhost_priv$get_files_structure_from_repos,
    "graphql_engine$get_files_structure_from_org",
    list() |>
      purrr::set_names()
  )
  github_testhost_priv$searching_scope <- "repo"
  expect_snapshot(
    github_testhost_priv$get_files_structure_from_repos(
      pattern = "\\.png",
      depth = 1L,
      verbose = TRUE
    )
  )
})

test_that("get_path_from_files_structure gets file path from files structure", {
  test_graphql_github <- EngineGraphQLGitHub$new(
    gql_api_url = "https://api.github.com/graphql",
    token = Sys.getenv("GITHUB_PAT")
  )
  test_graphql_github <- environment(test_graphql_github$initialize)$private
  file_path <- test_graphql_github$get_path_from_files_structure(
    host_files_structure = test_mocker$use("gh_files_structure_from_orgs"),
    org = gh_org,
    repo = gh_repo
  )
  expect_equal(typeof(file_path), "character")
  expect_true(length(file_path) > 0)
})

test_that("get_files_structure pulls files structure for repositories in orgs", {
  mockery::stub(
    github_testhost$get_files_structure,
    "private$get_files_structure_from_orgs",
    test_mocker$use("gh_files_structure_from_orgs")
  )
  gh_files_structure_from_orgs <- github_testhost$get_files_structure(
    pattern = "\\.md|\\.qmd",
    depth = 1L,
    verbose = FALSE
  )
  expect_equal(
    names(gh_files_structure_from_orgs),
    gh_org
  )
  purrr::walk(gh_files_structure_from_orgs[[1]], function(repo_files) {
    expect_true(any(grepl("\\.md|\\.Rmd", repo_files)))
  })
  test_mocker$cache(gh_files_structure_from_orgs)
})

test_that("get_files_structure aborts when scope to scan whole host", {
  github_testhost$.__enclos_env__$private$scan_all <- TRUE
  expect_snapshot_error(
    github_testhost$get_files_structure(
      pattern = "\\.md|\\.qmd",
      depth = 1L,
      verbose = FALSE
    )
  )
})
