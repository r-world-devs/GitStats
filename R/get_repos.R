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
#' @param language A character. If defined, GitStats will return only
#'   repositories with given language.
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
                      with_code = NULL,
                      in_files = NULL,
                      with_files = NULL,
                      language = NULL,
                      cache = TRUE,
                      verbose = is_verbose(gitstats),
                      progress = verbose) {
  start_time <- Sys.time()
  repos <- gitstats$get_repos(
    add_contributors = add_contributors,
    with_code = with_code,
    in_files = in_files,
    with_files = with_files,
    language = language,
    cache = cache,
    verbose = verbose,
    progress = progress
  )
  end_time <- Sys.time()
  time_taken <- end_time - start_time
  if (verbose) {
    cli::cli_alert_success("Data pulled in {round(time_taken, 1)} {attr(time_taken, 'units')}")
  }
  return(repos)
}

#' @title Get repository URLS
#' @name get_repos_urls
#' @description Pulls a vector of repositories URLs (web or API): either all for
#'   an organization or those with a given text in code blobs (`with_code`
#'   parameter) or a file (`with_files` parameter).
#' @param gitstats A GitStats object.
#' @param type A character, choose if `api` or `web` (`html`) URLs should be
#'   returned. `api` type is set by default as setting `web` results in parsing
#'   which may be time consuming in case of large number of repositories.
#' @param with_code A character vector, if defined, `GitStats` will pull
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
#' get_repos_urls(my_gitstats, with_files = c("DESCRIPTION", "LICENSE"))
#' }
#' @export
get_repos_urls <- function(gitstats,
                           type = "api",
                           with_code = NULL,
                           in_files = NULL,
                           with_files = NULL,
                           cache = TRUE,
                           verbose = is_verbose(gitstats),
                           progress = verbose) {
  start_time <- Sys.time()
  repos_urls <- gitstats$get_repos_urls(
    type = type,
    with_code = with_code,
    in_files = in_files,
    with_files = with_files,
    cache = cache,
    verbose = verbose,
    progress = progress
  )
  end_time <- Sys.time()
  time_taken <- end_time - start_time
  if (verbose) {
    cli::cli_alert_success("Data pulled in {round(time_taken, 1)} {attr(time_taken, 'units')}")
  }
  return(repos_urls)
}

#' @title Get data on files trees across repositories
#' @name get_repos_trees
#' @description Pulls files tree (structure) per repository. Files trees are
#'   then stored as character vectors in `files_tree` column of output table.
#' @param gitstats A GitStats object.
#' @param pattern A regular expression. If defined, it pulls structure of files
#'   in a repository matching this pattern reaching to the level of directories
#'   defined by `depth` parameter.
#' @param depth Defines level of directories to reach for files structure from.
#'   E.g. if set to `0`, it will pull files tree only from `root`, if `1L`, will
#'   take data from `root` directory and directories visible in `root`
#'   directory. If left with no argument, will pull files tree down to every
#'   directory in a repo.
#' @param cache A logical, if set to `TRUE` GitStats will retrieve the last
#'   result from its storage.
#' @param verbose A logical, `TRUE` by default. If `FALSE` messages and printing
#'   output is switched off.
#' @param progress A logical, by default set to `verbose` value. If `FALSE` no
#'   `cli` progress bar will be displayed.
#' @return A `tibble`.
#' @examples
#' \dontrun{
#'  my_gitstats <- create_gitstats() %>%
#'   set_github_host(
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs", "openpharma")
#'   )
#'
#'  get_repos_trees(
#'    gitstats = my_gitstats,
#'    pattern = "\\.md"
#'  )
#' }
#' @export
get_repos_trees <- function(gitstats,
                            pattern = NULL,
                            depth = Inf,
                            cache = TRUE,
                            verbose = is_verbose(gitstats),
                            progress = verbose) {
  start_time <- Sys.time()
  repos_trees <- gitstats$get_repos_trees(
    pattern = pattern,
    depth = depth,
    cache = cache,
    verbose = verbose,
    progress = progress
  )
  end_time <- Sys.time()
  time_taken <- end_time - start_time
  if (verbose) {
    cli::cli_alert_success("Data pulled in {round(time_taken, 1)} {attr(time_taken, 'units')}")
  }
  return(repos_trees)
}
