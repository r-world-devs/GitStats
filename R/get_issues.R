#' @title Get data on issues
#' @name get_issues
#' @description List all issues from all repositories for an organization or a
#'   vector of repositories.
#' @param gitstats A `GitStats` object.
#' @param since A starting date.
#' @param until An end date.
#' @param state An optional character, by default `NULL`, may be set to "open"
#'   or "closed" if user wants one type of issues.
#' @param cache A logical, if set to `TRUE` GitStats will retrieve the last
#'   result from its storage.
#' @param verbose A logical, `TRUE` by default. If `FALSE` messages and printing
#'   output is switched off.
#' @param progress A logical, by default set to `verbose` value. If `FALSE` no
#'   `cli` progress bar will be displayed.
#' @return A table of `tibble` and `gitstats_issues` classes.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   set_github_host(
#'     token = Sys.getenv("GITHUB_PAT"),
#'     repos = c("openpharma/DataFakeR", "openpharma/visR")
#'   ) %>%
#'   set_gitlab_host(
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC"),
#'     orgs = "mbtests"
#'   )
#'  get_issues(my_gitstats, since = "2018-01-01", state = "open")
#' }
#' @export
get_issues <- function(gitstats,
                       since = NULL,
                       until = Sys.Date() + lubridate::days(1),
                       state = NULL,
                       cache = TRUE,
                       verbose = is_verbose(gitstats),
                       progress = verbose) {
  start_time <- Sys.time()
  if (is.null(since)) {
    cli::cli_abort(cli::col_red("You need to pass date to `since` parameter."), call = NULL)
  }
  issues <- gitstats$get_issues(
    since = since,
    until = until,
    state = state,
    cache = cache,
    verbose = verbose,
    progress = progress
  )
  end_time <- Sys.time()
  time_taken <- end_time - start_time
  if (verbose) {
    cli::cli_alert_success("Data pulled in {round(time_taken, 1)} {attr(time_taken, 'units')}")
  }
  return(issues)
}

#' @title Get issues statistics
#' @name get_issues_stats
#' @description Prepare statistics from the pulled issues data.
#' @details To make function work, you need first to get issues data with
#'   `GitStats`. See examples section.
#' @param issues A `gitstats_issue` S3 class table object (output of `get_issues()`).
#' @param time_aggregation A character, specifying time aggregation of
#'   statistics.
#' @param group_var Other grouping variable to be passed to `dplyr::group_by()`
#'   function apart from `stats_date` and `githost`. Could be: `author`,
#'   `state` or `organization`. Should be passed without
#'   quotation marks.
#' @return A table of `issues_stats` class.
#' @examples
#' \dontrun{
#'  my_gitstats <- create_gitstats() %>%
#'    set_github_host(
#'      token = Sys.getenv("GITHUB_PAT"),
#'      repos = c("r-world-devs/GitStats", "openpharma/visR")
#'    ) |>
#'    get_issues(my_gitstats, since = "2022-01-01") |>
#'    get_issues_stats(
#'      time_aggregation = "month",
#'      group_var = state
#'    )
#' }
#' @export
get_issues_stats <- function(issues,
                             time_aggregation = c("year", "month", "week", "day"),
                             group_var) {
  if (!inherits(issues, "gitstats_issues")) {
    cli::cli_abort(c(
      "x" = "`issues` must be a `gitstats_issues` object.",
      "i" = "Pull first your issues with `get_issues()` function."
    ))
  }
  issues <- issues |>
    dplyr::mutate(
      stats_date = lubridate::floor_date(
        created_at,
        unit = time_aggregation
      ),
      githost = retrieve_githost(api_url)
    )
  issues_stats <- issues |>
    dplyr::group_by(stats_date, githost, {{ group_var }}) |>
    dplyr::summarise(
      stats = dplyr::n()
    ) |>
    dplyr::arrange(
      stats_date
    )
  issues_stats <- set_issues_stats_class(
    object = issues_stats,
    time_aggregation = time_aggregation
  )
  return(issues_stats)
}

#' @noRd
#' @description A constructor for `issues_stats` class.
set_issues_stats_class <- function(object, time_aggregation) {
  stopifnot(inherits(object, "grouped_df"))
  object <- dplyr::ungroup(object)
  class(object) <- append(class(object), "gitstats_issues_stats")
  attr(object, "time_aggregation") <- time_aggregation
  object
}
