gh_org <- "r-world-devs"
gh_repo <- "GitStats"

gh_md_files_structure <- list(
  "GitStats" = c("README.md", "CONTRIBUTING.md", "NEWS.md"),
  "GitAI" = c("README.md"),
  "cohortBuilder" = c("README.md", "vignettes/overview.Rmd"),
  "shinyCohortBuilder" = c("README.md"),
  "shinyGizmo" = c("README.md")
)
test_mocker$cache(gh_md_files_structure)

test_that("get_files_structure_from_orgs() works", {
  gh_md_files_with_ids <- purrr::imap(test_mocker$use("gh_md_files_structure"), function(files, repo_name) {
    attr(files, "repo_id") <- paste0("R_", repo_name)
    files
  })
  mockery::stub(
    github_testhost_priv$get_files_structure_from_orgs,
    "private$get_files_structure_from_repos_data",
    gh_md_files_with_ids
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
    "private$get_files_structure_from_repos_data",
    test_mocker$use("gh_md_files_structure")
  )
  github_testhost_priv$searching_scope <- "org"
  github_testhost_priv$cached_repos <- list()
  expect_snapshot(
    gh_files_structure_from_orgs <- github_testhost_priv$get_files_structure_from_orgs(
      pattern = "\\.md|\\.qmd|\\.Rmd",
      depth = Inf,
      verbose = TRUE
    )
  )
  github_testhost_priv$cached_repos <- list()
  expect_snapshot(
    gh_files_structure_from_orgs <- github_testhost_priv$get_files_structure_from_orgs(
      pattern = NULL,
      depth = Inf,
      verbose = TRUE
    )
  )
})

test_that("get_files_structure_from_repos() works", {
  test_org <- "r-world-devs"
  attr(test_org, "type") <- "organization"
  mockery::stub(
    github_testhost_priv$get_files_structure_from_repos,
    "graphql_engine$set_owner_type",
    test_org
  )
  mockery::stub(
    github_testhost_priv$get_files_structure_from_repos,
    "private$get_files_structure_from_repos_data",
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
    "private$get_files_structure_from_repos_data",
    test_mocker$use("gh_md_files_structure")
  )
  github_testhost_priv$searching_scope <- "repo"
  github_testhost_priv$cached_repos <- list()
  expect_snapshot(
    gh_files_structure_from_repos <- github_testhost_priv$get_files_structure_from_repos(
      pattern = "\\.md|\\.qmd|\\.Rmd",
      depth = Inf,
      verbose = TRUE
    )
  )
  github_testhost_priv$cached_repos <- list()
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
    "private$get_files_structure_from_repos_data",
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

test_that("get_files_structure runs when scope is set to scan whole host", {
  github_testhost$.__enclos_env__$private$scan_all <- TRUE
  github_testhost$.__enclos_env__$private$orgs <- NULL
  mockery::stub(
    github_testhost$get_files_structure,
    "private$get_orgs_from_host",
    c("test_org")
  )
  mockery::stub(
    github_testhost$get_files_structure,
    "private$get_files_structure_from_orgs",
    test_mocker$use("gh_files_structure_from_orgs")
  )
  files_structure <- github_testhost$get_files_structure(
    pattern = "\\.md|\\.qmd",
    depth = 1L,
    verbose = TRUE
  )
  expect_equal(
    names(files_structure),
    "r-world-devs"
  )
})

test_that("get_files_structure pulls empty files structure", {
  gh_empty_files_stucture <- github_testhost$get_files_structure(
    pattern = "\\.test",
    depth = 1L,
    verbose = FALSE,
    progress = FALSE
  )
  expect_type(
    gh_empty_files_stucture,
    "list"
  )
  expect_length(
    gh_empty_files_stucture,
    0L
  )
  test_mocker$cache(gh_empty_files_stucture)
})
