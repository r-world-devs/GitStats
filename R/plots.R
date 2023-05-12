#' @importFrom ggplot2 ggplot geom_point geom_line aes
#' @importFrom plotly ggplotly layout
#' @importFrom lubridate floor_date
#' @importFrom utils head
#' @importFrom stringr str_remove_all
#' @importFrom data.table setorder as.data.table
#'
#' @title Plot repository data.
#' @name plot_repos
#' @description Plots top repositories by last activity.
#' @param gitstats_obj  A GitStats object.
#' @param repos_n An integer, a number of repos to show on the plot.
#' @return A plot.
#' @export
plot_repos <- function(gitstats_obj,
                       repos_n = 10) {
  repos_to_plot <- data.table::copy(gitstats_obj$show_repos())
  if (is.null(repos_to_plot)) {
    cli::cli_abort("No repositories in `GitStats` object to plot.")
  }

  data.table::setorder(repos_to_plot, last_activity_at)
  repos_to_plot <- data.table::as.data.table(head(repos_to_plot, repos_n))

  repos_to_plot[, row_no := 1:nrow(repos_to_plot)]
  repos_to_plot[, fullname := paste0(organization, "/", name)][, fullname := factor(fullname, levels = unique(fullname)[order(last_activity_at, decreasing = TRUE)])]
  repos_to_plot[
    , platform := stringr::str_remove_all(api_url,
      pattern = "(?<=com).*|(https://)"
    ),
    .(row_no)
  ][, row_no := NULL]

  plotly::plot_ly(repos_to_plot,
    y = ~fullname,
    x = ~last_activity_at,
    color = ~platform,
    type = "bar",
    orientation = "h",
    hoverinfo = "text",
    hovertext = ~ paste(
      "Repository: ", fullname, "\n",
      "Last activity at: ", last_activity_at, "days ago \n",
      "Platform: ", platform
    )
  ) %>%
    plotly::layout(
      margin = list(l = 0, r = 0, b = 20, t = 20, pad = 5),
      yaxis = list(title = ""),
      xaxis = list(title = "last activity - days ago"),
      legend = list(orientation = "h", title = list(text = "Platform"))
    )
}

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

  commits_dt[, row_no := 1:nrow(commits_dt)]
  commits_dt[, stats_date := lubridate::floor_date(committed_date,
    unit = time_interval
  )]

  commits_dt[
    , platform := stringr::str_remove_all(api_url,
      pattern = "(?<=com).*|(https://)"
    ),
    .(row_no)
  ][, row_no := NULL]

  commits_n <- commits_dt[, .(commits_n = .N),
    by = .(stats_date = stats_date, platform, organization)
  ]

  data.table::setorder(commits_n, stats_date)

  date_breaks_value <- switch(time_interval,
    "day" = "1 week",
    "month" = "1 month",
    "week" = "2 weeks"
  )

  plt <- ggplot2::ggplot(
    commits_n,
    ggplot2::aes(
      x = stats_date,
      y = commits_n,
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
    ggplot2::labs(y = "no. of commmits", x = "") +
    ggplot2::theme(
      legend.position = "bottom",
      legend.title = ggplot2::element_blank(),
      strip.background = ggplot2::element_rect(color = "black"),
      axis.text.x = ggplot2::element_text(
        angle = 45,
        vjust = 0.5
      )
    )

  plotly::ggplotly(plt) %>%
    plotly::layout(legend = list(
      orientation = "h",
      title = ""
    ))
}
