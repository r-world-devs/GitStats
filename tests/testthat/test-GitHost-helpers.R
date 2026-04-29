test_that("set_owner_types sets attributes to owners list", {
  mockery::stub(
    github_resolve_owner_type,
    "self$gql_response",
    test_fixtures$github_user_login
  )
  owner <- github_resolve_owner_type(
    owner = c("test_user"),
    gql_api_url = "https://gitlab.com/api/graphql",
    token = Sys.getenv("GITHUB_PAT"),
    user_or_org_query = test_mocker$use("gh_user_or_org_query"),
    verbose = TRUE
  )
  expect_equal(owner[[1]], "test_user")

  mockery::stub(
    github_resolve_owner_type,
    "self$gql_response",
    test_fixtures$github_org_login
  )
  owner <- github_resolve_owner_type(
    owner = c("test_org"),
    gql_api_url = "https://gitlab.com/api/graphql",
    token = Sys.getenv("GITHUB_PAT"),
    user_or_org_query = test_mocker$use("gh_user_or_org_query"),
    verbose = TRUE
  )
  expect_equal(owner[[1]], "test_org")
})

test_that("set_api_url works", {
  expect_equal({
    github_testhost_priv$set_api_url(
      host = "github.com"
    )
  }, "https://api.github.com")
  expect_equal({
    github_testhost_priv$set_api_url(
      host = "https://github.com"
    )
  }, "https://api.github.com")
  expect_equal({
    github_testhost_priv$set_api_url(
      host = "http://github.com"
    )
  }, "https://api.github.com")
  expect_equal({
    github_testhost_priv$set_api_url(
      host = "https://github.company.com"
    )
  }, "https://github.company.com/api/v3")
  expect_equal({
    gitlab_testhost_priv$set_api_url(
      host = "https://gitlab.com"
    )
  }, "https://gitlab.com/api/v4")
  expect_equal({
    gitlab_testhost_priv$set_api_url(
      host = "gitlab.com"
    )
  }, "https://gitlab.com/api/v4")
})

test_that("set_custom_api_url works", {
  expect_equal({
    gitlab_testhost_priv$set_custom_api_url(
      host = "http://gitlab.com"
    )
  }, "https://gitlab.com/api/v4")
  expect_equal({
    github_testhost_priv$set_custom_api_url(
      host = "http://github.company.com"
    )
  }, "https://github.company.com/api/v3")
})
