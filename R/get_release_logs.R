#' @title Get release logs
#' @name get_release_logs
#' @description Pull release logs from repositories.
#' @inheritParams get_commits
#' @return A data.frame.
#' @examples
#' \dontrun{
#'  my_gitstats <- create_gitstats() %>%
#'   set_github_host(
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs", "openpharma")
#'   )
#'   get_release_logs(my_gistats, since = "2024-01-01")
#' }
#' @export
get_release_logs <- function(gitstats,
                             since = NULL,
                             until = Sys.Date() + lubridate::days(1),
                             cache = TRUE,
                             verbose = is_verbose(gitstats),
                             progress = verbose) {
  start_time <- Sys.time()
  if (is.null(since)) {
    cli::cli_abort(cli::col_red("You need to pass date to `since` parameter."), call = NULL)
  }
  release_logs <- gitstats$get_release_logs(
    since = since,
    until = until,
    cache = cache,
    verbose = verbose,
    progress = progress
  )
  end_time <- Sys.time()
  time_taken <- end_time - start_time
  if (verbose) {
    cli::cli_alert_success("Data pulled in {round(time_taken, 1)} {attr(time_taken, 'units')}")
  }
  return(release_logs)
}
