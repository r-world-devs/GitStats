#' @title Create a `GitStats` object
#' @name create_gitstats
#' @examples
#' my_gitstats <- create_gitstats()
#' @return A `GitStats` object.
#' @export
create_gitstats <- function() {
  GitStats$new()
}

#' @title Get data on repositories
#' @name get_repos
#' @description  Pulls data on all repositories for an organization, individual
#'   user or those with a given text in code blobs (`with_code` parameter) or a
#'   file (`with_files` parameter) and parse it into table format.
#' @param gitstats A GitStats object.
#' @param add_contributors A logical parameter to decide whether to add
#'   information about repositories' contributors to the repositories output
#'   (table). If set to `FALSE` it makes function run faster as, in the case of
#'   `org` search mode, it reaches only `GraphQL` endpoint with a query on
#'   repositories, and in the case of `code` search mode it reaches only
#'   `repositories REST API` endpoint. However, the pitfall is that the result
#'   does not convey information on contributors. \cr\cr When set to `TRUE` (by
#'   default), `GitStats` iterates additionally over pulled repositories and
#'   reaches to the `contributors APIs`, which makes it slower, but gives
#'   additional information.
#' @param with_code A character vector, if defined, GitStats will pull
#'   repositories with specified code phrases in code blobs.
#' @param in_files A character vector of file names. Works when `with_code` is
#'   set - then it searches code blobs only in files passed to `in_files`
#'   parameter.
#' @param with_files A character vector, if defined, GitStats will pull
#'   repositories with specified files.
#' @param cache A logical, if set to `TRUE` GitStats will retrieve the last
#'   result from its storage.
#' @param verbose A logical, `TRUE` by default. If `FALSE` messages and printing
#'   output is switched off.
#' @param progress A logical, by default set to `verbose` value. If `FALSE` no
#'   `cli` progress bar will be displayed.
#' @return A data.frame.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   set_github_host(
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs", "openpharma")
#'   ) %>%
#'   set_gitlab_host(
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC"),
#'     orgs = "mbtests"
#'   )
#' get_repos(my_gitstats)
#' get_repos(my_gitstats, add_contributors = FALSE)
#' get_repos(my_gitstats, with_code = "Shiny", in_files = "renv.lock")
#' get_repos(my_gitstats, with_files = "DESCRIPTION")
#' }
#' @export
get_repos <- function(gitstats,
                      add_contributors = TRUE,
                      with_code        = NULL,
                      in_files         = NULL,
                      with_files       = NULL,
                      cache            = TRUE,
                      verbose          = is_verbose(gitstats),
                      progress         = verbose) {
  gitstats$get_repos(
    add_contributors = add_contributors,
    with_code        = with_code,
    in_files         = in_files,
    with_files       = with_files,
    cache            = cache,
    verbose          = verbose,
    progress         = progress
  )
}

#' @title Get repository URLS
#' @name get_repos_urls
#' @description Pulls a vector of repositories URLs (web or API): either all for
#'   an organization or those with a given text in code blobs (`with_code`
#'   parameter) or a file (`with_files` parameter).
#' @param gitstats A GitStats object.
#' @param type A character, choose if `api` or `web` (`html`) URLs should be
#'   returned.
#' @param with_code A character vector, if defined, GitStats will pull
#'   repositories with specified code phrases in code blobs.
#' @param in_files A character vector of file names. Works when `with_code` is
#'   set - then it searches code blobs only in files passed to `in_files`
#'   parameter.
#' @param with_files A character vector, if defined, GitStats will pull
#'   repositories with specified files.
#' @param cache A logical, if set to `TRUE` GitStats will retrieve the last
#'   result from its storage.
#' @param verbose A logical, `TRUE` by default. If `FALSE` messages and printing
#'   output is switched off.
#' @param progress A logical, by default set to `verbose` value. If `FALSE` no
#'   `cli` progress bar will be displayed.
#' @return A character vector.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   set_github_host(
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs", "openpharma")
#'   ) %>%
#'   set_gitlab_host(
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC"),
#'     orgs = "mbtests"
#'   )
#' get_repos_urls(my_gitstats, type = "api")
#' get_repos_urls(my_gitstats, with_files = c("DESCRIPTION", "LICENSE"))
#' }
#' @export
get_repos_urls <- function(gitstats,
                           type       = "web",
                           with_code  = NULL,
                           in_files   = NULL,
                           with_files = NULL,
                           cache      = TRUE,
                           verbose    = is_verbose(gitstats),
                           progress   = verbose) {
  gitstats$get_repos_urls(
    type       = type,
    with_code  = with_code,
    in_files   = in_files,
    with_files = with_files,
    cache      = cache,
    verbose    = verbose,
    progress   = progress
  )
}

#' @title Get data on commits
#' @name get_commits
#' @description List all commits from all repositories for an organization or a
#'   vector of repositories.
#' @param gitstats A GitStats object.
#' @param since A starting date.
#' @param until An end date.
#' @param cache A logical, if set to `TRUE` GitStats will retrieve the last
#'   result from its storage.
#' @param verbose A logical, `TRUE` by default. If `FALSE` messages and printing
#'   output is switched off.
#' @param progress A logical, by default set to `verbose` value. If `FALSE` no
#'   `cli` progress bar will be displayed.
#' @return A data.frame.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   set_github_host(
#'     token = Sys.getenv("GITHUB_PAT"),
#'     repos = c("openpharma/DataFakeR", "openpharma/visR")
#'   ) %>%
#'   set_gitlab_host(
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC"),
#'     orgs = "mbtests"
#'   )
#'  get_commits(my_gitstats, since = "2018-01-01")
#' }
#' @export
get_commits <- function(gitstats,
                        since    = NULL,
                        until    = Sys.Date() + lubridate::days(1),
                        cache    = TRUE,
                        verbose  = is_verbose(gitstats),
                        progress = verbose) {
  if (is.null(since)) {
    cli::cli_abort(cli::col_red("You need to pass date to `since` parameter."), call = NULL)
  }
  gitstats$get_commits(
    since    = since,
    until    = until,
    cache    = cache,
    verbose  = verbose,
    progress = progress
  )
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
