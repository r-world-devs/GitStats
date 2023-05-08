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

  plt <- ggplot2::ggplot(commits_n,
                         ggplot2::aes(x = stats_date,
                                      y = commits_n,
                                      color = organization)) +
    ggplot2::geom_point() +
    ggplot2::geom_line(
      ggplot2::aes(group = organization),
      show.legend = F) +
    ggplot2::facet_wrap(platform ~.,
                        scales = "free_y",
                        ncol = 1,
                        strip.position = "right") +
    ggplot2::theme_minimal() +
    ggplot2::labs(y = "no. of commmits") +
    ggplot2::theme(legend.position = "bottom",
                   legend.title = ggplot2::element_blank(),
                   strip.background = ggplot2::element_rect(color = "black")
    )

  plotly::ggplotly(plt) %>%
    plotly::layout(legend = list(orientation = "h",
                                 title = ""))
}
