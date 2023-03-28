#' @title Setting connections
#' @name set_connection
#' @param api_url A character, url address of API.
#' @param token A token.
#' @param orgs A character vector of organisations (owners of repositories
#'   in case of GitHub and groups of projects in case of GitLab).
#' @param gitstats_obj A GitStats object.
#' @param set_org_limit An integer defining how many orgs API may pull.
#' @return A `GitStats` class object with added information on connection
#'   (`$clients` field).
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
#'     token = Sys.getenv("GITLAB_PAT"),
#'     orgs = "erasmusmc-public-health"
#'   )
#' }
#' @export
set_connection <- function(gitstats_obj,
                           api_url,
                           token,
                           orgs = NULL,
                           set_org_limit = 1000) {
  gitstats_obj$set_connection(
    api_url = api_url,
    token = token,
    orgs = orgs,
    set_org_limit = set_org_limit
  )

  return(invisible(gitstats_obj))
}
