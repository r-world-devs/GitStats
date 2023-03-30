#' @importFrom plotly plot_ly

#' @title Plot commits data.
#' @name plot_commits
#' @param gitstats_obj  A GitStats object.
#' @param stats_by A character, specifying time interval to show statistics.
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
    commits_dt[, statsDate := committed_date]
  } else if (stats_by == "week") {
    commits_dt[, statsDate := paste(format(committed_date, "%-V"), format(committed_date, "%G"), sep = "-")]
  } else if (stats_by == "month") {
    commits_dt[, statsDate := as.Date(paste0(substring(committed_date, 1, 7), "-01"))]
  }

  commits_n <- commits_dt[, .(commits_n = .N), by = .(statsDate, organization)]
  commits_n <- commits_n[order(statsDate)]

  plotly::plot_ly(commits_n,
    x = ~statsDate,
    y = ~commits_n,
    color = ~organization,
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

  plotly::plot_ly(commits_dt) %>%
    plotly::add_trace(
      y = ~additions,
      x = ~committed_date,
      color = ~organization,
      type = "bar"
    ) %>%
    plotly::add_trace(
      y = ~ (-deletions),
      x = ~committed_date,
      color = ~organization,
      type = "bar"
    ) %>%
    plotly::layout(
      yaxis = list(title = ""),
      xaxis = list(title = "")
    )
}
