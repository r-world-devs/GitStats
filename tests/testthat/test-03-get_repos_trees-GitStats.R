test_that("GitStats pulls repos files trees from hosts", {
  mockery::stub(
    test_gitstats_priv$get_repos_trees_from_hosts,
    "host$get_files_structure",
    test_mocker$use("gh_files_structure_from_orgs")
  )
  repos_trees_from_hosts <- test_gitstats_priv$get_repos_trees_from_hosts(
    pattern = NULL,
    depth = Inf,
    verbose = FALSE,
    progress = FALSE
  )
  expect_s3_class(repos_trees_from_hosts, "tbl")
  expect_named(repos_trees_from_hosts,
               c("repo_id", "repo_name", "organization", "files_tree", "githost"))
  test_mocker$cache(repos_trees_from_hosts)
})

test_that("GitStats pulls repos trees", {
  mockery::stub(
    test_gitstats$get_repos_trees,
    "private$get_repos_trees_from_hosts",
    test_mocker$use("repos_trees_from_hosts")
  )
  repos_trees <- test_gitstats$get_repos_trees(
    pattern = NULL,
    depth = Inf,
    cache = FALSE,
    verbose = FALSE,
    progress = FALSE
  )
  expect_s3_class(repos_trees, "gitstats_repos_trees")
  test_mocker$cache(repos_trees)
})

test_that("GitStats makes use of stored data", {
  expect_snapshot(
    repos_trees <- test_gitstats$get_repos_trees(
      pattern = NULL,
      depth = Inf,
      cache = TRUE,
      verbose = TRUE,
      progress = FALSE
    )
  )
})

test_that("GitStats prints warning when no repos trees found", {
  mockery::stub(
    test_gitstats$get_repos_trees,
    "private$get_repos_trees_from_hosts",
    data.frame()
  )
  expect_snapshot(
    repos_trees <- test_gitstats$get_repos_trees(
      pattern = NULL,
      depth = Inf,
      cache = FALSE,
      verbose = TRUE,
      progress = FALSE
    )
  )
})

test_that("get_repos_trees pulls repos trees", {
  mockery::stub(
    get_repos_trees,
    "gitstats$get_repos_trees",
    test_mocker$use("repos_trees")
  )
  repos_trees <- get_repos_trees(
    gitstats = test_gitstats,
    pattern = NULL,
    depth = Inf,
    cache = TRUE,
    verbose = FALSE,
    progress = FALSE
  )
  expect_s3_class(repos_trees, "gitstats_repos_trees")
})
