#' @importFrom plotly plot_ly

#' @title Plot commits data.
#' @name plot_commits
#' @param gitstats_obj  A GitStats object.
#' @param time_interval A character, specifying time interval to show statistics.
#' @param group_by
#' @param panes A boolean to decide wether show stats in separate panes.
#' @return A plot.
#' @export
plot_commits <- function(gitstats_obj,
                         time_interval = "month",
                         group_by = "platform",
                         panes = FALSE) {

  time_interval <- match.arg(time_interval,
                             c("day", "month", "week"))
  group_by <- match.arg(group_by,
                        c("organization", "platform"))

  commits_dt <- gitstats_obj$show_commits()
  if (is.null(commits_dt)) {
    cli::cli_abort("No commits in `GitStats` object to plot.")
  }
  time_interval <- match.arg(time_interval)

  if (time_interval == "day") {
    commits_dt[, stats_date := committed_date]
  } else if (time_interval == "week") {
    commits_dt[, stats_date := paste(format(committed_date, "%-V"), format(committed_date, "%G"), sep = "-")]
  } else if (time_interval == "month") {
    commits_dt[, stats_date := as.Date(paste0(substring(committed_date, 1, 7), "-01"))]
  }

  commits_n <- commits_dt[, .(commits_n = .N), by = .(stats_date, api_url, organization)]
  commits_n[, platform := api_url]
  commits_n <- commits_n[order(stats_date)]

  if (!panes) {
    plotly::plot_ly(commits_n,
                    x = ~ stats_date,
                    y = ~ commits_n,
                    color = ~ eval(parse(text = group_by)),
                    type = "scatter",
                    mode = "lines+markers",
                    hoverinfo = "text",
                    hovertext = ~paste(eval(group_by), ": ", eval(parse(text = group_by)), "\n",
                                       "Date: ", stats_date, "\n",
                                       "Number of commits: ", commits_n)
    ) %>%
      plotly::layout(title = paste0('Number of commits by ', eval(group_by)),
                     legend = list(orientation = 'h'),
                     xaxis = list(title = ''),
                     yaxis = list(title = ''))
  } else {

  }

}
