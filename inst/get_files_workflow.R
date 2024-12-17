devtools::load_all(".")

test_gitstats <- create_gitstats() |>
  set_github_host(
    orgs = c("r-world-devs", "openpharma")
  ) |>
  set_gitlab_host(
    orgs = c("mbtests", "mbtestapps")
  )

get_files_content(
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

get_files_content(
  gitstats = github_stats,
  file_path = "DESCRIPTION"
)

datafaker_stats <- create_gitstats() |>
  set_github_host(
    repos = "openpharma/DataFakeR"
  )

get_files_content(
  gitstats = datafaker_stats,
  file_path = "DESCRIPTION"
)

md_files_structure <- get_files_structure(
  gitstats = test_gitstats,
  pattern = "\\.md|.R",
  depth = 2L
)

get_files_content(test_gitstats)

md_files_structure <- get_files_structure(
  gitstats = test_gitstats,
  pattern = "DESCRIPTION|\\.md|\\.qmd|\\.Rmd",
  depth = 2L,
  verbose = FALSE
)
