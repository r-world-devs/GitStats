#' @importFrom stringr str_length str_replace

#' @noRd
#' @description Transform R date object into git time stamp
#' @param date A date.
#' @return A character (git time stamp format).
date_to_gts <- function(date) {
  date_format <- lubridate::as_date(date)
  posixt_format <- lubridate::as_datetime(date)
  if (lubridate::as_datetime(date_format) == lubridate::as_datetime(posixt_format)) {
    paste0(date, "T00:00:00Z")
  } else {
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

#' @noRd
#' @description Transform git time stamp format into Posixt
#' @param date_vector A character vector of dates obtained from Git API.
#' @return A vector of dates in Posixt format.
gts_to_posixt <- function(date_vector) {
  date_vector <- gsub("T", " ", gsub("Z", "", date_vector))
  lubridate::as_datetime(date_vector)
}

#' @noRd
retrieve_platform <- function(api_url) {
  stringr::str_remove_all(
    string = api_url,
    pattern = "(?<=com).*|(https://)|(api.)|(.com)"
  )
}

#' @noRd
#' @description A constructor for `commits_stats` class.
commits_stats <- function(object, time_interval) {
  stopifnot(inherits(object, "grouped_df"))
  object <- dplyr::ungroup(object)
  class(object) <- append(class(object), "commits_stats")
  attr(object, "time_interval") <- time_interval
  object
}

#' @noRd
standardize_dates <- function(dates) {
  purrr::discard(dates, is.null) %>%
    purrr::map_vec(lubridate::as_datetime)
}

#' @importFrom utils URLencode URLdecode

#' @noRd
#' @description Apply url encoding to string
url_encode <- function(url) {
  URLencode(url, reserved = TRUE)
}
