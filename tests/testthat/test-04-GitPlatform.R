test_host <- create_testhost(
  mode = "private"
)

# private methods

test_that("GitPlatform filters GitHub repositories' table by team members", {
  gh_repos_table <- test_mocker$use("gh_repos_table")
  expect_snapshot(
    result <- test_host$filter_repos_by_team(
      gh_repos_table,
      team = list(
        "Member1" = list(
          logins = "krystian8207"
        ),
        "Member2" = list(
          logins = "maciekbanas"
        )
      )
    )
  )
  expect_type(
    result,
    "list"
  )
  expect_length(
    result,
    length(gh_repos_table)
  )
  expect_gt(
    length(result$contributors),
    0
  )
  expect_true(
    all(grepl("krystian8207|maciekbanas", result$contributors))
  )
})

test_that("GitPlatform filters GitLab repositories' table by team members", {
  gl_repos_table <- test_mocker$use("gl_repos_table")
  expect_snapshot(
    result <- test_host$filter_repos_by_team(
      gl_repos_table,
      team = list(
        "Member1" = list(
          logins = "maciekbanas"
        )
      )
    )
  )
  expect_type(
    result,
    "list"
  )
  expect_length(
    result,
    length(gl_repos_table)
  )
  expect_gt(
    length(result$contributors),
    0
  )
  expect_true(
    all(result$contributors %in% c("maciekbanas"))
  )
})

test_that("GitPlatform filters repositories' table by languages", {
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
  expect_true(
    all(grepl("JavaScript", result$languages))
  )
})
