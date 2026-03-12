#' @title Create a `GitStats` object
#' @name create_gitstats
#' @examples
#' my_gitstats <- create_gitstats()
#' @return A `GitStats` object.
#' @export
create_gitstats <- function() {
  GitStats$new()
}

#' @title Enable parallel processing
#' @name set_parallel
#' @description Set up parallel processing for API calls. When enabled,
#'   GitStats will fetch data from multiple repositories concurrently.
#'   Call `set_parallel(FALSE)` or `set_parallel(0)` to revert to sequential
#'   execution.
#' @param workers Number of parallel workers. Set to `TRUE` for automatic
#'   detection (uses `future::availableCores()`), a positive integer for a
#'   specific count, or `FALSE`/`0` to disable parallelism.
#' @return Invisibly returns the previous plan.
#' @examples
#' \dontrun{
#'   set_parallel(4)
#'   get_commits(my_gitstats, since = "2024-01-01")
#'   set_parallel(FALSE) # revert to sequential
#' }
#' @export
set_parallel <- function(workers = TRUE) {
  if (isFALSE(workers) || identical(workers, 0L) || identical(workers, 0)) {
    old_plan <- future::plan(future::sequential)
    cli::cli_alert_info("Parallel processing disabled (sequential mode).")
  } else {
    if (isTRUE(workers)) {
      old_plan <- future::plan(future::multisession)
      cli::cli_alert_success(
        "Parallel processing enabled with {future::nbrOfWorkers()} workers."
      )
    } else {
      old_plan <- future::plan(future::multisession, workers = workers)
      cli::cli_alert_success(
        "Parallel processing enabled with {workers} workers."
      )
    }
  }
  return(invisible(old_plan))
}

#' @title Show hosts set in `GitStats`
#' @name show_hosts
#' @description Retrieves hosts set by `GitStats` with `set_*_host()` functions.
#' @param gitstats A GitStats object.
#' @return A list of hosts.
#' @export
show_hosts <- function(gitstats) {
  gitstats$show_hosts()
}

#' @title Show organizations set in `GitStats`
#' @name show_orgs
#' @description Retrieves organizations set or pulled by `GitStats`. Especially
#'   helpful when user is scanning whole git platform and wants to have a
#'   glimpse at organizations.
#' @param gitstats A GitStats object.
#' @return A vector of organizations.
#' @export
show_orgs <- function(gitstats) {
  gitstats$show_orgs()
}

#' @title Switch on verbose mode
#' @name verbose_on
#' @description Print all messages and output.
#' @param gitstats A GitStats object.
#' @return A GitStats object.
#' @export
verbose_on <- function(gitstats) {
  gitstats$verbose_on()
  return(invisible(gitstats))
}

#' @title Switch off verbose mode
#' @name verbose_off
#' @description Stop printing messages and output.
#' @param gitstats A GitStats object.
#' @return A GitStats object.
#' @export
verbose_off <- function(gitstats) {
  gitstats$verbose_off()
  return(invisible(gitstats))
}

#' @title Is verbose mode switched on
#' @name is_verbose
#' @param gitstats A GitStats object.
is_verbose <- function(gitstats) {
  gitstats$is_verbose()
}

#' @title Get data from `GitStats` storage
#' @name get_storage
#' @description Retrieves whole or particular data (see `storage` parameter)
#'   pulled earlier with `GitStats`.
#' @param gitstats A GitStats object.
#' @param storage A character, type of the data you want to get from storage:
#'   `commits`, `repositories`, `release_logs`, `users`, `files`,
#'   `files_structure`, `R_package_usage` or `release_logs`.
#' @return A list of tibbles (if `storage` set to `NULL`) or a tibble (if
#'   `storage` defined).
#' @examples
#' \dontrun{
#'  my_gitstats <- create_gitstats() |>
#'   set_github_host(
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs", "openpharma")
#'   )
#'   get_release_logs(my_gistats, since = "2024-01-01")
#'   get_repos(my_gitstats)
#'
#'   release_logs <- get_storage(
#'     gitstats = my_gitstats,
#'     storage = "release_logs"
#'   )
#' }
#' @export
get_storage <- function(gitstats,
                        storage = NULL) {
  gitstats$get_storage(
    storage = storage
  )
}
