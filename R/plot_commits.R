#' @importFrom plotly plot_ly

#' @title Plot commits data.
#' @name plot_commits
#' @param gitstats_obj  A GitStats object.
#' @param stats_by A character, specifying time interval to show statistics.
#' @return A plot.
#' @export
plot_commits <- function(gitstats_obj,
                         stats_by = c("day", "week", "month")) {
  stats_date <- committed_date <- .N <- organization <- NULL

  commits_dt <- gitstats_obj$show_commits()
  if (is.null(commits_dt)) {
    cli::cli_abort("No commits in `GitStats` object to plot.")
  }
  stats_by <- match.arg(stats_by)

  if (stats_by == "day") {
    commits_dt[, stats_date := committed_date]
  } else if (stats_by == "week") {
    commits_dt[, stats_date := paste(format(committed_date, "%-V"), format(committed_date, "%G"), sep = "-")]
  } else if (stats_by == "month") {
    commits_dt[, stats_date := as.Date(paste0(substring(committed_date, 1, 7), "-01"))]
  }

  commits_n <- commits_dt[, .(commits_n = .N), by = .(stats_date, organization)]
  commits_n <- commits_n[order(stats_date)]

  plotly::plot_ly(commits_n,
    x = ~stats_date,
    y = ~commits_n,
    color = ~organization,
    type = "scatter",
    mode = "lines+markers"
  ) %>%
    plotly::layout(title = 'Number of commits by organization',
                   legend = list(orientation = 'h'),
                   xaxis = list(title = ''),
                   yaxis = list(title = ''))
}
