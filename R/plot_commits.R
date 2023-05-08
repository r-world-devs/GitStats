#' @importFrom plotly plot_ly
#' @importFrom stringr str_remove_all
#' @importFrom lubridate ym

#' @title Plot commits data.
#' @name plot_commits
#' @param gitstats_obj  A GitStats object.
#' @param time_interval A character, specifying time interval to show statistics.
#' @return A plot.
#' @export
plot_commits <- function(gitstats_obj,
                         time_interval = c("month", "day", "week")) {

  time_interval <- match.arg(time_interval)

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
  commits_dt <- commits_dt %>%
    dplyr::mutate(
      platform = stringr::str_remove_all(
        api_url,
        pattern = "(?<=com).*|(https://)"))

  commits_n <- commits_dt[, .(commits_n = .N), by = .(stats_date, platform, organization)]
  commits_n <- commits_n[order(stats_date)]
  commits_n[, stats_date := lubridate::ym(stats_date)]

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
    ggplot2::labs(y = "no. of commmits", x = "") +
    ggplot2::theme(legend.position = "bottom",
                   legend.title = ggplot2::element_blank(),
                   strip.background = ggplot2::element_rect(color = "black")
    )

  plotly::ggplotly(plt) %>%
    plotly::layout(legend = list(orientation = "h",
                                 title = ""))
}
