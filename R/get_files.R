#' @title Get files
#' @name get_files
#' @description Pulls text files and their content.
#' @param gitstats A `GitStats` object.
#' @param pattern A regular expression. If defined, it pulls content of all
#'   files in a repository matching this pattern reaching to the level of
#'   directories defined by `depth` parameter. Works only if `file_path` stays
#'   `NULL`.
#' @param depth Defines level of directories to retrieve files from. E.g. if set
#'   to `0`, it will pull files only from `root`, if `1L`, will take data from
#'   `root` directory and directories visible in `root` directory. If left with
#'   no argument, will pull files from all directories.
#' @param file_path A specific path to file(s) in repositories. May be a
#'   character vector if multiple files are to be pulled. If defined, the
#'   function pulls content of this specific `file_path`. Can be defined only if
#'   `pattern` stays `NULL`.
#' @param cache A logical, if set to `TRUE` `GitStats` will retrieve the last
#'   result from its storage.
#' @param verbose A logical, `TRUE` by default. If `FALSE` messages and printing
#'   output is switched off.
#' @param progress A logical, by default set to `verbose` value. If `FALSE` no
#'   `cli` progress bar will be displayed.
#' @details `get_files()` may be used in two ways: either with `pattern` (with
#'   optional `depth`) or `file_path` argument defined.
#'
#'   In the first scenario, `GitStats` will pull first a files structure
#'   responding to the passed `pattern` and `depth` arguments and afterwards
#'   files content for all of these files. In the second scenario, `GitStats`
#'   will pull only the content of files for the specific `file_path` of the
#'   repository.
#'
#'   If user wants to pull a particular file or files, a `file_path` approach
#'   seems more reasonable, as it is a faster way since it omits pulling the
#'   whole file structure from the repo.
#'
#'   For example, if user wants to pull content of `README.md` and/or `NEWS.md`
#'   files placed in the `root` directories of the repositories, he should take
#'   the `file_path` approach as he already knows precisely paths of the files.
#'
#'   On the other hand, if user wants to pull specific type of files (e.g. all
#'   `.md` or `.Rmd` files in the repository), without knowing their path, it is
#'   recommended to use a `pattern` approach, which will trigger `GitStats` to
#'   find all the files in the repository on the given level of directories
#'   (`pattern` argument) and afterwards pull their content.
#'
#'   The latter approach is slower than the former but may be more useful
#'   depending on users' goals. Both approaches return data in the same format:
#'   `tibble` with data on `files`, namely their `path` and their `content`.
#'
#' @examples
#' \dontrun{
#'  git_stats <- create_gitstats() |>
#'   set_github_host(
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs")
#'   ) |>
#'   set_gitlab_host(
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC"),
#'     orgs = "mbtests"
#'   )
#'
#'  rmd_files <- get_files(
#'    gitstats = git_stats,
#'    pattern = "\\.Rmd",
#'    depth = 2L
#'  )
#'
#'  app_files <- get_files(
#'    gitstats = git_stats,
#'    file_path = c("R/app.R", "R/ui.R", "R/server.R")
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
