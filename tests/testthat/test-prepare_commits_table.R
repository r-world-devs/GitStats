test_github <- GitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = c("r-world-devs")
)
test_github_priv <- environment(test_github$initialize)$private

test_that("`GitService` parses commits list into table", {
  commits_cut <- readRDS("test_files/github_commits_with_stats.rds")

  result <- test_github_priv$prepare_commits_table(commits_cut)
  commit_cols <- c("id", "organisation", "repository", "committed_date", "additions", "deletions", "api_url")
  expect_s3_class(result, "data.frame") %>%
    expect_named(commit_cols)
  expect_gt(nrow(result), 0)
  expect_type(result$additions, "integer")
  expect_type(result$deletions, "integer")
})
