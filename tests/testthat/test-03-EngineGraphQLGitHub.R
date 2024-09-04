test_graphql_github <- EngineGraphQLGitHub$new(
  gql_api_url = "https://api.github.com/graphql",
  token = Sys.getenv("GITHUB_PAT")
)

# private methods

test_graphql_github <- environment(test_graphql_github$initialize)$private

test_that("`pull_commits_page_from_repo()` pulls commits page from repository", {
  mockery::stub(
    test_graphql_github$pull_commits_page_from_repo,
    "self$gql_response",
    test_mocker$use("gh_commits_by_repo_gql_response")
  )
  commits_page <- test_graphql_github$pull_commits_page_from_repo(
    org = "r-world-devs",
    repo = "GitStats",
    since = "2023-01-01",
    until = "2023-02-28"
  )
  expect_gh_commit_gql_response(
    commits_page$data$repository$defaultBranchRef$target$history$edges[[1]]
  )
  test_mocker$cache(commits_page)
})

test_that("`pull_repos_page_from_org()` pulls repos page from GitHub organization", {
  mockery::stub(
    test_graphql_github$pull_repos_page,
    "self$gql_response",
    test_mocker$use("gh_repos_by_org_gql_response")
  )
  gh_repos_page <- test_graphql_github$pull_repos_page(
    org = "r-world-devs"
  )
  expect_gh_repos_gql_response(
    gh_repos_page
  )
  test_mocker$cache(gh_repos_page)
})

test_that("`pull_commits_from_one_repo()` prepares formatted list", {
  # overcome of infinite loop in pull_commits_from_repo
  commits_page <- test_mocker$use("commits_page")
  commits_page$data$repository$defaultBranchRef$target$history$pageInfo$hasNextPage <- FALSE

  mockery::stub(
    test_graphql_github$pull_commits_from_one_repo,
    "private$pull_commits_page_from_repo",
    commits_page
  )
  commits_from_repo <- test_graphql_github$pull_commits_from_one_repo(
    org = "r-world-devs",
    repo = "GitStats",
    since = "2023-01-01",
    until = "2023-02-28"
  )
  expect_gh_commit_gql_response(
    commits_from_repo[[1]]
  )
  test_mocker$cache(commits_from_repo)
})

test_that("get_file_response works", {
  files_tree_response <- test_graphql_github$get_file_response(
    org = "r-world-devs",
    repo = "GitStats",
    def_branch = "master",
    file_path = "",
    files_query = test_mocker$use("gh_files_tree_query")
  )
  expect_github_files_raw_response(
    files_tree_response
  )
  test_mocker$cache(files_tree_response)
})

test_that("get_dirs_and_files returns list with directories and files", {
  files_and_dirs_list <- test_graphql_github$get_files_and_dirs(
    files_tree_response = test_mocker$use("files_tree_response")
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
  files_structure <- test_graphql_github$get_files_structure_from_repo(
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
  files_structure_shallow <- test_graphql_github$get_files_structure_from_repo(
    org = "r-world-devs",
    repo = "GitStats",
    def_branch = "master",
    depth = 2L
  )
  expect_type(
    files_structure_shallow,
    "character"
  )
  files_structure <- test_mocker$use("files_structure")
  expect_true(
    length(files_structure_shallow) < length(files_structure)
  )
})

test_that("only files with certain pattern are retrieved", {
  md_files_structure <- test_graphql_github$filter_files_by_pattern(
    files_structure = test_mocker$use("files_structure"),
    pattern = "\\.md|\\.qmd|\\.Rmd"
  )
  files_structure <- test_mocker$use("files_structure")
  expect_true(
    length(md_files_structure) < length(files_structure)
  )
})

# public methods

test_graphql_github <- EngineGraphQLGitHub$new(
  gql_api_url = "https://api.github.com/graphql",
  token = Sys.getenv("GITHUB_PAT")
)

test_that("`pull_repos_from_org()` prepares formatted list", {
  mockery::stub(
    test_graphql_github$pull_repos_from_org,
    "private$pull_repos_page",
    test_mocker$use("gh_repos_page")
  )
  gh_repos_from_org <- test_graphql_github$pull_repos_from_org(
    org = "r-world-devs"
  )
  expect_list_contains(
    gh_repos_from_org[[1]],
    c(
      "id", "name", "stars", "forks", "created_at",
      "last_activity_at", "languages", "issues_open", "issues_closed",
      "contributors", "repo_url"
    )
  )
  test_mocker$cache(gh_repos_from_org)
})

test_that("`pull_commits_from_repos()` pulls commits from repos", {
  commits_from_repos <- test_graphql_github$pull_commits_from_repos(
    org = "r-world-devs",
    repo = "GitStats",
    since = "2023-01-01",
    until = "2023-02-28",
    verbose = FALSE
  )
  expect_gh_commit_gql_response(
    commits_from_repos[[1]][[1]]
  )
  test_mocker$cache(commits_from_repos)
})

test_that("`pull_releases_from_org()` pulls releases from the repositories", {
  releases_from_repos <- test_graphql_github$pull_release_logs_from_org(
    repos_names = c("GitStats", "shinyCohortBuilder"),
    org = "r-world-devs"
  )
  expect_github_releases_response(releases_from_repos)
  test_mocker$cache(releases_from_repos)
})

test_that("GitHub GraphQL Engine pulls files from organization", {
  github_files_response <- test_graphql_github$pull_files_from_org(
    org = "r-world-devs",
    repos = NULL,
    file_path = "LICENSE"
  )
  expect_github_files_response(github_files_response)
  test_mocker$cache(github_files_response)
})

test_that("GitHub GraphQL Engine pulls files from defined repositories", {
  github_files_response <- test_graphql_github$pull_files_from_org(
    org = "openpharma",
    repos = c("DataFakeR", "visR"),
    file_path = "README.md"
  )
  expect_github_files_response(github_files_response)
  expect_equal(length(github_files_response[["README.md"]]), 2)
})

test_that("GitHub GraphQL Engine pulls two files from a group", {
  github_files_response <- test_graphql_github$pull_files_from_org(
    org = "r-world-devs",
    repos = NULL,
    file_path = c("DESCRIPTION", "NAMESPACE")
  )
  expect_github_files_response(github_files_response)
  expect_true(
    all(
      c("DESCRIPTION", "NAMESPACE") %in%
        names(github_files_response)
    )
  )
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
