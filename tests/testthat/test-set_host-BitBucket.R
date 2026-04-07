test_that("BitBucket testhost can be created with orgs", {
  bb_host <- create_bitbucket_testhost(
    orgs = "test_workspace"
  )
  expect_s3_class(bb_host, "GitHostBitBucketTest")
  bb_priv <- environment(bb_host$initialize)$private
  expect_equal(bb_priv$host_name, "BitBucket")
  expect_equal(bb_priv$api_url, "https://api.bitbucket.org/2.0")
  expect_equal(bb_priv$web_url, "https://bitbucket.org")
  expect_true("org" %in% bb_priv$searching_scope)
  expect_null(bb_priv$engines$graphql)
})

test_that("BitBucket testhost can be created with repos", {
  bb_host <- create_bitbucket_testhost(
    repos = c("my_workspace/repo1", "my_workspace/repo2")
  )
  bb_priv <- environment(bb_host$initialize)$private
  expect_true("repo" %in% bb_priv$searching_scope)
  expect_equal(bb_priv$orgs, "my_workspace")
  expect_equal(bb_priv$orgs_repos[["my_workspace"]], c("repo1", "repo2"))
})

test_that("BitBucket testhost sets correct API URL for custom host", {
  bb_host <- create_bitbucket_testhost(
    host = "https://bitbucket.mycompany.com",
    orgs = "team"
  )
  bb_priv <- environment(bb_host$initialize)$private
  expect_equal(bb_priv$api_url, "https://bitbucket.mycompany.com/api/v2.0")
})

test_that("BitBucket REST engine has correct endpoints", {
  bb_engine <- TestEngineRestBitBucket$new(
    token = "test_token",
    rest_api_url = "https://api.bitbucket.org/2.0"
  )
  bb_priv <- environment(bb_engine$initialize)$private
  expect_equal(
    bb_priv$endpoints[["repositories"]],
    "https://api.bitbucket.org/2.0/repositories/"
  )
  expect_equal(
    bb_priv$endpoints[["workspaces"]],
    "https://api.bitbucket.org/2.0/workspaces/"
  )
})

test_that("set_bitbucket_host method exists on GitStats object", {
  gs <- create_gitstats()
  expect_true("set_bitbucket_host" %in% names(gs))
})

test_that("check_for_host error message mentions BitBucket", {
  gs <- create_gitstats()
  expect_error(
    gs$get_repos(),
    "set_bitbucket_host"
  )
})

test_that("BitBucket host prepare_repos_table produces correct output", {
  bb_engine <- TestEngineRestBitBucket$new(
    token = "test_token",
    rest_api_url = "https://api.bitbucket.org/2.0"
  )
  mock_repos <- list(
    list(
      uuid = "{abc-123}",
      slug = "my-repo",
      full_name = "my_workspace/my-repo",
      mainbranch = list(name = "main", target = list(hash = "abc123")),
      language = "R",
      created_on = "2024-01-15T10:30:00+00:00",
      updated_on = "2024-06-20T14:00:00+00:00",
      links = list(
        html = list(href = "https://bitbucket.org/my_workspace/my-repo"),
        self = list(href = "https://api.bitbucket.org/2.0/repositories/my_workspace/my-repo")
      )
    )
  )
  repos_table <- bb_engine$prepare_repos_table(mock_repos, org = "my_workspace")
  expect_s3_class(repos_table, "data.frame")
  expect_equal(nrow(repos_table), 1)
  expect_equal(repos_table$repo_name, "my-repo")
  expect_equal(repos_table$organization, "my_workspace")
  expect_equal(repos_table$default_branch, "main")
  expect_equal(repos_table$languages, "R")
  expect_equal(repos_table$repo_id, "{abc-123}")
})

test_that("BitBucket host prepare_repos_table handles empty list", {
  bb_engine <- TestEngineRestBitBucket$new(
    token = "test_token",
    rest_api_url = "https://api.bitbucket.org/2.0"
  )
  result <- bb_engine$prepare_repos_table(list(), org = "ws")
  expect_null(result)
})

test_that("BitBucket tailor_commits_info produces correct structure", {
  bb_engine <- TestEngineRestBitBucket$new(
    token = "test_token",
    rest_api_url = "https://api.bitbucket.org/2.0"
  )
  mock_commits <- list(
    "ws/repo1" = list(
      list(
        hash = "deadbeef",
        date = "2024-03-10T12:00:00+00:00",
        author = list(
          raw = "John Doe <john@example.com>",
          user = list(display_name = "John Doe", nickname = "johnd")
        ),
        repository = list(
          full_name = "ws/repo1",
          links = list(html = list(href = "https://bitbucket.org/ws/repo1"))
        )
      )
    )
  )
  tailored <- bb_engine$tailor_commits_info(mock_commits, org = "ws")
  expect_length(tailored, 1)
  commit <- tailored[[1]][[1]]
  expect_equal(commit$id, "deadbeef")
  expect_equal(commit$author, "John Doe")
  expect_equal(commit$repo_name, "repo1")
  expect_equal(commit$organization, "ws")
})

test_that("BitBucket unsupported methods raise informative errors", {
  bb_host <- create_bitbucket_testhost(orgs = "test_ws")
  expect_error(
    bb_host$get_users("someone"),
    "not yet supported for BitBucket"
  )
})

test_that("retrieve_githost handles BitBucket API URLs", {
  expect_equal(
    retrieve_githost("https://api.bitbucket.org/2.0"),
    "bitbucket"
  )
})

test_that("GitStats can include BitBucket host alongside GitHub", {
  gs <- create_test_gitstats(hosts = 0)
  gs$.__enclos_env__$private$hosts[[1]] <- create_github_testhost(
    orgs = "github_org"
  )
  gs$.__enclos_env__$private$hosts[[2]] <- create_bitbucket_testhost(
    orgs = "bb_workspace"
  )
  hosts <- gs$show_hosts()
  expect_length(hosts, 2)
  host_names <- purrr::map_chr(hosts, ~ .$host)
  expect_true("GitHub" %in% host_names)
  expect_true("BitBucket" %in% host_names)
})
