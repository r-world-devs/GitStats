% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_files.R
\name{get_files}
\alias{get_files}
\title{Get files}
\usage{
get_files(
  gitstats,
  pattern = NULL,
  depth = Inf,
  file_path = NULL,
  cache = TRUE,
  verbose = is_verbose(gitstats),
  progress = verbose
)
}
\arguments{
\item{gitstats}{A \code{GitStats} object.}

\item{pattern}{A regular expression. If defined, it pulls content of all
files in a repository matching this pattern reaching to the level of
directories defined by \code{depth} parameter. Works only if \code{file_path} stays
\code{NULL}.}

\item{depth}{Defines level of directories to retrieve files from. E.g. if set
to \code{0}, it will pull files only from \code{root}, if \code{1L}, will take data from
\code{root} directory and directories visible in \code{root} directory. If left with
no argument, will pull files from all directories.}

\item{file_path}{A specific path to file(s) in repositories. May be a
character vector if multiple files are to be pulled. If defined, the
function pulls content of this specific \code{file_path}. Can be defined only if
\code{pattern} stays \code{NULL}.}

\item{cache}{A logical, if set to \code{TRUE} \code{GitStats} will retrieve the last
result from its storage.}

\item{verbose}{A logical, \code{TRUE} by default. If \code{FALSE} messages and printing
output is switched off.}

\item{progress}{A logical, by default set to \code{verbose} value. If \code{FALSE} no
\code{cli} progress bar will be displayed.}
}
\value{
A data.frame.
}
\description{
Pulls text files and their content.
}
\details{
\code{get_files()} may be used in two ways: either with \code{pattern} (with
optional \code{depth}) or \code{file_path} argument defined.

In the first scenario, \code{GitStats} will pull first a files structure
responding to the passed \code{pattern} and \code{depth} arguments and afterwards
files content for all of these files. In the second scenario, \code{GitStats}
will pull only the content of files for the specific \code{file_path} of the
repository.

If user wants to pull a particular file or files, a \code{file_path} approach
seems more reasonable, as it is a faster way since it omits pulling the
whole file structure from the repo.

For example, if user wants to pull content of \code{README.md} and/or \code{NEWS.md}
files placed in the \code{root} directories of the repositories, he should take
the \code{file_path} approach as he already knows precisely paths of the files.

On the other hand, if user wants to pull specific type of files (e.g. all
\code{.md} or \code{.Rmd} files in the repository), without knowing their path, it is
recommended to use a \code{pattern} approach, which will trigger \code{GitStats} to
find all the files in the repository on the given level of directories
(\code{pattern} argument) and afterwards pull their content.

The latter approach is slower than the former but may be more useful
depending on users' goals. Both approaches return data in the same format:
\code{tibble} with data on \code{files}, namely their \code{path} and their \code{content}.
}
\examples{
\dontrun{
 git_stats <- create_gitstats() |>
  set_github_host(
    token = Sys.getenv("GITHUB_PAT"),
    orgs = c("r-world-devs")
  ) |>
  set_gitlab_host(
    token = Sys.getenv("GITLAB_PAT_PUBLIC"),
    orgs = "mbtests"
  )

 rmd_files <- get_files(
   gitstats = git_stats,
   pattern = "\\\\.Rmd",
   depth = 2L
 )

 app_files <- get_files(
   gitstats = git_stats,
   file_path = c("R/app.R", "R/ui.R", "R/server.R")
 )

}
}
