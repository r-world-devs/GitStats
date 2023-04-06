#' @title Get information on repositories
#' @name get_repos
#' @description  List all repositories for an organization, a team or by a
#'   keyword.
#' @param gitstats_obj A GitStats object.
#' @param by A character, to choose between: \itemize{\item{org - organizations
#'   (owners of repositories)} \item{team - A team} \item{phrase - A keyword in
#'   code blobs.}}
#' @param phrase A character, phrase to look for in codelines.
#' @param language A character specifying language used in repositories.
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
#'   get_repos(language = "R")
#'
#' my_gitstats$get_repos(
#'   by = "phrase",
#'   phrase = "diabetes",
#'   language = "R"
#' )
#' }
#' @export
get_repos <- function(gitstats_obj,
                      by = gitstats_obj$search_param,
                      phrase = gitstats_obj$phrase,
                      language = gitstats_obj$language,
                      print_out = TRUE) {
  gitstats_obj$get_repos(
    by = by,
    phrase = phrase,
    language = language,
    print_out = print_out
  )

  return(invisible(gitstats_obj))
}
