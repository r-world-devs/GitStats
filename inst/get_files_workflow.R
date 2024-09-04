devtools::load_all(".")

test_gitstats <- create_gitstats() |>
  set_github_host(
    repos = c("r-world-devs/dbplyr", "r-world-devs/MegaStudy", "openpharma/visR")
  )

files_structure <- get_files_structure(
  gitstats_obj = test_gitstats,
  pattern = "\\.md"
)

file_content <- purrr::map(files_structure[[1]], function(org) {
  purrr::map(org, function(repo_files) {
    get_files_content(
      gitstats_obj = test_gitstats,
      file_path = repo_files,
      verbose = FALSE
    )
  }) |>
    purrr::list_rbind()
}) |>
  purrr::list_rbind()

test_gitstats <- create_gitstats() |>
  set_github_host(
    orgs = "r-world-devs"
  )

files_structure <- get_files_structure(
  gitstats_obj = test_gitstats,
  pattern = "\\.md",
  depth = 2L
)
