test_gitstats <- create_gitstats()

test_that("GitStats object is created", {
  expect_s3_class(test_gitstats, "GitStats")
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

test_that("GitStats prints the proper info.", {

  expect_snapshot(test_gitstats)

})

set_team(
  test_gitstats,
  team_name = "RWD-IE",
  "Adam Forys", "galachad",
  "Kamil Wais", "kalimu",
  "Krystian Igras", "krystian8207",
  "Karolina Marcinkowska", "marcinkowskak",
  "Kamil Koziej", "Cotau",
  "Maciej Banas", "maciekbanas"
)

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
