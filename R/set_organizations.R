#' @title Choose your organizations.
#' @name set_organizations
#' @description A method to set you organizations.
#' @param gitstats_obj A GitStats object.
#' @param ... A character vector of oganizations (repo owners or project
#'   groups).
#' @param api_url A url for connection.
#' @return A `GitStats` class object with added information on organizations
#'   into `$orgs` of a `client`.
#' @examples
#' \dontrun{
#' ### with one connection:
#' my_gitstats <- create_gitstats() %>%
#'   set_connection(
#'     api_url = "https://api.github.com",
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs")
#'   )
#'
#' my_gitstats %>%
#'   set_organizations("openpharma", "pharmaverse")
#'
#' ### with multiple connections - remember to specify
#' ### `api_url` when setting organizations:
#'
#' my_gitstats <- create_gitstats() %>%
#'   set_connection(
#'     api_url = "https://api.github.com",
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs")
#'   ) %>%
#'   set_connection(
#'     api_url = "https://gitlab.com/api/v4",
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC"),
#'     orgs = "erasmusmc-public-health"
#'   )
#'
#' my_gitstats %>%
#'   set_organizations(
#'     api_url = "https://api.github.com",
#'     "openpharma", "pharmaverse"
#'   )
#' }
#' @export
set_organizations <- function(gitstats_obj,
                              ...,
                              api_url = NULL) {
  gitstats_obj$set_organizations(
    api_url = api_url,
    ... = ...
  )

  return(invisible(gitstats_obj))
}
