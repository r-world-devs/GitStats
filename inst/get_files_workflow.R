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
  )

github_stats

get_files(
  gitstats = github_stats,
  pattern = "\\.R|\\.md|\\.qmd|\\.Rmd",
  depth = 0L, # only root
  verbose = FALSE
)

get_files(
  gitstats = github_stats,
  pattern = "\\.R|\\.md|\\.qmd|\\.Rmd",
  depth = 1L, # first tier of folders
  verbose = FALSE
)

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

rwdie_stats <- create_gitstats() |>
  set_gitlab_host(
    host = "code.roche.com",
    orgs = "RWDInsightsEngineering"
  )

get_files(
  gitstats = rwdie_stats,
  pattern = "\\.R|\\.md|\\.qmd|\\.Rmd",
  depth = 0L,
  verbose = FALSE
)

get_files(
  gitstats = rwdie_stats,
  pattern = "\\.R|\\.md|\\.qmd|\\.Rmd",
  depth = 1L,
  verbose = TRUE
)

get_files(
  gitstats = rwdie_stats,
  pattern = "\\.R|\\.md|\\.qmd|\\.Rmd",
  depth = 2L,
  verbose = TRUE
)

rwdie_stats |>
  get_files(file_path = "DESCRIPTION")
