test_engine <- Engine$new()
test_engine_priv <- environment(test_engine$initialize)$private

# private methods

test_that("Engine filters repositories' table by languages", {
  repos_table <- test_mocker$use("gh_repos_table")
  expect_snapshot(
    result <- test_engine_priv$filter_repos_by_language(
      repos_table,
      language = "JavaScript"
    )
  )
  expect_length(
    result,
    length(repos_table)
  )
  expect_true(
    all(grepl("JavaScript", result$languages))
  )
})
