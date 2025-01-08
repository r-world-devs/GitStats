#' @title Set GitHub host
#' @name set_github_host
#' @param gitstats A GitStats object.
#' @param host A character, optional, URL name of the host. If not passed, a
#'   public host will be used.
#' @param token A token.
#' @param orgs An optional character vector of organisations. If you pass it,
#'   `repos` parameter should stay `NULL`.
#' @param repos An optional character vector of repositories full names
#'   (organization and repository name, e.g. "r-world-devs/GitStats"). If you
#'   pass it, `orgs` parameter should stay `NULL`.
#' @param verbose A logical, `TRUE` by default. If `FALSE` messages and printing
#'   output is switched off.
#' @param .error A logical to control if passing wrong input
#'   (`repositories` and `organizations`) should end with an error or not.
#' @details If you do not define `orgs` and `repos`, `GitStats` will be set to
#'   scan whole Git platform (such as enterprise version of GitHub or GitLab),
#'   unless it is a public platform. In case of a public one (like GitHub) you
#'   need to define `orgs` or `repos` as scanning through all organizations may
#'   take large amount of time.
#' @return A `GitStats` object with added information on host.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   set_github_host(
#'     orgs = c("r-world-devs", "openpharma", "pharmaverse")
#'   )
#' }
#' @export
set_github_host <- function(gitstats,
                            host = NULL,
                            token = NULL,
                            orgs = NULL,
                            repos = NULL,
                            verbose = is_verbose(gitstats),
                            .error = TRUE) {
  gitstats$set_github_host(
    host = host,
    token = token,
    orgs = orgs,
    repos = repos,
    verbose = verbose,
    .error = .error
  )

  return(invisible(gitstats))
}

#' @title Set GitLab host
#' @name set_gitlab_host
#' @inheritParams set_github_host
#' @details If you do not define `orgs` and `repos`, `GitStats` will be set to
#'   scan whole Git platform (such as enterprise version of GitHub or GitLab),
#'   unless it is a public platform. In case of a public one (like GitHub) you
#'   need to define `orgs` or `repos` as scanning through all organizations may
#'   take large amount of time.
#' @return A `GitStats` object with added information on host.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   set_gitlab_host(
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC"),
#'     orgs = "mbtests"
#'   )
#' }
#' @export
set_gitlab_host <- function(gitstats,
                            host = NULL,
                            token = NULL,
                            orgs = NULL,
                            repos = NULL,
                            verbose = is_verbose(gitstats),
                            .error = TRUE) {
  gitstats$set_gitlab_host(
    host = host,
    token = token,
    orgs = orgs,
    repos = repos,
    verbose = verbose,
    .error = .error
  )

  return(invisible(gitstats))
}
