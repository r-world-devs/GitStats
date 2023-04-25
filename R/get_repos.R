#' @title Get information on repositories
#' @name get_repos
#' @description  List all repositories for an organization, a team or by a
#'   keyword.
#' @param gitstats_obj A GitStats object.
#' @param print_out A boolean stating whether to print an output.
#' @return A `GitStats` class object with updated `$repos_dt` field.
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
#'   get_repos()
#'
#' }
#' @export
get_repos <- function(gitstats_obj,
                      print_out = TRUE) {
  gitstats_obj$get_repos(
    print_out = print_out
  )

  return(invisible(gitstats_obj))
}
