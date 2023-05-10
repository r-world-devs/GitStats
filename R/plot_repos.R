#' @importFrom plotly plot_ly
#' @importFrom utils head
#' @importFrom stringi stri_split_fixed
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
  repos_to_plot[, fullname := paste0(organization, "/", name)
                ][, fullname := factor(fullname, levels = unique(fullname)[order(last_activity_at, decreasing = TRUE)])]
  repos_to_plot[, platform := stringr::str_remove_all(api_url,
                                                   pattern = "(?<=com).*|(https://)"),
             .(row_no)][, row_no := NULL]

  plotly::plot_ly(repos_to_plot,
    y = ~fullname,
    x = ~last_activity_at,
    color = ~platform,
    type = "bar",
    orientation = "h",
    hoverinfo = "text",
    hovertext = ~paste("Repository: ", fullname, "\n",
                       "Last activity at: ", last_activity_at, "days ago \n",
                       "Platform: ", platform)

  ) %>%
    plotly::layout(
      margin = list(l = 0, r = 0, b = 20, t = 20, pad = 5),
      yaxis = list(title = ""),
      xaxis = list(title = "last activity - days ago"),
      legend = list(orientation = "h", title = list(text = "Platform"))
    )
}
