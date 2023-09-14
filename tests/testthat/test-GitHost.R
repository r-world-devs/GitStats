# public methods

test_host <- create_testhost(
  api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = c("openpharma", "r-world-devs")
)

test_that("GitHost gets users tables", {
  users_table <- test_host$pull_users(
    users = c("maciekbanas", "kalimu", "galachad")
  )
  expect_users_table(users_table)
})

# private methods

test_that("`check_if_public` and `set_host` work correctly", {
  test_host <- create_testhost(
    api_url = "https://api.github.com",
    mode = "private"
  )
  expect_true(
    test_host$check_if_public()
  )
  expect_equal(
    test_host$set_host(),
    "GitHub"
  )
  test_host <- create_testhost(
    api_url = "https://gitlab.com/api/v4",
    mode = "private"
  )
  expect_true(
    test_host$check_if_public()
  )
  expect_equal(
    test_host$set_host(),
    "GitLab"
  )
  test_host <- create_testhost(
    api_url = "https://code.internal.com/api/v4",
    mode = "private"
  )
  expect_false(
    test_host$check_if_public()
  )
  expect_equal(
    test_host$set_host(),
    "GitLab"
  )
  test_host <- create_testhost(
    api_url = "https://github.internal.com/api/v4",
    mode = "private"
  )
  expect_false(
    test_host$check_if_public()
  )
  expect_equal(
    test_host$set_host(),
    "GitHub"
  )
})

test_host <- create_testhost(
  api_url = "https://api.github.com",
  mode = "private"
)

test_that("`set_default_token` sets default token for public GitHub", {
  expect_snapshot(
    default_token <- test_host$set_default_token()
  )
  test_rest <- create_testrest(token = default_token,
                               mode = "private")
  expect_equal(
    test_rest$perform_request(
      endpoint = "https://api.github.com",
      token = default_token
    )$status,
    200
  )
})

test_that("`set_default_token` sets default token for GitLab", {
  test_gl_host <- create_testhost(
    api_url = "https://gitlab.com/api/v4",
    token = Sys.getenv("GITLAB_PAT_PUBLIC"),
    orgs = c("openpharma", "r-world-devs"),
    mode = "private"
  )
  expect_snapshot(
    withr::with_envvar(new = c("GITLAB_PAT" = Sys.getenv("GITLAB_PAT_PUBLIC")), {
      default_token <- test_gl_host$set_default_token()
    })
  )
  test_rest <- create_testrest(token = default_token,
                               mode = "private")
  expect_equal(
    test_rest$perform_request(
      endpoint = "https://gitlab.com/api/v4/projects",
      token = default_token
    )$status,
    200
  )
})

test_that("`test_token` works properly", {
  expect_true(
    test_host$test_token(Sys.getenv("GITHUB_PAT"))
  )
  expect_false(
    test_host$test_token("false_token")
  )
})
suppressMessages(
  test_host <- GitHost$new(
    api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = "r-world-devs"
  )
)
test_host <- test_host$.__enclos_env__$private

test_that("`setup_engine` adds engines to host", {
  expect_s3_class(
    test_host$setup_engine(type = "rest"),
    "EngineRest"
  )
  expect_s3_class(
    test_host$setup_engine(type = "graphql"),
    "EngineGraphQL"
  )
})

test_that("`set_gql_url()` correctly sets gql api url - for public GitHub", {
  expect_equal(
    test_host$set_gql_url("https://api.github.com"),
    "https://api.github.com/graphql"
  )
})

test_that("`set_gql_url()` correctly sets gql api url - for public GitLab", {
  expect_equal(
    test_host$set_gql_url("https://gitlab.com/api/v4"),
    "https://gitlab.com/api/graphql"
  )
})

test_that("GitHost pulls repos from orgs", {
  settings <- list(search_param = "org")
  expect_snapshot(
    gh_repos_table <- test_host$pull_repos_from_orgs(settings)
  )
  expect_repos_table(
    gh_repos_table
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

test_that("pull_repos returns table of repositories", {
  mockery::stub(
    test_host$pull_repos,
    "private$pull_repos_from_org",
    test_mocker$use("gh_repos_table")
  )
  expect_snapshot(
    repos_table <- test_host$pull_repos(
      settings = list(search_param = "org",
                      language = "All")
    )
  )
  expect_repos_table(
    repos_table
  )
})

test_that("pull_repos_contributors returns table with contributors", {

  repos_table_1 <- test_mocker$use("gh_repos_table")
  expect_snapshot(
    repos_table_2 <- test_host$pull_repos_contributors(repos_table_1)
  )
  expect_repos_table_with_contributors(repos_table_2)
  expect_gt(
    length(repos_table_2$contributors),
    0
  )
  expect_equal(nrow(repos_table_1), nrow(repos_table_2))

})
