#' @importFrom ggplot2 ggplot geom_point geom_line aes
#' @importFrom plotly ggplotly layout
#' @importFrom lubridate floor_date
#' @importFrom utils head
#' @importFrom stringr str_remove_all
#' @importFrom data.table setorder as.data.table

#' @title Plot Git Statistics.
#' @name gitstats_plot
#' @description A generic to plot statistics from repositories or commits.
#' @param stats_table A table with repository or commits statistics.
#' @param value_to_plot Value to be plotted.
#' @param value_decreasing A boolean to set ordering of a value on the plot.
#' @param plotly_mode A boolean, if TRUE, turns plot into interactive plotly.
#' @param n An integer, a maximum number of repos/organizations to show on the plot.
#' @return A plot.
#' @export
gitstats_plot <- function(stats_table = NULL,
                          value_to_plot = NULL,
                          plotly_mode = FALSE,
                          value_decreasing = TRUE,
                          n = NULL) {
  if (is.null(stats_table)) {
    cli::cli_abort("Prepare your stats first with `get_*_stats()` function.")
  }
  UseMethod("gitstats_plot")
}

#' @exportS3Method
gitstats_plot.repos_stats <- function(stats_table = NULL,
                                      value_to_plot = "last_activity",
                                      plotly_mode = FALSE,
                                      value_decreasing = TRUE,
                                      n = 10) {
  if (value_decreasing) {
    arrange_expression <- rlang::expr(
      eval(parse(text = value_to_plot))
    )
  } else {
    arrange_expression <- rlang::expr(
      dplyr::desc(eval(parse(text = value_to_plot)))
    )
  }
  repos_stats <- dplyr::as_tibble(stats_table) %>%
    dplyr::arrange(
      eval(arrange_expression)
    )
  repos_to_plot <- head(repos_stats, n) %>%
    dplyr::mutate(
      repository = factor(repository, levels = unique(repository)[
        order(.data[[value_to_plot]], decreasing = value_decreasing)])
    )
  plt <- ggplot2::ggplot(
    repos_to_plot,
    ggplot2::aes(
      x = repository,
      y = .data[[value_to_plot]],
      fill = platform
    )) +
    ggplot2::geom_bar(stat = "identity") +
    ggplot2::coord_flip() +
    ggplot2::theme_minimal() +
    ggplot2::labs(y = gsub("_", " ", value_to_plot), x = "")

  suppressMessages({
    if (plotly_mode) {
      plotly::ggplotly(plt) %>%
        plotly::layout(legend = list(
          orientation = "h",
          title = ""
        ))
    } else {
      plt
    }
  })
}

#' @exportS3Method
gitstats_plot.commits_stats <- function(stats_table = NULL,
                                       value_to_plot = "commits_n",
                                       plotly_mode = FALSE,
                                       value_decreasing = TRUE,
                                       n = NULL) {
  date_breaks_value <- switch(attr(stats_table, "time_interval"),
    "day" = "1 week",
    "month" = "1 month",
    "week" = "2 weeks"
  )
  plt <- ggplot2::ggplot(
    as.data.frame(stats_table),
    ggplot2::aes(
      x = stats_date,
      y = .data[[value_to_plot]],
      color = organization
    )
  ) +
    ggplot2::geom_point() +
    ggplot2::geom_line(
      ggplot2::aes(group = organization),
      show.legend = F
    ) +
    ggplot2::scale_x_datetime(
      breaks = date_breaks_value,
      expand = c(0, 0)
    ) +
    ggplot2::facet_wrap(platform ~ .,
      scales = "free_y",
      ncol = 1,
      strip.position = "right"
    ) +
    ggplot2::theme_minimal() +
    ggplot2::labs(y = value_to_plot, x = "") +
    ggplot2::theme(
      legend.position = "bottom",
      legend.title = ggplot2::element_blank(),
      strip.background = ggplot2::element_rect(color = "black"),
      axis.text.x = ggplot2::element_text(
        angle = 45,
        vjust = 0.5
      )
    )
  if (plotly_mode) {
    plotly::ggplotly(plt) %>%
      plotly::layout(legend = list(
        orientation = "h",
        title = ""
      ))
  } else {
    plt
  }
}
