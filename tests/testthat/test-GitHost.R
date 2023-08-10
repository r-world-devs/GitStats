# public methods

test_host <- create_testhost(
  api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = c("openpharma", "r-world-devs")
)

test_that("GitHost gets users tables", {
  users_table <- test_host$get_users(
    users = c("maciekbanas", "kalimu", "galachad")
  )
  expect_users_table(users_table)
})

# private methods

test_host <- create_testhost(
  api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = c("openpharma", "r-world-devs"),
  mode = "private"
)

test_that("`set_gql_url()` correctly sets gql api url - for public and private github", {
  expect_equal(
    test_host$set_gql_url("https://api.github.com"),
    "https://api.github.com/graphql"
  )
})

test_that("GitHost filters GitHub repositories' (pulled by org) table by languages", {
  repos_table <- test_mocker$use("gh_repos_table")
  expect_snapshot(
    result <- test_host$filter_repos_by_language(
      repos_table,
      language = "JavaScript"
    )
  )
  expect_length(
    result,
    length(repos_table)
  )
  expect_gt(
    nrow(result),
    0
  )
  expect_true(
    all(grepl("JavaScript", result$languages))
  )
})

test_that("GitHost filters GitHub repositories' (pulled by team) table by languages", {
  repos_table <- test_mocker$use("gh_repos_table_team")
  expect_snapshot(
    result <- test_host$filter_repos_by_language(
      repos_table,
      language = "CSS"
    )
  )
  expect_length(
    result,
    length(repos_table)
  )
  expect_gt(
    nrow(result),
    0
  )
  expect_true(
    all(grepl("CSS", result$languages))
  )
})

test_that("GitHost filters GitHub repositories' (pulled by phrase) table by languages", {
  gh_repos_table <- test_mocker$use("gh_repos_by_phrase_table")
  expect_snapshot(
    result <- test_host$filter_repos_by_language(
      gh_repos_table,
      language = "R"
    )
  )
  expect_length(
    result,
    length(gh_repos_table)
  )
  expect_gt(
    nrow(result),
    0
  )
  expect_true(
    all(grepl("R", result$languages))
  )
})

test_that("GitHost filters GitLab repositories' (pulled by org) table by languages", {
  gl_repos_table <- test_mocker$use("gl_repos_table")
  expect_snapshot(
    result <- test_host$filter_repos_by_language(
      gl_repos_table,
      language = "Python"
    )
  )
  expect_length(
    result,
    length(gl_repos_table)
  )
  expect_gt(
    nrow(result),
    0
  )
  expect_true(
    all(grepl("Python", result$languages))
  )
})

test_that("GitHost filters GitLab repositories' (pulled by team) table by languages", {
  repos_table <- test_mocker$use("gl_repos_table_team")
  expect_snapshot(
    result <- test_host$filter_repos_by_language(
      repos_table,
      language = "Python"
    )
  )
  expect_length(
    result,
    length(repos_table)
  )
  expect_gt(
    nrow(result),
    0
  )
  expect_true(
    all(grepl("Python", result$languages))
  )
})

test_that("GitHost filters GitLab repositories' (pulled by phrase) table by languages", {
  gl_repos_table <- test_mocker$use("gl_repos_by_phrase_table")
  expect_snapshot(
    result <- test_host$filter_repos_by_language(
      gl_repos_table,
      language = "C"
    )
  )
  expect_length(
    result,
    length(gl_repos_table)
  )
  expect_gt(
    nrow(result),
    0
  )
  expect_true(
    all(grepl("C", result$languages))
  )
})

# public methods

test_host <- create_testhost(
  api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = c("openpharma", "r-world-devs")
)

test_that("add_repos_contributors returns table with contributors", {

  repos_table_1 <- test_mocker$use("gh_repos_table")
  expect_snapshot(
    repos_table_2 <- test_host$add_repos_contributors(repos_table_1)
  )
  expect_repos_table_with_contributors(repos_table_2)
  expect_gt(
    length(repos_table_2$contributors),
    0
  )
  expect_equal(nrow(repos_table_1), nrow(repos_table_2))

})
