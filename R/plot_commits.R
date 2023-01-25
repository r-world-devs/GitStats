#' @importFrom plotly plot_ly

#' @title Plot commits data.
#' @name plot_commits
#' @param gitstats_obj  A GitStats object.
#' @param stats_by A character, specifing time interval to show statistics.
#' @return A plot.
#' @export
plot_commits <- function(gitstats_obj,
                         stats_by = c("day", "week", "month")) {
  if (is.null(gitstats_obj$commits_dt)) {
    stop("You have to first construct your repos data.frame with 'get_commits' function.",
      call. = FALSE
    )
  }

  commits_dt <- gitstats_obj$commits_dt

  stats_by <- match.arg(stats_by)

  if (stats_by == "day") {
    commits_dt[, statsDate := committedDate]
  } else if (stats_by == "week") {
    commits_dt[, statsDate := paste(format(committedDate, "%-V"), format(committedDate, "%G"), sep = "-")]
  } else if (stats_by == "month") {
    commits_dt[, statsDate := as.Date(paste0(substring(committedDate, 1, 7), "-01"))]
  }

  commits_n <- commits_dt[, .(commits_n = .N), by = .(statsDate, organisation)]
  commits_n <- commits_n[order(statsDate)]

  plotly::plot_ly(commits_n,
    x = ~statsDate,
    y = ~commits_n,
    color = ~organisation,
    type = "scatter",
    mode = "lines+markers"
  )
}

#' @title Plot commits additions and deletions.
#' @name plot_commits_stats
#' @param gitstats_obj  A GitStats object.
#' @return A plot.
#' @export
plot_commit_lines <- function(gitstats_obj) {
  if (is.null(gitstats_obj$commits_dt)) {
    stop("You have to first construct your repos data.frame with 'get_commits' function.",
      call. = FALSE
    )
  }

  commits_dt <- gitstats_obj$commits_dt

  commits_dt[, deletions := -deletions]

  plotly::plot_ly(commits_dt) %>%
    plotly::add_trace(
      y = ~additions,
      x = ~committedDate,
      color = ~organisation,
      type = "bar"
    ) %>%
    plotly::add_trace(
      y = ~deletions,
      x = ~committedDate,
      color = ~organisation,
      type = "bar"
    ) %>%
    plotly::layout(
      yaxis = list(title = ""),
      xaxis = list(title = "")
    )
}
