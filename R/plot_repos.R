#' @importFrom plotly plot_ly
#' @importFrom utils head
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
  fullname <- organization <- name <- last_activity_at <- NULL

  repos_dt <- gitstats_obj$show_repos()

  repos_to_plot <- head(repos_dt, repos_n)

  repos_to_plot[, fullname := paste0(organization, "/", name)][, fullname := factor(fullname, levels = unique(fullname)[order(last_activity_at, decreasing = TRUE)])]

  plotly::plot_ly(repos_to_plot,
    y = ~fullname,
    x = ~last_activity_at,
    color = ~organization,
    type = "bar",
    orientation = "h"
  ) %>%
    plotly::layout(
      yaxis = list(title = ""),
      xaxis = list(title = "last activity - days ago")
    )
}
