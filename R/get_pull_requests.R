#' @title Get data on pull requests
#' @name get_pull_requests
#' @description List all pull requests from all repositories for an organization or a
#'   vector of repositories.
#' @inheritParams get_issues
#' @return A table of `tibble` and `gitstats_pull_requests` classes.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() |>
#'   set_github_host(
#'     token = Sys.getenv("GITHUB_PAT"),
#'     repos = c("openpharma/DataFakeR", "openpharma/visR")
#'   ) |>
#'   set_gitlab_host(
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC"),
#'     orgs = "mbtests"
#'   )
#'  get_pull_requests(my_gitstats, since = "2018-01-01", state = "open")
#' }
#' @export
get_pull_requests <- function(gitstats,
                              since = NULL,
                              until = Sys.Date(),
                              state = NULL,
                              cache = TRUE,
                              verbose = FALSE,
                              progress = TRUE) {
  start_time <- Sys.time()
  if (is.null(since)) {
    cli::cli_abort(cli::col_red("You need to pass date to `since` parameter."), call = NULL)
  }
  pr <- gitstats$get_pull_requests(
    since = since,
    until = until,
    state = state,
    cache = cache,
    verbose = verbose,
    progress = progress
  )
  end_time <- Sys.time()
  time_taken <- end_time - start_time
  cli::cli_alert_success("Data pulled in {round(time_taken, 1)} {attr(time_taken, 'units')}")
  return(pr)
}
