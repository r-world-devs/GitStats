
#' @title Get users data
#' @name get_users
#' @param gitstats A GitStats object.
#' @param logins A character vector of logins.
#' @param cache A logical, if set to `TRUE` GitStats will retrieve the last
#'   result from its storage.
#' @param verbose A logical, `TRUE` by default. If `FALSE` messages and
#'   printing output is switched off.
#' @examples
#' \dontrun{
#'  my_gitstats <- create_gitstats() %>%
#'   set_github_host(
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs")
#'   ) %>%
#'   set_gitlab_host(
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC"),
#'     orgs = "mbtests"
#'   )
#'  get_users(my_gitstats, c("maciekabanas", "marcinkowskak"))
#' }
#' @return A data.frame.
#' @export
get_users <- function(gitstats,
                      logins,
                      cache   = TRUE,
                      verbose = is_verbose(gitstats)) {
  start_time <- Sys.time()
  users <- gitstats$get_users(
    logins = logins,
    cache = cache,
    verbose = verbose
  )
  end_time <- Sys.time()
  time_taken <- end_time - start_time
  if (verbose) {
    cli::cli_alert_success("Data pulled in {round(time_taken, 1)} {attr(time_taken, 'units')}")
  }
  return(users)
}
