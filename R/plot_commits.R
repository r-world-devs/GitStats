#' @importFrom plotly ggplotly layout
#' @importFrom stringr str_remove_all
#' @importFrom lubridate floor_date

#' @title Plot commits data.
#' @name plot_commits
#' @param gitstats_obj  A GitStats object.
#' @param time_interval A character, specifying time interval to show statistics.
#' @return A plot.
#' @export
plot_commits <- function(gitstats_obj,
                         time_interval = c("month", "day", "week")) {

  time_interval <- match.arg(time_interval)

  commits_dt <- copy(gitstats_obj$show_commits())
  if (is.null(commits_dt)) {
    cli::cli_abort("No commits in `GitStats` object to plot.")
  }

  commits_dt[, row_no := 1:nrow(commits_dt)]
  commits_dt[, stats_date := lubridate::floor_date(committed_date,
                                                   unit = time_interval)]

  commits_dt[, platform := stringr::str_remove_all(api_url,
                                                   pattern = "(?<=com).*|(https://)"),
             .(row_no)][, row_no := NULL]

  commits_n <- commits_dt[, .(commits_n = .N),
                          by = .(stats_date = stats_date, platform, organization)]

  setorder(commits_n, stats_date)

  date_breaks_value <- switch(time_interval,
                              "day" = "1 week",
                              "month" = "1 month",
                              "week" = "2 weeks")

  plt <- ggplot2::ggplot(commits_n,
                         ggplot2::aes(x = stats_date,
                                      y = commits_n,
                                      color = organization)) +
    ggplot2::geom_point() +
    ggplot2::geom_line(
      ggplot2::aes(group = organization),
      show.legend = F) +
    ggplot2::scale_x_datetime(breaks = date_breaks_value,
                          expand = c(0,0)) +
    ggplot2::facet_wrap(platform ~.,
                        scales = "free_y",
                        ncol = 1,
                        strip.position = "right") +
    ggplot2::theme_minimal() +
    ggplot2::labs(y = "no. of commmits", x = "") +
    ggplot2::theme(legend.position = "bottom",
                   legend.title = ggplot2::element_blank(),
                   strip.background = ggplot2::element_rect(color = "black"),
                   axis.text.x = ggplot2::element_text(angle = 45,
                                                       vjust = 0.5)
    )

  plotly::ggplotly(plt) %>%
    plotly::layout(legend = list(orientation = "h",
                                 title = ""))
}
