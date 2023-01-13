#' @noRd
git_time_stamp <- function(date) {
  date <- as.Date(date)

  paste0(date, "T00:00:00")
}
