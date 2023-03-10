test_gitstats <- create_gitstats()

test_github <- GitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = c("r-world-devs")
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
    readRDS("test_files/github_commits_by_org.rds")
  )
  result <- test_github$get_commits(
      date_from = "2023-01-01",
      by = "org"
    )
  commit_cols <- c("id", "organisation", "repository", "committed_date", "additions", "deletions", "api_url")
  expect_s3_class(result, "data.frame") %>%
    expect_named(commit_cols)
  expect_gt(nrow(result), 0)
  expect_type(result$additions, "integer")
  expect_type(result$deletions, "integer")
})
