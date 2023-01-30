gs_mock <- function(name = "", func_call) {

  rds_file <- paste0("tests/testthat/mocked/", name, ".rds")

  if (!file.exists(rds_file)) {
    browser()
    saveRDS(func_call, rds_file)
  } else {

  }

}
