#' @importFrom stringr str_length str_replace

#' @description Transform R date object into git time stamp
#' @param date A date.
#' @return A character (git time stamp format).
date_to_gts <- function(date) {
  date_format <- as.Date(date)
  posixt_format <- as.POSIXct(date)

  if (stringr::str_length(date) == 10 && !is.null(date_format)) {
    paste0(date, "T00:00:00Z")
  } else if (stringr::str_length(date) == 19 && !is.null(posixt_format)) {
    stringr::str_replace(
      date,
      "^(.{10})(.*)$",
      "\\1T\\2"
    ) %>%
      stringr::str_replace(" ", "") %>%
      stringr::str_replace(
        "^(.{19})(.*)$",
        "\\1Z"
      )
  }
}

#' @description Transform git time stamp format into Posixt
#' @param date_vector A character vector of dates obtained from Git API.
#' @return A vector of dates in Posixt format.
gts_to_posixt <- function(date_vector) {
  date_vector <- gsub("T", " ", gsub("Z", "", date_vector))

  as.POSIXct(date_vector)
}
