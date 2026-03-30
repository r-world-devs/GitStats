#' @title Enable parallel processing
#' @name set_parallel
#' @description Set up parallel processing for API calls using mirai daemons.
#'   When enabled, GitStats fetches data from multiple repositories
#'   concurrently. Call `set_parallel(FALSE)` or `set_parallel(0)` to revert
#'   to sequential execution.
#' @param workers Number of parallel workers. Set to `TRUE` for automatic
#'   detection, a positive integer for a specific count, or `FALSE`/`0` to
#'   disable parallelism.
#' @return Invisibly returns the status from `mirai::daemons()`.
#' @examples
#' \dontrun{
#'   my_gitstats <- create_gitstats() |>
#'     set_github_host(
#'       token = Sys.getenv("GITHUB_PAT"),
#'       orgs = c("r-world-devs", "openpharma")
#'     )
#'   set_parallel(4)
#'   get_commits(my_gitstats, since = "2024-01-01")
#'   set_parallel(FALSE) # revert to sequential
#' }
#' @export
set_parallel <- function(workers = TRUE) {
  if (isFALSE(workers) || identical(workers, 0L) || identical(workers, 0)) {
    status <- mirai::daemons(0)
    cli::cli_alert_info("Parallel processing disabled.")
  } else {
    if (isTRUE(workers)) {
      workers <- parallel::detectCores(logical = FALSE)
      if (is.na(workers) || workers < 2L) workers <- 2L
    }
    status <- mirai::daemons(workers)
    # Export all GitStats namespace objects to daemon global environments.
    # This works regardless of whether the package is installed or loaded
    # via devtools::load_all(). Using ... (not .args) so objects are
    # assigned to the daemon's global env where they can be found by name.
    ns <- asNamespace("GitStats")
    ns_objects <- as.list(ns, all.names = TRUE)
    do.call(mirai::everywhere, c(list(quote({})), ns_objects))
    cli::cli_alert_success(
      "Parallel processing enabled with {workers} workers."
    )
  }
  return(invisible(status))
}
