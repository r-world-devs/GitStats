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
                         group_by = "platform") {

  time_interval <- match.arg(time_interval,
                             c("day", "month", "week"))

  commits_dt <- data.table::copy(gitstats_obj$show_commits())
  if (is.null(commits_dt)) {
    cli::cli_abort("No commits in `GitStats` object to plot.")
  }
  # time_interval <- match.arg(time_interval)

  commits_dt[, stats_date := ifelse(time_interval == "day",
                                    as.Date(committed_date),
                                    ifelse(time_interval == "month",
                                           format(committed_date, '%Y-%m'),
                                           format(committed_date, "%G-%V")
                                    )),
             .(id)]
  commits_dt[, platform := stringi::stri_split_fixed(api_url,
                                                     "/",
                                                     omit_empty = T,
                                                     simplify = T)[2],
           .(id)]

  commits_n <- commits_dt[, .(commits_n = .N), by = .(stats_date, platform, organization)]
  commits_n <- commits_n[order(stats_date)]

  commits_n %>%
    split(commits_n$platform) %>%
    lapply(function(dt) {
      plotly::plot_ly(data = dt,
                      x = ~ stats_date,
                      y = ~ commits_n,
                      color = ~ organization,
                      type = "scatter",
                      mode = "lines+markers",
                      hoverinfo = "text",
                      hovertext = ~paste0("Repository: ", organization, "\n",
                                          "Date: ", stats_date, "\n",
                                          "Number of commits: ", commits_n)
      ) %>%
        plotly::layout(title = "",
                       legend = list(orientation = 'h'),
                       xaxis = list(title = ''),
                       yaxis = list(title = ''))
    }) %>%
    plotly::subplot(nrows = NROW(.),
                    margin = .05
                    ) %>%
    plotly::layout(yaxis = list(title = "no. of commits"))
}
