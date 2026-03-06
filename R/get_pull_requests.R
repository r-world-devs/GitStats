#' @title Get data on pull requests
#' @name get_pull_requests
#' @description List all pull requests from all repositories for an organization or a
#'   vector of repositories.
#' @inheritParams get_issues
#' @return A table of `tibble` and `gitstats_pull_requests` classes.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() |>
#'   set_github_host(
#'     token = Sys.getenv("GITHUB_PAT"),
#'     repos = c("openpharma/DataFakeR", "openpharma/visR")
#'   ) |>
#'   set_gitlab_host(
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC"),
#'     orgs = "mbtests"
#'   )
#'  get_pull_requests(my_gitstats, since = "2018-01-01", state = "open")
#' }
#' @export
get_pull_requests <- function(gitstats,
                              since = NULL,
                              until = Sys.Date(),
                              state = NULL,
                              cache = TRUE,
                              verbose = FALSE,
                              progress = TRUE) {
  start_time <- Sys.time()
  if (is.null(since)) {
    cli::cli_abort(cli::col_red("You need to pass date to `since` parameter."), call = NULL)
  }
  pr <- gitstats$get_pull_requests(
    since = since,
    until = until,
    state = state,
    cache = cache,
    verbose = verbose,
    progress = progress
  )
  end_time <- Sys.time()
  time_taken <- end_time - start_time
  cli::cli_alert_success("Data pulled in {round(time_taken, 1)} {attr(time_taken, 'units')}")
  return(pr)
}

#' @title Get pull requests statistics
#' @name get_pull_requests_stats
#' @description Prepare statistics from the pulled pull requests data.
#' @details To make function work, you need first to get pull requests data with
#'   `GitStats`. See examples section.
#' @param pull_requests A `gitstats_pr_stats` S3 class table object (output of `get_pull_requests()`).
#' @inheritParams get_issues_stats
#' @return A table of `pull_requests_stats` class.
#' @examples
#' \dontrun{
#'  my_gitstats <- create_gitstats() |>
#'    set_github_host(
#'      token = Sys.getenv("GITHUB_PAT"),
#'      repos = c("r-world-devs/GitStats", "openpharma/visR")
#'    ) |>
#'    get_pull_requests(my_gitstats, since = "2022-01-01") |>
#'    get_pull_requests_stats(
#'      time_aggregation = "month",
#'      group_var = author
#'    )
#' }
#' @export
get_pull_requests_stats <- function(pull_requests,
                                    time_aggregation = c("year", "month", "week", "day"),
                                    group_var) {
  if (!inherits(pull_requests, "gitstats_pull_requests")) {
    cli::cli_abort(c(
      "x" = "`pull_requests` must be a `gitstats_issues` object.",
      "i" = "Pull first your pull_requests with `get_pull_requests()` function."
    ))
  }
  pull_requests <- pull_requests |>
    dplyr::mutate(
      created_at = lubridate::floor_date(
        created_at,
        unit = time_aggregation
      ),
      merged_at = lubridate::floor_date(
        merged_at,
        unit = time_aggregation
      )
    )
  pull_requests_stats <- pull_requests |>
    dplyr::group_by(state, created_at, {{ group_var }}) |>
    dplyr::summarise(
      stats = dplyr::n()
    ) |>
    dplyr::arrange(
      created_at
    )
  pull_requests_stats <- set_pr_stats_class(
    object = pull_requests_stats,
    time_aggregation = time_aggregation
  )
  return(pull_requests_stats)
}

set_pr_stats_class <- function(object, time_aggregation) {
  stopifnot(inherits(object, "grouped_df"))
  object <- dplyr::ungroup(object)
  class(object) <- append(class(object), "gitstats_pr_stats")
  attr(object, "time_aggregation") <- time_aggregation
  object
}
