devtools::load_all(".")

test_gitstats <- create_gitstats() |>
  set_github_host(
    orgs = c("r-world-devs", "openpharma")
  ) |>
  set_gitlab_host(
    orgs = c("mbtests", "mbtestapps")
  )

md_files_structure <- get_files_structure(
  gitstats_obj = test_gitstats,
  pattern = "\\.md|.R",
  depth = 2L
)

get_files_content(test_gitstats)

purrr::imap(logo_files_structure[[1]]$openpharma, function(repository, repository_name) {
  create_gitstats() |>
    set_github_host(
      repos = paste0("openpharma/", repository_name)
    ) |>
    get_files_content(
      file_path = repository
    )
}) %>%
  purrr::list_rbind()

md_files_structure <- get_files_structure(
  gitstats_obj = test_gitstats,
  pattern = "\\.md|\\.qmd|\\.Rmd",
  depth = 2L,
  verbose = FALSE
)
