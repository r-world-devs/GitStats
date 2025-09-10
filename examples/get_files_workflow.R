devtools::load_all(".")

test_gitstats <- create_gitstats() |>
  set_github_host(
    orgs = c("r-world-devs", "openpharma")
  ) |>
  set_gitlab_host(
    orgs = c("mbtests", "mbtestapps")
  )

get_files(
  gitstats = test_gitstats,
  file_path = c("LICENSE", "DESCRIPTION")
)

github_stats <- create_gitstats() |>
  set_github_host(
    orgs = c("r-world-devs"),
    repos = "openpharma/DataFakeR"
  ) |>
  set_gitlab_host(
    repos = "mbtests/graphql_tests"
  )

github_stats

get_files(
  gitstats = github_stats,
  file_path = "DESCRIPTION"
)

datafaker_stats <- create_gitstats() |>
  set_github_host(
    repos = "openpharma/DataFakeR"
  )

get_files(
  gitstats = datafaker_stats,
  file_path = "DESCRIPTION"
)

md_files <- get_files(
  gitstats = test_gitstats,
  pattern = "\\.md|\\.Rmd",
  depth = 2L
)

get_files(
  gitstats = test_gitstats,
  pattern = "DESCRIPTION|\\.md|\\.qmd|\\.Rmd",
  depth = 2L,
  verbose = FALSE
)
