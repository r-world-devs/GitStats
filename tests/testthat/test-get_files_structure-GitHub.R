test_that("files tree query for GitHub are built properly", {
  gh_files_tree_query <-
    test_gqlquery_gh$files_tree_from_repo()
  expect_snapshot(
    gh_files_tree_query
  )
  test_mocker$cache(gh_files_tree_query)
})

test_that("get_file_response works", {
  mockery::stub(
    test_graphql_github_priv$get_file_response,
    "self$gql_response",
    test_fixtures$github_files_tree_response
  )
  gh_files_tree_response <- test_graphql_github_priv$get_file_response(
    org = "r-world-devs",
    repo = "GitStats",
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
  files_and_dirs <- test_mocker$use("files_and_dirs_list")
  files_and_dirs$dirs <- character()
  mockery::stub(
    test_graphql_github_priv$get_files_structure_from_repo,
    "private$get_files_and_dirs",
    files_and_dirs
  )
  files_structure <- test_graphql_github_priv$get_files_structure_from_repo(
    org = "r-world-devs",
    repo = "GitStats",
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
    "private$get_files_tree_response",
    test_mocker$use("gh_files_tree_response")
  )
  files_structure_very_shallow <- test_graphql_github_priv$get_files_structure_from_repo(
    org = "r-world-devs",
    repo = "GitStats",
    def_branch = "master",
    depth = 1L
  )
  files_structure_shallow <- test_graphql_github_priv$get_files_structure_from_repo(
    org = "r-world-devs",
    repo = "GitStats",
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
    length(md_files_structure) < length(files_structure)
  )
  test_mocker$cache(md_files_structure)
})

test_that("GitHub GraphQL Engine pulls files structure from repositories", {
  mockery::stub(
    test_graphql_github$get_files_structure_from_org,
    "private$get_files_structure_from_repo",
    test_mocker$use("files_structure")
  )
  gh_files_structure <- test_graphql_github$get_files_structure_from_org(
    org = "r-world-devs",
    repos = c("GitStats")
  )
  purrr::walk(gh_files_structure, ~ expect_true(length(.) > 0))
  expect_equal(
    names(gh_files_structure),
    c("GitStats")
  )
  test_mocker$cache(gh_files_structure)
})

test_that("GitHub GraphQL Engine pulls files structure with pattern from repositories", {
  mockery::stub(
    test_graphql_github$get_files_structure_from_org,
    "private$get_files_structure_from_repo",
    test_mocker$use("md_files_structure")
  )
  gh_md_files_structure <- test_graphql_github$get_files_structure_from_org(
    org = "r-world-devs",
    repos = "GitStats",
    pattern = "\\.md|\\.qmd|\\.Rmd"
  )
  purrr::walk(gh_md_files_structure, ~ expect_true(all(grepl("\\.md|\\.qmd|\\.Rmd", .))))
})

test_that("get_files_structure_from_orgs pulls files structure for repositories in orgs", {
  github_testhost_priv <- create_github_testhost(
    repos = c("r-world-devs/GitStats", "openpharma/DataFakeR"),
    mode = "private"
  )
  mockery::stub(
    github_testhost_priv$get_files_structure_from_orgs,
    "graphql_engine$get_files_structure_from_org",
    test_mocker$use("gh_files_structure")
  )
  expect_snapshot(
    gh_files_structure_from_orgs <- github_testhost_priv$get_files_structure_from_orgs(
      pattern = NULL,
      depth = 2L,
      verbose = TRUE
    )
  )
  expect_equal(
    names(gh_files_structure_from_orgs),
    c("r-world-devs", "openpharma")
  )
  expect_true(any(grepl("\\.md|\\.qmd|\\.Rmd", gh_files_structure_from_orgs[[1]])))
  test_mocker$cache(gh_files_structure_from_orgs)
})

test_that("get_orgs_and_repos_from_files_structure", {
  result <- github_testhost_priv$get_orgs_and_repos_from_files_structure(
    host_files_structure = test_mocker$use("gh_files_structure_from_orgs")
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
    github_testhost_priv$get_files_structure_from_orgs,
    "graphql_engine$get_files_structure_from_org",
    list() |>
      purrr::set_names()
  )
  expect_snapshot(
    github_testhost_priv$get_files_structure_from_orgs(
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
    only_text_files = FALSE,
    org = "r-world-devs",
    repo = "GitStats"
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
    c("r-world-devs", "openpharma")
  )
  purrr::walk(gh_files_structure_from_orgs[[2]], function(repo_files) {
    expect_true(any(grepl("\\.md|\\.Rmd", repo_files)))
  })
  test_mocker$cache(gh_files_structure_from_orgs)
})

test_that("get_files_content makes use of files_structure", {
  mockery::stub(
    github_testhost_priv$get_files_content_from_orgs,
    "private$add_repo_api_url",
    test_mocker$use("gh_files_table")
  )
  expect_snapshot(
    files_content <- github_testhost_priv$get_files_content_from_orgs(
      file_path = NULL,
      host_files_structure = test_mocker$use("gh_files_structure_from_orgs")
    )
  )
  expect_files_table(
    files_content,
    with_cols = "api_url"
  )
})
