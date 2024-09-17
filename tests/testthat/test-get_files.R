# GraphQL Queries

test_that("files tree query for GitHub and GitLab are built properly", {
  gh_files_tree_query <-
    test_gqlquery_gh$files_tree_from_repo()
  expect_snapshot(
    gh_files_tree_query
  )
  test_mocker$cache(gh_files_tree_query)

  gl_files_tree_query <-
    test_gqlquery_gl$files_tree_from_repo()
  expect_snapshot(
    gl_files_tree_query
  )
  test_mocker$cache(gl_files_tree_query)
})

test_that("file queries for GitLab and GitHub are built properly", {
  gl_files_query <-
    test_gqlquery_gl$files_by_org()
  expect_snapshot(
    gl_files_query
  )
  gl_file_blobs_from_repo_query <-
    test_gqlquery_gl$file_blob_from_repo()
  expect_snapshot(
    gl_file_blobs_from_repo_query
  )
  test_mocker$cache(gl_file_blobs_from_repo_query)

  gh_file_blobs_from_repo_query <-
    test_gqlquery_gh$file_blob_from_repo()
  expect_snapshot(
    gh_file_blobs_from_repo_query
  )
  test_mocker$cache(gh_file_blobs_from_repo_query)
})

# GraphQL Requests - GitHub

test_graphql_github <- EngineGraphQLGitHub$new(
  gql_api_url = "https://api.github.com/graphql",
  token = Sys.getenv("GITHUB_PAT")
)

test_graphql_github_priv <- environment(test_graphql_github$initialize)$private

test_that("get_file_response works", {
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
  files_structure <- test_graphql_github_priv$get_files_structure_from_repo(
    org = "r-world-devs",
    repo = "GitStats",
    def_branch = "master"
  )
  expect_type(
    files_structure,
    "character"
  )
  test_mocker$cache(files_structure)
})

test_that("get_files_structure_from_repo returns list of files up to 2 tier of dirs", {
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
  files_structure <- test_mocker$use("files_structure")
  expect_true(
    length(files_structure_shallow) < length(files_structure)
  )
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
})

test_that("GitHub GraphQL Engine pulls files from organization", {
  github_files_response <- test_graphql_github$get_files_from_org(
    org = "r-world-devs",
    repos = NULL,
    file_paths = "LICENSE",
    only_text_files = TRUE,
    host_files_structure = NULL
  )
  expect_github_files_response(github_files_response)
  test_mocker$cache(github_files_response)
})

test_that("GitHub GraphQL Engine pulls .png files from organization", {
  github_png_files_response <- test_graphql_github$get_files_from_org(
    org = "r-world-devs",
    repos = NULL,
    file_paths = "man/figures/logo.png",
    only_text_files = FALSE,
    host_files_structure = NULL
  )
  expect_github_files_response(github_png_files_response)
  test_mocker$cache(github_png_files_response)
})

test_that("GitHub GraphQL Engine pulls files from defined repositories", {
  github_files_response <- test_graphql_github$get_files_from_org(
    org = "openpharma",
    repos = c("DataFakeR", "visR"),
    file_paths = "README.md",
    host_files_structure = NULL,
    only_text_files = TRUE
  )
  expect_github_files_response(github_files_response)
  expect_equal(length(github_files_response), 2)
})

test_that("GitHub GraphQL Engine pulls two files from a group", {
  github_files_response <- test_graphql_github$get_files_from_org(
    org = "r-world-devs",
    repos = NULL,
    file_paths = c("DESCRIPTION", "NAMESPACE"),
    host_files_structure = NULL,
    only_text_files = TRUE
  )
  expect_github_files_response(github_files_response)
  purrr::walk(github_files_response, ~ {expect_true(
    all(
      c("DESCRIPTION", "NAMESPACE") %in%
        names(.)
    )
  )
  })
})

test_that("GitHub GraphQL Engine pulls files structure from repositories", {
  gh_files_structure <- test_graphql_github$get_files_structure_from_org(
    org = "openpharma",
    repos = c("DataFakeR", "visR")
  )
  purrr::walk(gh_files_structure, ~ expect_true(length(.) > 0))
  expect_equal(
    names(gh_files_structure),
    c("visR", "DataFakeR")
  )
  test_mocker$cache(gh_files_structure)
})

test_that("GitHub GraphQL Engine pulls files structure with pattern from repositories", {
  gh_md_files_structure <- test_graphql_github$get_files_structure_from_org(
    org = "openpharma",
    repos = c("DataFakeR", "visR"),
    pattern = "\\.md"
  )
  purrr::walk(gh_md_files_structure, ~ expect_true(all(grepl("\\.md", .))))
})

# GraphQL Requests - GitLab

test_graphql_gitlab <- EngineGraphQLGitLab$new(
  gql_api_url = "https://gitlab.com/api/graphql",
  token = Sys.getenv("GITLAB_PAT_PUBLIC")
)

test_graphql_gitlab_priv <- environment(test_graphql_gitlab$initialize)$private

test_that("get_file_blobs_response() works", {
  gl_file_blobs_response <- test_graphql_gitlab_priv$get_file_blobs_response(
    org = "mbtests",
    repo = "graphql_tests",
    file_path = "README.md"
  )
  expect_gitlab_files_blob_response(gl_file_blobs_response)
  test_mocker$cache(gl_file_blobs_response)
})


test_that("get_files_tree_response() works", {
  gl_files_tree_response <- test_graphql_gitlab_priv$get_files_tree_response(
    org = "mbtests",
    repo = "graphql_tests",
    file_path = ""
  )
  expect_gitlab_files_tree_response(gl_files_tree_response)
  test_mocker$cache(gl_files_tree_response)
})

test_that("get_dirs_and_files() returns list with directories and files", {
  gl_files_and_dirs_list <- test_graphql_gitlab_priv$get_files_and_dirs(
    files_tree_response = test_mocker$use("gl_files_tree_response")
  )
  expect_type(
    gl_files_and_dirs_list,
    "list"
  )
  expect_list_contains(
    gl_files_and_dirs_list,
    c("files", "dirs")
  )
  expect_true(
    length(gl_files_and_dirs_list$files) > 0
  )
  expect_true(
    length(gl_files_and_dirs_list$dirs) > 0
  )
  test_mocker$cache(gl_files_and_dirs_list)
})

test_that("get_files_structure_from_repo() pulls files structure from repo", {
  gl_files_structure <- test_graphql_gitlab_priv$get_files_structure_from_repo(
    org = "mbtests",
    repo = "graphql_tests"
  )
  expect_type(
    gl_files_structure,
    "character"
  )
  test_mocker$cache(gl_files_structure)
})

test_that("get_files_structure_from_repo() pulls files structure (files matching pattern) from repo", {
  gl_files_structure <- test_graphql_gitlab_priv$get_files_structure_from_repo(
    org = "mbtests",
    repo = "graphql_tests",
    pattern = "\\.md"
  )
  expect_type(
    gl_files_structure,
    "character"
  )
  test_mocker$cache(gl_files_structure)
})

test_that("GitLab GraphQL Engine pulls files from a group", {
  gitlab_files_response <- test_graphql_gitlab$get_files_from_org(
    org = "mbtests",
    repos = NULL,
    file_paths = "meta_data.yaml",
    only_text_files = TRUE,
    host_files_structure = NULL
  )
  expect_gitlab_files_from_org_response(gitlab_files_response)
  test_mocker$cache(gitlab_files_response)
})

test_that("GitLab GraphQL Engine pulls files from org by iterating over repos", {
  gl_files_from_org <- test_graphql_gitlab$get_files_from_org_per_repo(
    org = "mbtests",
    repos = c("gitstatstesting", "gitstats-testing-2", "graphql_tests"),
    file_paths = c("DESCRIPTION", "project_metadata.yaml", "README.md")
  )
  expect_gitlab_files_from_org_by_repos_response(
    response = gl_files_from_org,
    expected_files = c("DESCRIPTION", "project_metadata.yaml", "README.md")
  )
})

test_that("GitLab GraphQL Engine pulls files only from defined projects", {
  gitlab_files_response <- test_graphql_gitlab$get_files_from_org(
    org = "mbtests",
    repos = c("gitstatstesting", "gitstats-testing-2", "gitstatstesting3"),
    file_paths = "README.md",
    host_files_structure = NULL,
    only_text_files = TRUE
  )
  expect_gitlab_files_from_org_response(gitlab_files_response)
  expect_equal(length(gitlab_files_response), 3)
})

test_that("GitLab GraphQL Engine pulls two files from a group", {
  gitlab_files_response <- test_graphql_gitlab$get_files_from_org(
    org = "mbtests",
    repos = NULL,
    file_paths = c("meta_data.yaml", "README.md"),
    host_files_structure = NULL,
    only_text_files = TRUE
  )
  expect_gitlab_files_from_org_response(gitlab_files_response)
  expect_true(
    all(
      c("meta_data.yaml", "README.md") %in%
        purrr::map_vec(gitlab_files_response, ~.$repository$blobs$nodes[[1]]$name)
    )
  )
})

test_that("GitLab GraphQL Engine pulls files structure from repositories", {
  gl_files_structure <- test_graphql_gitlab$get_files_structure_from_org(
    org = "mbtests",
    repos = c("gitstatstesting", "graphql_tests")
  )
  purrr::walk(gl_files_structure, ~ expect_true(length(.) > 0))
  expect_equal(
    names(gl_files_structure),
    c("graphql_tests", "gitstatstesting")
  )
  purrr::walk(gl_files_structure, ~ expect_false(all(grepl("/$", .)))) # no empty dirs
  test_mocker$cache(gl_files_structure)
})

test_that("GitLab GraphQL Engine pulls files structure from repositories", {
  gl_files_structure_shallow <- test_graphql_gitlab$get_files_structure_from_org(
    org = "mbtests",
    repos = c("gitstatstesting", "graphql_tests"),
    depth = 1L
  )
  purrr::walk(gl_files_structure_shallow, ~ expect_true(length(.) > 0))
  expect_equal(
    names(gl_files_structure_shallow),
    c("graphql_tests", "gitstatstesting")
  )
  purrr::walk(gl_files_structure_shallow, ~ expect_false(all(grepl("/", .)))) # no dirs
})

test_that("Gitlab GraphQL switches to pulling files per repositories when query is too complex", {
  mockery::stub(
    test_graphql_gitlab$get_files_from_org,
    "private$is_query_error",
    TRUE
  )
  mockery::stub(
    test_graphql_gitlab$get_files_from_org,
    "private$is_complexity_error",
    TRUE
  )
  expect_snapshot(
    gitlab_files_response_by_repos <- test_graphql_gitlab$get_files_from_org(
      org = "mbtests",
      repos = NULL,
      file_paths = c("DESCRIPTION", "project_metadata.yaml", "README.md"),
      host_files_structure = NULL,
      only_text_files = TRUE,
      verbose = TRUE,
      progress = FALSE
    )
  )
  expect_gitlab_files_from_org_by_repos_response(
    response = gitlab_files_response_by_repos,
    expected_files = c("DESCRIPTION", "project_metadata.yaml", "README.md")
  )
  test_mocker$cache(gitlab_files_response_by_repos)
})

# GitHost preparing output

github_testhost_priv <- create_github_testhost(orgs = "r-world-devs", mode = "private")

test_that("GitHubHost prepares table from files response", {
  gh_files_table <- github_testhost_priv$prepare_files_table(
    files_response = test_mocker$use("github_files_response"),
    org = "r-world-devs",
    file_path = "LICENSE"
  )
  expect_files_table(gh_files_table)
  test_mocker$cache(gh_files_table)
})

test_that("GitHubHost prepares table from png files (with no content) response", {
  gh_png_files_table <- github_testhost_priv$prepare_files_table(
    files_response = test_mocker$use("github_png_files_response"),
    org = "r-world-devs",
    file_path = "man/figures/logo.png"
  )
  expect_files_table(gh_png_files_table)
  expect_true(all(is.na(gh_png_files_table$file_content)))
  test_mocker$cache(gh_png_files_table)
})

test_that("get_files_content_from_orgs for GitHub works", {
  mockery::stub(
    github_testhost_priv$get_files_content_from_orgs,
    "private$prepare_files_table",
    test_mocker$use("gh_files_table")
  )
  gh_files_table <- github_testhost_priv$get_files_content_from_orgs(
    file_path = "DESCRIPTION",
    verbose = FALSE
  )
  expect_files_table(
    gh_files_table,
    with_cols = "api_url"
  )
  test_mocker$cache(gh_files_table)
})

test_that("get_files_structure_from_orgs pulls files structure for repositories in orgs", {
  github_testhost_priv <- create_github_testhost(
    repos = c("r-world-devs/GitStats", "openpharma/DataFakeR", "openpharma/VisR"),
    mode = "private"
  )
  expect_snapshot(
    gh_files_structure_from_orgs <- github_testhost_priv$get_files_structure_from_orgs(
      pattern = "\\.md|\\.qmd|\\.png",
      depth = 2L,
      verbose = TRUE
    )
  )
  expect_equal(
    names(gh_files_structure_from_orgs),
    c("r-world-devs", "openpharma")
  )
  purrr::walk(gh_files_structure_from_orgs[[1]], function(repo_files) {
    expect_true(all(grepl("\\.md|\\.qmd|\\.png", repo_files)))
  })
  test_mocker$cache(gh_files_structure_from_orgs)
})

test_that("when files_structure is empty, appropriate message is returned", {
  github_testhost_priv <- create_github_testhost(
    repos = c("r-world-devs/GitStats", "openpharma/DataFakeR", "openpharma/VisR"),
    mode = "private"
  )
  expect_snapshot(
    github_testhost_priv$get_files_structure_from_orgs(
      pattern = "\\.png",
      depth = 1L,
      verbose = TRUE
    )
  )
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

github_testhost <- create_github_testhost(orgs = "r-world-devs")

test_that("`get_files_content()` pulls files in the table format", {
  mockery::stub(
    github_testhost$get_files_content,
    "private$get_files_content_from_orgs",
    test_mocker$use("gh_files_table")
  )
  expect_snapshot(
    gh_files_table <- github_testhost$get_files_content(
      file_path = "LICENSE"
    )
  )
  expect_files_table(gh_files_table, with_cols = "api_url")
  test_mocker$cache(gh_files_table)
})

test_that("`get_files_content()` pulls files only for the repositories specified", {
  github_testhost <- create_github_testhost(
    repos = c("r-world-devs/GitStats", "openpharma/visR", "openpharma/DataFakeR"),
  )
  expect_snapshot(
    gh_files_table <- github_testhost$get_files_content(
      file_path = "renv.lock"
    )
  )
  expect_files_table(gh_files_table, with_cols = "api_url")
  expect_equal(nrow(gh_files_table), 2) # visR does not have renv.lock
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
    expect_true(all(grepl("\\.md|\\.qmd", repo_files)))
  })
  test_mocker$cache(gh_files_structure_from_orgs)
})

gitlab_testhost_priv <- create_gitlab_testhost(orgs = "mbtests", mode = "private")

test_that("checker properly identifies gitlab files responses", {
  expect_false(
    gitlab_testhost_priv$response_prepared_by_iteration(
      files_response = test_mocker$use("gitlab_files_response")
    )
  )
  expect_true(
    gitlab_testhost_priv$response_prepared_by_iteration(
      files_response = test_mocker$use("gitlab_files_response_by_repos")
    )
  )
})

test_that("GitLab prepares table from files response", {
  gl_files_table <- gitlab_testhost_priv$prepare_files_table(
    files_response = test_mocker$use("gitlab_files_response"),
    org = "mbtests",
    file_path = "meta_data.yaml"
  )
  expect_files_table(gl_files_table)
  test_mocker$cache(gl_files_table)
})

test_that("GitLab prepares table from files response prepared in alternative way", {
  gl_files_table <- gitlab_testhost_priv$prepare_files_table(
    files_response = test_mocker$use("gitlab_files_response_by_repos"),
    org = "mbtests",
    file_path = "meta_data.yaml"
  )
  expect_files_table(gl_files_table)
})

test_that("get_files_content_from_orgs for GitLab works", {
  mockery::stub(
    gitlab_testhost_priv$get_files_content_from_orgs,
    "private$prepare_files_table",
    test_mocker$use("gl_files_table")
  )
  suppressMessages(
    gl_files_table <- gitlab_testhost_priv$get_files_content_from_orgs(
      file_path = "meta_data.yaml",
      verbose = FALSE
    )
  )
  expect_files_table(
    gl_files_table, with_cols = "api_url"
  )
  test_mocker$cache(gl_files_table)
})

test_that("get_files_structure_from_orgs pulls files structure for repositories in orgs", {
  gitlab_testhost_priv <- create_gitlab_testhost(
    repos = c("mbtests/gitstatstesting", "mbtests/graphql_tests"),
    mode = "private"
  )
  expect_snapshot(
    gl_files_structure_from_orgs <- gitlab_testhost_priv$get_files_structure_from_orgs(
      pattern = "\\.md|\\.R",
      depth = 1L,
      verbose = TRUE
    )
  )
  expect_equal(
    names(gl_files_structure_from_orgs),
    c("mbtests")
  )
  purrr::walk(gl_files_structure_from_orgs[[1]], function(repo_files) {
    expect_true(all(grepl("\\.md|\\.R", repo_files)))
  })
})

test_that("get_files_structure_from_orgs pulls files structure for all repositories in orgs", {
  gitlab_testhost_priv <- create_gitlab_testhost(
    orgs = c("mbtests", "mbtestapps"),
    mode = "private"
  )
  gl_files_structure_from_orgs <- gitlab_testhost_priv$get_files_structure_from_orgs(
    pattern = "\\.md|\\.R",
    depth = 1L,
    verbose = FALSE
  )
  expect_equal(
    names(gl_files_structure_from_orgs),
    c("mbtests", "mbtestapps")
  )
  purrr::walk(gl_files_structure_from_orgs[[1]], function(repo_files) {
    expect_true(all(grepl("\\.md|\\.R", repo_files)))
  })
  test_mocker$cache(gl_files_structure_from_orgs)
})

test_that("get_path_from_files_structure gets file path from files structure", {
  test_graphql_gitlab <- EngineGraphQLGitLab$new(
    gql_api_url = "https://gitlab.com/api/v4/graphql",
    token = Sys.getenv("GITHLAB_PAT_PUBLIC")
  )
  test_graphql_gitlab <- environment(test_graphql_gitlab$initialize)$private
  file_path <- test_graphql_gitlab$get_path_from_files_structure(
    host_files_structure = test_mocker$use("gl_files_structure_from_orgs"),
    only_text_files = TRUE,
    org = "mbtests" # this will need fixing and repo parameter must come back
  )
  expect_equal(typeof(file_path), "character")
  expect_true(length(file_path) > 0)
})

gitlab_testhost <- create_gitlab_testhost(orgs = "mbtests")

test_that("`get_files_content()` pulls files in the table format", {
  mockery::stub(
    gitlab_testhost$get_files_content,
    "super$get_files_content",
    test_mocker$use("gl_files_table")
  )
  expect_snapshot(
    gl_files_table <- gitlab_testhost$get_files_content(
      file_path = "README.md"
    )
  )
  expect_files_table(gl_files_table, with_cols = "api_url")
  test_mocker$cache(gl_files_table)
})

test_that("`get_files_content()` pulls two files in the table format", {
  expect_snapshot(
    gl_files_table <- gitlab_testhost$get_files_content(
      file_path = c("meta_data.yaml", "README.md")
    )
  )
  expect_files_table(gl_files_table, with_cols = "api_url")
  expect_true(
    all(c("meta_data.yaml", "README.md") %in% gl_files_table$file_path)
  )
})

test_that("get_files_structure pulls files structure for repositories in orgs", {
  mockery::stub(
    gitlab_testhost$get_files_structure,
    "private$get_files_structure_from_orgs",
    test_mocker$use("gl_files_structure_from_orgs")
  )
  gl_files_structure_from_orgs <- gitlab_testhost$get_files_structure(
    pattern = "\\.md|\\.R",
    depth = 2L,
    verbose = FALSE
  )
  expect_equal(
    names(gl_files_structure_from_orgs),
    c("mbtests", "mbtestapps")
  )
  purrr::walk(gl_files_structure_from_orgs[[1]], function(repo_files) {
    expect_true(all(grepl("\\.md|\\.R", repo_files)))
  })
  test_mocker$cache(gl_files_structure_from_orgs)
})
