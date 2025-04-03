#' @title Get data on commits
#' @name get_commits
#' @description List all commits from all repositories for an organization or a
#'   vector of repositories.
#' @param gitstats A `GitStats` object.
#' @param since A starting date.
#' @param until An end date.
#' @param cache A logical, if set to `TRUE` GitStats will retrieve the last
#'   result from its storage.
#' @param verbose A logical, `TRUE` by default. If `FALSE` messages and printing
#'   output is switched off.
#' @param progress A logical, by default set to `verbose` value. If `FALSE` no
#'   `cli` progress bar will be displayed.
#' @return A table of `tibble` and `gitstats_commits` classes.
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
#'  get_commits(my_gitstats, since = "2018-01-01")
#' }
#' @export
get_commits <- function(gitstats,
                        since = NULL,
                        until = Sys.Date() + lubridate::days(1),
                        cache = TRUE,
                        verbose = is_verbose(gitstats),
                        progress = verbose) {
  start_time <- Sys.time()
  if (is.null(since)) {
    cli::cli_abort(cli::col_red("You need to pass date to `since` parameter."), call = NULL)
  }
  commits <- gitstats$get_commits(
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
  return(commits)
}

#' @title Get commits statistics
#' @name get_commits_stats
#' @description Prepare statistics from the pulled commits data.
#' @details To make function work, you need first to get commits data with
#'   `GitStats`. See examples section.
#' @param commits A `gitstats_commits` S3 class table object (output of `get_commits()`).
#' @param time_aggregation A character, specifying time aggregation of
#'   statistics.
#' @param group_var Other grouping variable to be passed to `dplyr::group_by()`
#'   function apart from `stats_date` and `githost`. Could be: `author`,
#'   `author_login`, `author_name` or `organization`. Should be passed without
#'   quotation marks.
#' @return A table of `commits_stats` class.
#' @examples
#' \dontrun{
#'  my_gitstats <- create_gitstats() %>%
#'    set_github_host(
#'      token = Sys.getenv("GITHUB_PAT"),
#'      repos = c("r-world-devs/GitStats", "openpharma/visR")
#'    ) |>
#'    get_commits(my_gitstats, since = "2022-01-01") |>
#'    get_commits_stats(
#'      time_aggregation = "year",
#'      group_var = author
#'    )
#' }
#' @export
get_commits_stats <- function(commits,
                              time_aggregation = c("year", "month", "week", "day"),
                              group_var) {
  if (!inherits(commits, "gitstats_commits")) {
    cli::cli_abort(c(
      "x" = "`commits` must be a `gitstats_commits` object.",
      "i" = "Pull first your commits with `get_commits()` function."
    ))
  }
  commits <- commits |>
    dplyr::mutate(
      stats_date = lubridate::floor_date(
        committed_date,
        unit = time_aggregation
      ),
      githost = retrieve_platform(api_url)
    )
  commits_stats <- commits |>
    dplyr::group_by(stats_date, githost, {{ group_var }}) |>
    dplyr::summarise(
      stats = dplyr::n()
    ) |>
    dplyr::arrange(
      stats_date
    )
  commits_stats <- set_commits_stats_class(
    object = commits_stats,
    time_aggregation = time_aggregation
  )
  return(commits_stats)
}

#' @noRd
#' @description A constructor for `commits_stats` class.
set_commits_stats_class <- function(object, time_aggregation) {
  stopifnot(inherits(object, "grouped_df"))
  object <- dplyr::ungroup(object)
  class(object) <- append(class(object), "gitstats_commits_stats")
  attr(object, "time_aggregation") <- time_aggregation
  object
}
