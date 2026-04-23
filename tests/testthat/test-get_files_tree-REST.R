# ---- GitHub REST get_files_tree ----

test_that("get_files_tree for GitHub returns file paths from tree response", {
  github_tree_response <- list(
    sha = "abc123",
    tree = list(
      list(path = "R/main.R", type = "blob"),
      list(path = "R/utils.R", type = "blob"),
      list(path = "R", type = "tree"),
      list(path = "tests/test-main.R", type = "blob"),
      list(path = "tests", type = "tree"),
      list(path = "README.md", type = "blob")
    )
  )
  mockery::stub(
    test_rest_github$get_files_tree,
    "self$response",
    github_tree_response
  )
  result <- test_rest_github$get_files_tree(
    org = "test-org",
    repo = "test-repo",
    def_branch = "main",
    pattern = NULL,
    depth = Inf,
    verbose = FALSE
  )
  expect_type(result, "character")
  expect_length(result, 4)
  expect_in(c("R/main.R", "R/utils.R", "tests/test-main.R", "README.md"), result)
  expect_false("R" %in% result)
})

test_that("get_files_tree for GitHub filters by depth", {
  github_tree_response <- list(
    sha = "abc123",
    tree = list(
      list(path = "R/main.R", type = "blob"),
      list(path = "R/sub/deep.R", type = "blob"),
      list(path = "README.md", type = "blob")
    )
  )
  mockery::stub(
    test_rest_github$get_files_tree,
    "self$response",
    github_tree_response
  )
  result <- test_rest_github$get_files_tree(
    org = "test-org",
    repo = "test-repo",
    def_branch = "main",
    pattern = NULL,
    depth = 1,
    verbose = FALSE
  )
  expect_equal(result, "README.md", ignore_attr = TRUE)
})

test_that("get_files_tree for GitHub filters by pattern", {
  github_tree_response <- list(
    sha = "abc123",
    tree = list(
      list(path = "R/main.R", type = "blob"),
      list(path = "DESCRIPTION", type = "blob"),
      list(path = "README.md", type = "blob")
    )
  )
  mockery::stub(
    test_rest_github$get_files_tree,
    "self$response",
    github_tree_response
  )
  result <- test_rest_github$get_files_tree(
    org = "test-org",
    repo = "test-repo",
    def_branch = "main",
    pattern = "\\.R$",
    depth = Inf,
    verbose = FALSE
  )
  expect_equal(result, "R/main.R", ignore_attr = TRUE)
})

test_that("get_files_tree for GitHub returns NULL on error", {
  mockery::stub(
    test_rest_github$get_files_tree,
    "self$response",
    function(...) stop("API error")
  )
  result <- test_rest_github$get_files_tree(
    org = "test-org",
    repo = "test-repo",
    def_branch = "main",
    pattern = NULL,
    depth = Inf,
    verbose = FALSE
  )
  expect_null(result)
})

# ---- GitLab REST get_files_tree ----

test_that("get_files_tree for GitLab returns file paths from tree response", {
  gitlab_tree_response <- list(
    list(id = "def456", path = "R/main.R", type = "blob"),
    list(id = "def457", path = "R/utils.R", type = "blob"),
    list(id = "def458", path = "R", type = "tree"),
    list(id = "def459", path = "README.md", type = "blob")
  )
  mockery::stub(
    test_rest_gitlab$get_files_tree,
    "private$paginate_results",
    gitlab_tree_response
  )
  result <- test_rest_gitlab$get_files_tree(
    org = "test-group",
    repo = "test-repo",
    pattern = NULL,
    depth = Inf,
    verbose = FALSE
  )
  expect_type(result, "character")
  expect_length(result, 3)
  expect_in(c("R/main.R", "R/utils.R", "README.md"), result)
})

test_that("get_files_tree for GitLab filters by depth", {
  gitlab_tree_response <- list(
    list(id = "def456", path = "R/main.R", type = "blob"),
    list(id = "def457", path = "R/sub/deep.R", type = "blob"),
    list(id = "def458", path = "README.md", type = "blob")
  )
  mockery::stub(
    test_rest_gitlab$get_files_tree,
    "private$paginate_results",
    gitlab_tree_response
  )
  result <- test_rest_gitlab$get_files_tree(
    org = "test-group",
    repo = "test-repo",
    pattern = NULL,
    depth = 1,
    verbose = FALSE
  )
  expect_equal(result, "README.md", ignore_attr = TRUE)
})

test_that("get_files_tree for GitLab returns NULL on error", {
  mockery::stub(
    test_rest_gitlab$get_files_tree,
    "private$paginate_results",
    function(...) stop("API error")
  )
  result <- test_rest_gitlab$get_files_tree(
    org = "test-group",
    repo = "test-repo",
    pattern = NULL,
    depth = Inf,
    verbose = FALSE
  )
  expect_null(result)
})
