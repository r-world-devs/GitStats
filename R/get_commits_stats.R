#' @title Get commits statistics
#' @name get_commits_stats
#' @description Prepare statistics from the pulled commits data.
#' @details To make function work, you need first to get commits data with
#'   `GitStats`. See examples section.
#' @param commits A `commits_data` table (output of `get_commits()`).
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
