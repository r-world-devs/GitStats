test_that("set_owner_types sets attributes to owners list", {
  mockery::stub(
    test_graphql_github$set_owner_type,
    "self$gql_response",
    test_fixtures$github_user_login
  )
  owner <- test_graphql_github$set_owner_type(
    owners = c("test_user")
  )
  expect_equal(attr(owner[[1]], "type"), "user")
  expect_equal(owner[[1]], "test_user", ignore_attr = TRUE)

  mockery::stub(
    test_graphql_github$set_owner_type,
    "self$gql_response",
    test_fixtures$github_org_login
  )
  owner <- test_graphql_github$set_owner_type(
    owners = c("test_org")
  )
  expect_equal(attr(owner[[1]], "type"), "organization")
  expect_equal(owner[[1]], "test_org", ignore_attr = TRUE)
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
