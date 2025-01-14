#' @title Create a `GitStats` object
#' @name create_gitstats
#' @examples
#' my_gitstats <- create_gitstats()
#' @return A `GitStats` object.
#' @export
create_gitstats <- function() {
  GitStats$new()
}

#' @title Get users data
#' @name get_users
#' @param gitstats A GitStats object.
#' @param logins A character vector of logins.
#' @param cache A logical, if set to `TRUE` GitStats will retrieve the last
#'   result from its storage.
#' @param verbose A logical, `TRUE` by default. If `FALSE` messages and
#'   printing output is switched off.
#' @examples
#' \dontrun{
#'  my_gitstats <- create_gitstats() %>%
#'   set_github_host(
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs")
#'   ) %>%
#'   set_gitlab_host(
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC"),
#'     orgs = "mbtests"
#'   )
#'  get_users(my_gitstats, c("maciekabanas", "marcinkowskak"))
#' }
#' @return A data.frame.
#' @export
get_users <- function(gitstats,
                      logins,
                      cache   = TRUE,
                      verbose = is_verbose(gitstats)) {
  gitstats$get_users(
    logins = logins,
    cache = cache,
    verbose = verbose
  )
}

#' @title Get data on package usage across repositories
#' @name get_R_package_usage
#' @description Wrapper over searching repositories by code blobs related to
#'   loading package (`library(package)` and `require(package)` in all files) or
#'   using it as a dependency (`package` in `DESCRIPTION` and `NAMESPACE`
#'   files).
#' @param gitstats A GitStats object.
#' @param packages A character vector, names of R packages to look for.
#' @param only_loading A boolean, if `TRUE` function will check only if package
#'   is loaded in repositories, not used as dependencies.
#' @param split_output Optional, a boolean. If `TRUE` will return a list of
#'   tables, where every element of the list stands for the package passed to
#'   `packages` parameter. If `FALSE`, will return only one table with name of
#'   the package stored in first column.
#' @param cache A logical, if set to `TRUE` GitStats will retrieve the last
#'   result from its storage.
#' @param verbose A logical, `TRUE` by default. If `FALSE` messages and printing
#'   output is switched off.
#' @return A `tibble` or `list` of `tibbles` depending on `split_output`
#'   parameter.
#' @examples
#' \dontrun{
#'  my_gitstats <- create_gitstats() %>%
#'   set_github_host(
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs", "openpharma")
#'   )
#'
#'  get_R_package_usage(
#'    gitstats = my_gitstats,
#'    packages = c("purrr", "shiny"),
#'    split_output = TRUE
#'  )
#' }
#' @export
get_R_package_usage <- function(gitstats,
                                packages,
                                only_loading = FALSE,
                                split_output = FALSE,
                                cache        = TRUE,
                                verbose      = is_verbose(gitstats)) {
  gitstats$get_R_package_usage(
    packages     = packages,
    only_loading = only_loading,
    split_output = split_output,
    cache        = cache,
    verbose      = verbose
  )
}

#' @title Get release logs
#' @name get_release_logs
#' @description Pull release logs from repositories.
#' @inheritParams get_commits
#' @return A data.frame.
#' @examples
#' \dontrun{
#'  my_gitstats <- create_gitstats() %>%
#'   set_github_host(
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs", "openpharma")
#'   )
#'   get_release_logs(my_gistats, since = "2024-01-01")
#' }
#' @export
get_release_logs <- function(gitstats,
                             since = NULL,
                             until = Sys.Date() + lubridate::days(1),
                             cache = TRUE,
                             verbose = is_verbose(gitstats),
                             progress = verbose) {
  if (is.null(since)) {
    cli::cli_abort(cli::col_red("You need to pass date to `since` parameter."), call = NULL)
  }
  gitstats$get_release_logs(
    since    = since,
    until    = until,
    cache    = cache,
    verbose  = verbose,
    progress = progress
  )
}

#' @title Show organizations set in `GitStats`
#' @name show_orgs
#' @description Retrieves organizations set or pulled by `GitStats`. Especially
#'   helpful when user is scanning whole git platform and wants to have a
#'   glimpse at organizations.
#' @param gitstats A GitStats object.
#' @return A vector of organizations.
#' @export
show_orgs <- function(gitstats) {
  gitstats$show_orgs()
}

#' @title Switch on verbose mode
#' @name verbose_on
#' @description Print all messages and output.
#' @param gitstats A GitStats object.
#' @return A GitStats object.
#' @export
verbose_on <- function(gitstats) {
  gitstats$verbose_on()
  return(invisible(gitstats))
}

#' @title Switch off verbose mode
#' @name verbose_off
#' @description Stop printing messages and output.
#' @param gitstats A GitStats object.
#' @return A GitStats object.
#' @export
verbose_off <- function(gitstats) {
  gitstats$verbose_off()
  return(invisible(gitstats))
}

#' @title Is verbose mode switched on
#' @name is_verbose
#' @param gitstats A GitStats object.
is_verbose <- function(gitstats) {
  gitstats$is_verbose()
}

#' @title Get data from `GitStats` storage
#' @name get_storage
#' @description Retrieves whole or particular data (see `storage` parameter)
#'   pulled earlier with `GitStats`.
#' @param gitstats A GitStats object.
#' @param storage A character, type of the data you want to get from storage:
#'   `commits`, `repositories`, `release_logs`, `users`, `files`,
#'   `files_structure`, `R_package_usage` or `release_logs`.
#' @return A list of tibbles (if `storage` set to `NULL`) or a tibble (if
#'   `storage` defined).
#' @examples
#' \dontrun{
#'  my_gitstats <- create_gitstats() %>%
#'   set_github_host(
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs", "openpharma")
#'   )
#'   get_release_logs(my_gistats, since = "2024-01-01")
#'   get_repos(my_gitstats)
#'
#'   release_logs <- get_storage(
#'     gitstats = my_gitstats,
#'     storage = "release_logs"
#'   )
#' }
#' @export
get_storage <- function(gitstats,
                        storage = NULL) {
  gitstats$get_storage(
    storage = storage
  )
}
