test_gitstats <- create_gitstats()

test_that("Error appears when no orgs are specified when pulling commits", {

  suppressMessages(
    test_gitstats$clients[[1]] <- GitHub$new(
      rest_api_url = "https://api.github.com",
      token = Sys.getenv("GITHUB_PAT")
    )
  )

  expect_snapshot_error(
    get_commits(
      gitstats_obj = test_gitstats,
      by = "org",
      date_from = "2020-01-01"
    )
  )
})

test_github <- GitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = c("openpharma")
)

test_gitstats$clients[[1]] <- test_github

test_that("Error shows when no `date_from` input to `get_commits`", {
  expect_error(
    test_gitstats %>%
      get_commits(),
    "You need to define"
  )
})

test_that("`GitHub` pulls commits and parses list into table", {
  mockery::stub(
    test_github$get_commits,
    'private$pull_commits_from_org',
    readRDS("test_files/github_commits_table.rds")
  )
  result <- test_github$get_commits(
      date_from = "2023-01-01",
      by = "org"
    )
  expect_commits_table(result)
})
