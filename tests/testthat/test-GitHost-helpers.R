test_that("set_owner_types sets attributes to owners list", {
  mockery::stub(
    github_testhost_priv$set_owner_type,
    "graphql_engine$gql_response",
    test_fixtures$github_user_login
  )
  owner <- github_testhost_priv$set_owner_type(
    owners = c("test_user")
  )
  expect_equal(attr(owner[[1]], "type"), "user")
  expect_equal(owner[[1]], "test_user", ignore_attr = TRUE)

  mockery::stub(
    github_testhost_priv$set_owner_type,
    "graphql_engine$gql_response",
    test_fixtures$github_org_login
  )
  owner <- github_testhost_priv$set_owner_type(
    owners = c("test_org")
  )
  expect_equal(attr(owner[[1]], "type"), "organization")
  expect_equal(owner[[1]], "test_org", ignore_attr = TRUE)
})
