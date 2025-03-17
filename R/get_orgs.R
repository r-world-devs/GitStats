#' @title Get data on organizations
#' @name get_orgs
#' @description  Pulls data on all organizations from a Git host and parses it
#'   into table format. Works only for internal hosts.
#' @param gitstats A GitStats object.
#' @param cache A logical, if set to `TRUE` GitStats will retrieve the last
#'   result from its storage.
#' @param verbose A logical, `TRUE` by default. If `FALSE` messages and printing
#'   output is switched off.
#' @return A data.frame.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   set_github_host(
#'     orgs = c("r-world-devs", "openpharma"),
#'     token = Sys.getenv("GITHUB_PAT")
#'   ) %>%
#'   set_gitlab_host(
#'     host = "mbtests",
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC")
#'   )
#' get_orgs(my_gitstats)
#' }
get_orgs <- function(gitstats,
                     cache = TRUE,
                     verbose = is_verbose(gitstats)) {
  gitstats$get_orgs(
    cache   = cache,
    verbose = verbose
  )
}
