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
