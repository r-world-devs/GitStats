#' @title Get information on commits.
#' @name get_commits
#' @description List all repositories for an organization, a team.
#' @param gitstats_obj  A GitStats object.
#' @param date_from A starting date to look commits for
#' @param date_until An end date to look commits for
#' @return A `GitStats` class object with updated `$commits` field.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   set_connection(
#'     api_url = "https://api.github.com",
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs", "openpharma", "pharmaverse")
#'   ) %>%
#'   set_connection(
#'     api_url = "https://gitlab.com/api/v4",
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC"),
#'     orgs = "erasmusmc-public-health"
#'   ) %>%
#'   get_commits(date_from = "2020-01-01")
#' }
#' @export
get_commits <- function(gitstats_obj,
                        date_from = NULL,
                        date_until = Sys.time()) {
  gitstats_obj$get_commits(
    date_from = date_from,
    date_until = date_until
  )

  return(invisible(gitstats_obj))
}
