test_gitstats <- create_gitstats()

test_that("GitStats object is created", {
  expect_s3_class(test_gitstats, "GitStats")
})

test_that("GitStats prints empty fields.", {

  expect_snapshot(test_gitstats)

})

test_gitstats$clients[[1]] <- GitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = c("r-world-devs", "openpharma")
)

test_gitstats$clients[[2]] <- GitLab$new(
  rest_api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT"),
  orgs = "mbtests"
)

test_that("GitStats prints the proper info when connections are added.", {

  expect_snapshot(test_gitstats)

})

suppressMessages({
  setup_preferences(
    test_gitstats,
    search_param = "team",
    team_name = "RWD-IE"
  )
})

test_that("GitStats prints team name when team is added.", {

  expect_snapshot(test_gitstats)

})

set_storage(
  gitstats_obj = test_gitstats,
  type = "SQLite",
  dbname = "test_files/test_db"
)

test_that("GitStats prints storage properly.", {
  expect_snapshot(test_gitstats)
})
