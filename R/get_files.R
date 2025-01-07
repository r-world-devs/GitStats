#' @title Get files
#' @name get_files
#' @description Pulls text files and their content.
#' @param gitstats A `GitStats` object.
#' @param pattern A regular expression. If defined, it pulls file structure for
#'   a repository matching this pattern. Can be defined if `file_path` stays
#'   `NULL`.
#' @param depth An optional integer. Defines level of directories to retrieve
#'   files from. E.g. if set to `0`, it will pull files only from root, if `1L`,
#'   will take data from `root` directory and directories visible in `root`
#'   directory. If left with no argument, will pull files from all directories.
#' @param file_path Optional. A standardized path to file(s) in repositories.
#'   May be a character vector if multiple files are to be pulled. Can be
#'   defined if `pattern` stays `NULL`.
#' @param cache A logical, if set to `TRUE` GitStats will retrieve the last
#'   result from its storage.
#' @param verbose A logical, `TRUE` by default. If `FALSE` messages and printing
#'   output is switched off.
#' @param progress A logical, by default set to `verbose` value. If `FALSE` no
#'   `cli` progress bar will be displayed.
#' @examples
#' \dontrun{
#'  rmd_files <- create_gitstats() |>
#'   set_github_host(
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs")
#'   ) %>%
#'   set_gitlab_host(
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC"),
#'     orgs = "mbtests"
#'   ) |>
#'  get_files(
#'    pattern = "\\.Rmd",
#'    depth = 2L
#'  )
#'
#' }
#' @return A data.frame.
#' @export
get_files <- function(gitstats,
                      pattern = NULL,
                      depth = Inf,
                      file_path = NULL,
                      cache = TRUE,
                      verbose = is_verbose(gitstats),
                      progress = verbose) {
  if (!is.null(pattern) && !is.null(file_path)) {
    cli::cli_abort(
      "Please choose either `pattern` or `file_path`.",
      call = NULL
    )
  }
  gitstats$get_files(
    pattern = pattern,
    depth = depth,
    file_path = file_path,
    cache = cache,
    verbose = verbose,
    progress = progress
  )
}
